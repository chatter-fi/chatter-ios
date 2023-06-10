// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : ReceiveTokenScreen.swift
// Description : Receive Token Screen

import AppResources
import DesignSystem
import Foundation
import SwiftUI

struct ReceiveTokenScreen: View {
    let onCreateWalletButtonClick: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                HStack {
                    Text("receive_token.title", bundle: .appResources)
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Spacer()
                }
                .padding(.horizontal, 20)
                HStack(spacing: 12) {
                    Image("LogoVENOM", bundle: .appResources)
                        .resizable()
                        .frame(width: 48, height: 48)
                    VStack(spacing: 4) {
                        HStack {
                            Text("50 VENOM")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color("ColorMono100", bundle: .appResources))
                            Spacer()
                        }
                        HStack {
                            Text("$ 11.65")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("ColorMono300", bundle: .appResources))
                            Spacer()
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color("ColorMono600", bundle: .appResources))
                )
                .padding(.top, 16)
                .padding(.horizontal, 20)

                HStack(spacing: 8) {
                    Text("from")
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Text("Chelsea")
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .foregroundColor(Color("ColorBrandCyan", bundle: .appResources))
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)

                HStack {
                    Text("receive_token.description", bundle: .appResources)
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .lineSpacing(5)
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)

                CTButton(
                    labelKey: "intro.generate_new_wallet",
                    onClick: {
                        UserDefaults.standard.set(true, forKey: "rocketdan.venom.Chatter.initialReceive")
                        onCreateWalletButtonClick()
                    }
                )

                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("LogoChatter", bundle: .appResources)
                        .padding(.bottom, 28)
                    Spacer()
                }
            }
        }
    }
}
