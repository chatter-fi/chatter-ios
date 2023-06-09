// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : GettingStartScreen.swift
// Description : Getting Start Screen

import AppResources
import DesignSystem
import Foundation
import SwiftUI
import UIKit
import Utils

struct GettingStartScreen: View {
    @State private var address: String = ""
    @State private var addressDisplayable: String = ""

    @State private var viewOpacity: CGFloat = 1.0

    let onGettingStartedClick: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Text("getting_start.welcome", bundle: .appResources)
                    .font(.system(size: 28, weight: .medium, design: .serif))
                    .foregroundColor(Color("ColorMono400", bundle: .appResources))
                Spacer()
            }
            .padding(.horizontal, 24)
            HStack {
                Text(UserDefaults.standard.value(forKey: "rocketdan.venom.Chatter.username") as? String ?? "")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundColor(Color("ColorMono100", bundle: .appResources))
                Spacer()
            }
            .padding(.top, 4)
            .padding(.horizontal, 24)
            HStack {
                Text("getting_start.your_wallet_addr", bundle: .appResources)
                    .font(.system(size: 28, weight: .medium, design: .serif))
                    .foregroundColor(Color("ColorMono400", bundle: .appResources))
                Spacer()
            }
            .padding(.top, 36)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            Text(addressDisplayable)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .lineSpacing(1.5)
                .foregroundColor(Color("ColorMono200", bundle: .appResources))
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(minHeight: 50)
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color("ColorMono700", bundle: .appResources))
                        .overlay {
                            if addressDisplayable == "" {
                                ProgressView()
                            }
                        }
                }
                .padding(.horizontal, 16)
            Spacer()
            CTButton(
                labelKey: "getting_start.start",
                onClick: {
                    HapticManager.shared.hapticNotification(type: .success)

                    withAnimation(.easeOut(duration: 0.5)) {
                        viewOpacity = 0.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onGettingStartedClick()
                    }
                }
            )
            .disabled(addressDisplayable.isEmpty)
            .opacity(addressDisplayable.isEmpty ? 0.5 : 1.0)
            .padding(.bottom, 24)
        }
        .opacity(viewOpacity)
        .onAppear {
            DispatchQueue.main.async {
                address = VenomWallet.shared.unlockKeyChainAndGetWalletAddress()
            }
        }
        .onChange(of: address) { addr in
            if addr.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        addressDisplayable = addr
                    }
                    HapticManager.shared.hapticNotification(type: .success)
                }
            }
        }
    }
}
