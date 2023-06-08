// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : WalletCreateLoadingScreen.swift
// Description : Name Input Screen

import AppResources
import EverscaleClientSwift
import Foundation
import SwiftExtensionsPack
import SwiftUI
import Utils

struct WalletCreateLoadingScreen: View {
    @State private var firstShapeAngle: Angle = .degrees(-45)
    @State private var firstShapeHeight: CGFloat = 54
    @State private var secondShapeAngle: Angle = .degrees(90)
    @State private var secondShapeHeight: CGFloat = 54
    @State private var thirdShapeAngle: Angle = .degrees(45)
    @State private var thirdShapeHeight: CGFloat = 54
    @State private var fourthShapeAngle: Angle = .degrees(0)
    @State private var fourthShapeHeight: CGFloat = 54

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 72) {
                Rectangle()
                    .frame(width: 6, height: firstShapeHeight)
                    .foregroundColor(Color("ColorBrandNeon", bundle: .appResources))
                    .rotationEffect(firstShapeAngle)
                Rectangle()
                    .frame(width: 6, height: secondShapeHeight)
                    .foregroundColor(Color("ColorBrandBlue", bundle: .appResources))
                    .rotationEffect(secondShapeAngle)
                Rectangle()
                    .frame(width: 6, height: thirdShapeHeight)
                    .foregroundColor(Color("ColorBrandCyan", bundle: .appResources))
                    .rotationEffect(thirdShapeAngle)
                Rectangle()
                    .frame(width: 6, height: fourthShapeHeight)
                    .foregroundColor(Color("ColorBrandGreen", bundle: .appResources))
                    .rotationEffect(fourthShapeAngle)
            }
            Spacer()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.0025, repeats: true) { _ in
                withAnimation(.easeOut) {
                    firstShapeAngle = firstShapeAngle + .degrees(0.5)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    firstShapeHeight = .random(in: 25 ... 54)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { _ in
                withAnimation(.easeOut) {
                    secondShapeAngle = secondShapeAngle - .degrees(1)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    secondShapeHeight = .random(in: 25 ... 54)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { _ in
                withAnimation(.easeInOut) {
                    thirdShapeAngle = thirdShapeAngle + .degrees(2)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    thirdShapeHeight = .random(in: 25 ... 54)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { _ in
                withAnimation(.easeInOut) {
                    fourthShapeAngle = fourthShapeAngle - .degrees(3)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    fourthShapeHeight = .random(in: 25 ... 54)
                }
            }

            Task {
                var config: TSDKClientConfig = .init()
                config.network = TSDKNetworkConfig(endpoints: ["https://venom-testnet.evercloud.dev/b1073504a34d403891e4c25e41582587/graphql"])

                let client: TSDKClientModule = try TSDKClientModule(config: config)
                let seedWords = try await client.crypto.mnemonic_from_random(.init(dictionary: .English, word_count: 12))

                print("========== [SeedWords] ==========================================================")
                print("\(seedWords.phrase)")
                print("=================================================================================\n")

                let generatedKeyPair = try await client.crypto.mnemonic_derive_sign_keys(.init(phrase: seedWords.phrase))

                print("========== [SeedBasedKeyPair] ===================================================")
                print("Private Key : \(generatedKeyPair.secret)")
                print("Public Key : \(generatedKeyPair.public)")
                print("=================================================================================\n")

                let walletCode = "te6cckEBBgEA/AABFP8A9KQT9LzyyAsBAgEgAgMABNIwAubycdcBAcAA8nqDCNcY7UTQgwfXAdcLP8j4KM8WI88WyfkAA3HXAQHDAJqDB9cBURO68uBk3oBA1wGAINcBgCDXAVQWdfkQ8qj4I7vyeWa++COBBwiggQPoqFIgvLHydAIgghBM7mRsuuMPAcjL/8s/ye1UBAUAmDAC10zQ+kCDBtcBcdcBeNcB10z4AHCAEASqAhSxyMsFUAXPFlAD+gLLaSLQIc8xIddJoIQJuZgzcAHLAFjPFpcwcQHLABLM4skB+wAAPoIQFp4+EbqOEfgAApMg10qXeNcB1AL7AOjRkzLyPOI+zYS/"
                let data = try await client.boc.encode_boc(
                    TSDKParamsOfEncodeBoc(
                        builder: [
                            TSDKBuilderOp(
                                type: TSDKBuilderOpEnumTypes.Integer,
                                size: 256,
                                value: AnyValue.string("0x\(generatedKeyPair.public)")
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
                print(boc.state_init)
                let hash = try await client.boc.get_boc_hash(TSDKParamsOfGetBocHash(boc: boc.state_init))
                print("My venom wallet address -> 0:\(hash.hash)")
            }
        }
    }
}
