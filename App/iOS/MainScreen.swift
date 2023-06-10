// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : MainScreen.swift
// Description : Main Screen

import AppResources
import DesignSystem
import Foundation
import SpeechRecognitionCore
import SwiftUI
import Utils
import WalletCore

struct MainScreen: View {
    @ObservedObject private var viewModel: MainScreenViewModel = .init()

    @State private var currentVoiceRecognitionStatus: CTVoiceProcessingIndicator.CurrentType = .idle
    @State private var isWalletInfoCardMinimized: Bool = false

    @StateObject var speechRecognizer = SpeechRecognizer()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {}) {
                        Image("IconProfile", bundle: .appResources)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image("IconHistory", bundle: .appResources)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(BackdropBlurView(radius: 25))
                .padding(.horizontal, 20)
                GeometryReader { geometry in
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            Section {
                                if !isWalletInfoCardMinimized {
                                    HStack {
                                        Text("main.title", bundle: .appResources)
                                            .font(.system(size: 28, weight: .medium, design: .serif))
                                            .foregroundColor(Color("ColorMono100", bundle: .appResources))
                                        Spacer()
                                    }
                                    .padding(.top, 32)
                                    .padding(.bottom, 24)
                                    .padding(.horizontal, 20)

                                    ExampleItem(
                                        iconKey: "IconBuy",
                                        titleKey: "main.example.buy",
                                        descriptionKey: "main.example.buy_description"
                                    )
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 16)
                                    ExampleItem(
                                        iconKey: "IconSend",
                                        titleKey: "main.example.send",
                                        descriptionKey: "main.example.send_description"
                                    )
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 16)
                                    ExampleItem(
                                        iconKey: "IconSwap",
                                        titleKey: "main.example.swap",
                                        descriptionKey: "main.example.swap_description"
                                    )
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 16)

                                    ExampleItem(
                                        iconKey: "IconStake",
                                        titleKey: "main.example.stake",
                                        descriptionKey: "main.example.stake_description"
                                    )
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 16)
                                } else {
                                    ZStack {}
                                        .frame(minHeight: geometry.size.height - 200)
                                    Text(viewModel.currentTranscript)
                                }
                            } header: {
                                VStack(spacing: 0) {
                                    var formattedWalletTitle: String {
                                        let localizedString = NSLocalizedString("main.wallet_title", bundle: .appResources, comment: "Wallet title")
                                        return String(format: localizedString, UserDefaults.standard.string(forKey: "rocketdan.venom.Chatter.username") ?? "")
                                    }

                                    var simpleWalletAddress: String {
                                        let walletAddress = VenomWallet.shared.walletAddress

                                        return "(\(walletAddress.substring(with: 0 ..< 5))...\(walletAddress.substring(from: walletAddress.count - 5)))"
                                    }

                                    HStack(spacing: 4) {
                                        Text(formattedWalletTitle)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color("ColorMono100", bundle: .appResources))

                                        if !isWalletInfoCardMinimized {
                                            Text(simpleWalletAddress)
                                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                                .foregroundColor(Color("ColorMono400", bundle: .appResources))
                                        } else {
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Text(viewModel.formattedTotalBalance)
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(Color("ColorMono100", bundle: .appResources))
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 10, weight: .heavy))
                                                    .foregroundColor(Color("ColorMono100", bundle: .appResources))
                                            }
                                        }

                                        if !isWalletInfoCardMinimized {
                                            Spacer()
                                        }
                                    }

                                    if !isWalletInfoCardMinimized {
                                        HStack(spacing: 8) {
                                            Text(viewModel.formattedTotalBalance)
                                                .font(.system(size: 28, weight: .semibold))
                                                .foregroundColor(Color("ColorMono100", bundle: .appResources))

                                            Text(viewModel.formattedBalanceDifferencePercentage)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(Color("ColorGreenLight", bundle: .appResources))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .foregroundColor(Color("ColorGreenHeavy", bundle: .appResources))
                                                )
                                            Spacer()
                                        }
                                        .padding(.top, 12)

                                        TokenCard(
                                            tokenName: "VENOM",
                                            balance: 250,
                                            tokenValue: 0.23910,
                                            tokenDiffPercentage: 0.0
                                        )
                                        .padding(.top, 20)
                                        TokenCard(
                                            tokenName: "ETH",
                                            balance: 0,
                                            tokenValue: 1845.68000000,
                                            tokenDiffPercentage: 2.98
                                        )
                                        .padding(.top, 4)
                                        TokenCard(
                                            tokenName: "BTC",
                                            balance: 0,
                                            tokenValue: 26484.99000000,
                                            tokenDiffPercentage: 0.01
                                        )
                                        .padding(.top, 4)
                                        Button(action: {}) {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "chevron.down")
                                                    .font(.system(size: 14, weight: .heavy))
                                                    .foregroundColor(Color("ColorMono500", bundle: .appResources))
                                                Spacer()
                                            }
                                            .contentShape(Rectangle())
                                            .padding(.top, 14)
                                            .padding(.bottom, 2)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(Color("ColorMono700", bundle: .appResources))
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            VStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        isWalletInfoCardMinimized = true
                    }

                    if viewModel.voiceRecognitionStatus == .idle {
                        viewModel.voiceRecognitionStatus = .voiceRecognizing
                        speechRecognizer.resetTranscript()
                        speechRecognizer.startTranscribing()
                        return
                    }

                    if viewModel.voiceRecognitionStatus == .voiceRecognizing {
                        viewModel.voiceRecognitionStatus = .processing
                    }
                }) {
                    CTVoiceProcessingIndicator(
                        currentState: $currentVoiceRecognitionStatus
                    )
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.bottom, 12)
                    .contentShape(Rectangle())
                    .onChange(of: viewModel.voiceRecognitionStatus) { status in
                        self.currentVoiceRecognitionStatus = status

                        if status == .voiceRecognizing {
                            var sameCount = 0
                            var oldTranscript = ""

                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                viewModel.updateCurrentTranscript(speechRecognizer.transcript)

                                if viewModel.voiceRecognitionStatus != .voiceRecognizing {
                                    timer.invalidate()
                                }

                                if oldTranscript == speechRecognizer.transcript {
                                    sameCount += 1
                                } else {
                                    sameCount = 0
                                }

                                if sameCount > 40 {
                                    viewModel.voiceRecognitionStatus = .processing
                                    return
                                }

                                oldTranscript = speechRecognizer.transcript
                                sameCount += 1
                            }
                        }

                        if status == .processing {
                            // TODO: Request to Server
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                viewModel.voiceRecognitionStatus = .idle
                                speechRecognizer.stopTranscribing()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TokenCard: View {
    let tokenName: String
    let balance: Float
    let tokenValue: Float
    let tokenDiffPercentage: Float

    var body: some View {
        HStack(spacing: 0) {
            Image("Logo\(tokenName)", bundle: .appResources)
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.trailing, 12)
            VStack(spacing: 4) {
                HStack {
                    Text(tokenName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Spacer()
                }
                HStack {
                    Text(String(format: "%.7f", balance))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("ColorMono400", bundle: .appResources))
                    Spacer()
                }
            }
            Spacer()
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    Text("$\(String(format: "%.5f", tokenValue))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                }
                HStack {
                    Spacer()
                    var formattedBalanceDifferencePercentage: String {
                        let differencePercentage = tokenDiffPercentage

                        var sign = "+"

                        if differencePercentage < 0 {
                            sign = "-"
                        }

                        let percentage = String(format: "%.2f", tokenDiffPercentage)
                        return "\(sign) \(percentage)"
                    }
                    Text(formattedBalanceDifferencePercentage)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(
                            tokenDiffPercentage < 0 ? Color("ColorGreenRed", bundle: .appResources) : Color("ColorGreenLight", bundle: .appResources)
                        )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("ColorMono600", bundle: .appResources))
        )
    }
}

struct ExampleItem: View {
    let iconKey: String
    let titleKey: String
    let descriptionKey: String

    var body: some View {
        HStack(spacing: 16) {
            Image(iconKey, bundle: .appResources)
                .resizable()
                .frame(width: 48, height: 48)
            VStack(spacing: 8) {
                HStack {
                    Text(NSLocalizedString(titleKey, bundle: .appResources, comment: ""))
                        .font(.system(size: 20, weight: .semibold, design: .serif))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Spacer()
                }
                HStack {
                    Text(NSLocalizedString(descriptionKey, bundle: .appResources, comment: ""))
                        .font(.system(size: 12))
                        .lineSpacing(1.5)
                        .foregroundColor(Color("ColorMono400", bundle: .appResources))
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
