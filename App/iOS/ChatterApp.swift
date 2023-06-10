// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : ChatterApp.swift
// Description : App Entrypoint

import AppCore
import SwiftUI
import WalletCore

@main
struct ChatterApp: App {
    @State private var routes: [CTNavigationScreenRoute] = []
    @State private var fromDeeplink: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routes) {
                ZStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.large)

                    Color.clear
                        .navigationDestination(for: CTNavigationScreenRoute.self) { screenRoute in
                            switch screenRoute {
                            case .intro:
                                IntroScreen(
                                    onNewWalletButtonClick: {
                                        routes.append(.nameInputScreen)
                                    }
                                )
                                .navigationBarBackButtonHidden()
                            case .nameInputScreen:
                                NameInputScreen(
                                    onNextButtonClick: {
                                        routes.append(.walletCreateLoadingScreen)
                                    }
                                )
                                .navigationBarBackButtonHidden()
                            case .walletCreateLoadingScreen:
                                WalletCreateLoadingScreen(
                                    onNextStep: {
                                        routes = [.gettingStart]
                                    }
                                )
                                .navigationBarBackButtonHidden()
                            case .gettingStart:
                                GettingStartScreen(
                                    onGettingStartedClick: {
                                        UIView.setAnimationsEnabled(false)
                                        routes = []

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            UIView.setAnimationsEnabled(true)
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            routes.append(.main)
                                            routes.append(.onboarding)
                                        }
                                    }
                                )
                                .navigationBarBackButtonHidden()
                            case .main:
                                MainScreen()
                                    .navigationBarBackButtonHidden()
                            case .receiveToken:
                                ReceiveTokenScreen(
                                    onCreateWalletButtonClick: {
                                        _ = routes.popLast()

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            routes.append(.nameInputScreen)
                                        }
                                    }
                                )
                                .navigationBarBackButtonHidden()
                            case .onboarding:
                                OnboardingScreen()
                                    .navigationBarBackButtonHidden()
                            }
                        }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(minHeight: 0, maxHeight: .infinity)
            .background(Color("ColorMono800", bundle: .appResources))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if !fromDeeplink {
                        if UserDefaults.standard.value(forKey: "rocketdan.venom.Chatter.username") == nil {
                            routes = [.intro]
                        } else {
                            _ = VenomWallet.shared.unlockKeyChainAndGetWalletAddress()
                            routes = [.main, .onboarding]
                        }
                    }
                }
            }
            .onOpenURL { url in
                fromDeeplink = true
                print(url)

                routes = [.receiveToken]
            }
        }
    }
}
