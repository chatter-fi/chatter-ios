// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : WalletCreateLoadingScreen.swift
// Description : Name Input Screen

import AppResources
import EverscaleClientSwift
import Foundation
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
                config.network = TSDKNetworkConfig(endpoints: ["https://gql-devnet.venom.network/graphql"])

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
                
                // 0:dd307cf4d78cdb388c20f2cbd94b9dc65554f1970084427aabab2fe2fa2cfa31
                // P:0dad3060919bc6e53e348aae5d77b364cdcb09086d2d40ae408616e5685a2e63
                
                try client.abi.
            
                print("========== [DisplayableAddress] =================================================")
                print("Wallet Address Name : \(displayableAddress.address)")
                print("=================================================================================\n")

                // let randomPasswords = generateRandomPasswords(length: 20)
                // print("=============== [RANDOM PASSWORDS] \(randomPasswords)")
            }
        }
    }
}
