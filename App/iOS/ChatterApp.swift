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
    @State private var routes: [CTNavigationScreenRoute] = [.intro]

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
                                WalletCreateLoadingScreen()
                                    .navigationBarBackButtonHidden()
                            }
                        }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(minHeight: 0, maxHeight: .infinity)
        }
    }
}
