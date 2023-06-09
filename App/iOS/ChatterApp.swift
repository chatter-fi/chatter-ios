//
//  ChatterApp.swift
//  Chatter
//
//  Created by 도라도라 on 2023/06/04.
//

import AppCore
import SwiftUI

@main
struct ChatterApp: App {
    @State private var routes: [CTNavigationScreenRoute] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routes) {
                ZStack {
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
                                GettingStartScreen()
                                    .navigationBarBackButtonHidden()
                            }
                        }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(minHeight: 0, maxHeight: .infinity)
            .onAppear {
                if UserDefaults.standard.value(forKey: "rocketdan.venom.Chatter.username") == nil {
                    routes = [.intro]
                } else {
                    routes = [.gettingStart]
                }
            }
        }
    }
}
