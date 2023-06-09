// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : Wallet.swift
// Description : Venom Wallet Manager

import EverscaleClientSwift
import Foundation
import LocalAuthentication
import SwiftExtensionsPack

public struct VenomWallet {
    private let client: TSDKClientModule

    public static let shared = VenomWallet()

    private init() {
        var config: TSDKClientConfig = .init()
        config.network = TSDKNetworkConfig(endpoints: ["https://venom-testnet.evercloud.dev/b1073504a34d403891e4c25e41582587/graphql"])

        client = try! TSDKClientModule(config: config)
    }

    public func generateSeedWords() async throws -> String {
        return try await client.crypto.mnemonic_from_random(.init(dictionary: .English, word_count: 12)).phrase
    }

    public func generateKeyPairWithSeedWords(words: String) async throws -> TSDKKeyPair {
        return try await client.crypto.mnemonic_derive_sign_keys(.init(phrase: words))
    }

    public func createVenomWallet(withPublicKey publicKey: String) async throws -> String {
        let walletCode = "te6cckEBBgEA/AABFP8A9KQT9LzyyAsBAgEgAgMABNIwAubycdcBAcAA8nqDCNcY7UTQgwfXAdcLP8j4KM8WI88WyfkAA3HXAQHDAJqDB9cBURO68uBk3oBA1wGAINcBgCDXAVQWdfkQ8qj4I7vyeWa++COBBwiggQPoqFIgvLHydAIgghBM7mRsuuMPAcjL/8s/ye1UBAUAmDAC10zQ+kCDBtcBcdcBeNcB10z4AHCAEASqAhSxyMsFUAXPFlAD+gLLaSLQIc8xIddJoIQJuZgzcAHLAFjPFpcwcQHLABLM4skB+wAAPoIQFp4+EbqOEfgAApMg10qXeNcB1AL7AOjRkzLyPOI+zYS/"
        let data = try await client.boc.encode_boc(
            TSDKParamsOfEncodeBoc(
                builder: [
                    TSDKBuilderOp(
                        type: TSDKBuilderOpEnumTypes.Integer,
                        size: 256,
                        value: AnyValue.string("0x\(publicKey)")
                    ),
                    TSDKBuilderOp(
                        type: TSDKBuilderOpEnumTypes.Integer,
                        size: 64,
                        value: AnyValue.uint64(0)
                    ),
                ]
            )
        )

        let boc = try await client.boc.encode_tvc(TSDKParamsOfEncodeTvc(code: walletCode, data: data.boc))
        return try await client.boc.get_boc_hash(TSDKParamsOfGetBocHash(boc: boc.state_init)).hash
    }

    public func saveToDeviceSecureEnclave(walletAddress: String, words: String, keyPair: TSDKKeyPair) {
        let removeQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                          kSecReturnData as String: true]
        print(SecItemDelete(removeQuery as CFDictionary))

        let access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .userPresence,
                                                     nil // Ignore any error.
        )

        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = 10

        // Insert wallet address into keychain
        let insertWalletAddressQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                                       kSecAttrApplicationTag as String: "rocketdan.venom.Chatter.walletAddress".data(using: .utf8)!,
                                                       kSecAttrAccessControl as String: access as Any,
                                                       kSecUseAuthenticationContext as String: context,
                                                       kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
                                                       kSecValueData as String: walletAddress.data(using: .utf8)!]
        let insertWalletAddressQueryStatus = SecItemAdd(insertWalletAddressQuery as CFDictionary, nil)
        if insertWalletAddressQueryStatus != errSecSuccess {
            print("[VenomWallet] Insert wallet address into keychain -> Error(\(insertWalletAddressQueryStatus))")
            return
        }

        // Insert keypair into keychain
        let insertKeyPairQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                                 kSecAttrApplicationTag as String: "rocketdan.venom.Chatter.keyPair".data(using: .utf8)!,
                                                 kSecAttrAccessControl as String: access as Any,
                                                 kSecUseAuthenticationContext as String: context,
                                                 kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
                                                 kSecValueData as String: "\(keyPair.public):\(keyPair.secret)".data(using: .utf8)!]
        let insertKeyPairQueryStatus = SecItemAdd(insertKeyPairQuery as CFDictionary, nil)
        if insertKeyPairQueryStatus != errSecSuccess {
            print("[VenomWallet] Insert keypair into keychain -> Error(\(insertKeyPairQueryStatus))")
            return
        }

        // Insert seed pharse into keychain
        let insertPharseQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                                kSecAttrAccessControl as String: access as Any,
                                                kSecUseAuthenticationContext as String: context,
                                                kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
                                                kSecAttrApplicationTag as String: "rocketdan.venom.Chatter.seedpharse".data(using: .utf8)!,
                                                kSecValueData as String: words.data(using: .utf8)!]
        let insertPharseQueryStatus = SecItemAdd(insertPharseQuery as CFDictionary, nil)
        if insertPharseQueryStatus != errSecSuccess {
            print("[VenomWallet] Insert phrase into keychain -> Error(\(insertPharseQueryStatus))")
            return
        }
    }

    public func requestDeviceBiometricPermission() {
        let context = LAContext()
        context.localizedReason = "Access your wallet on the device secure enclave area"
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: "rocketdan.venom.Chatter.walletAddress".data(using: .utf8)!,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecUseAuthenticationContext as String: context,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let rawWalletAddress = existingItem[kSecValueData as String] as? Data,
               let walletAddress = String(data: rawWalletAddress, encoding: String.Encoding.utf8)
            {
                print(walletAddress)
            }
        }
    }
}
