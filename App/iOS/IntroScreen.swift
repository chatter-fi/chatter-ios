// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : IntroScreen.swift
// Description : Intro Screen

import AppResources
import DesignSystem
import SwiftUI

struct IntroScreen: View {
    @GestureState private var press: Bool = false
    @State private var isButtonPressed: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var buttonOpacity: CGFloat = 1.0

    @State private var backgroundViewScale: CGFloat = 1.0
    @State private var backgroundViewOpacity: CGFloat = 1.0

    @State private var mainContainerScale: CGFloat = 1.0
    @State private var mainContainerOpacity: CGFloat = 1.0

    @State private var progressBarOpacity: CGFloat = 0.0

    let onNewWalletButtonClick: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Text("intro.slogan", bundle: .appResources)
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .scaleEffect(mainContainerScale)
                .opacity(mainContainerOpacity)
                HStack {
                    Spacer()
                    Text("intro.generate_new_wallet", bundle: .appResources)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("ColorMono800", bundle: .appResources))
                        .padding(.vertical, 12)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                )
                .padding(.horizontal, 16)
                .padding(.top, 44)
                .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                .opacity(isButtonPressed ? 0.8 : 1.0)
                .gesture(
                    LongPressGesture(minimumDuration: 5, maximumDistance: 50)
                        .updating($press) { currentState, gestureState, _ in
                            gestureState = currentState
                        }
                )
                .scaleEffect(mainContainerScale)
                .opacity(mainContainerOpacity)
                Button(action: {}) {
                    HStack {
                        Spacer()
                        Text("intro.already_own", bundle: .appResources)
                            .underline()
                            .font(.system(size: 16))
                            .foregroundColor(Color("ColorMono100", bundle: .appResources))
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                .scaleEffect(mainContainerScale)
                .opacity(mainContainerOpacity)
                Spacer()
                HStack {
                    Spacer()
                    Image("LogoChatter", bundle: .appResources)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Spacer()
                }
                .opacity(mainContainerOpacity)
                .padding(.bottom, 50)
            }
            .background(
                ZStack {
                    CTShapeBackground()
                        .opacity(backgroundViewOpacity)
                        .scaleEffect(backgroundViewScale)
                    Color.black
                        .opacity(0.15)
                }
                .padding(.zero)
            )
            .edgesIgnoringSafeArea(.all)
            .onChange(of: press) { press in
                withAnimation {
                    isButtonPressed = press
                }

                if !press {
                    withAnimation(.easeInOut(duration: 2)) {
                        backgroundViewOpacity = 0.0
                        backgroundViewScale = 2.0

                        mainContainerScale = 0.8
                        mainContainerOpacity = 0

                        progressBarOpacity = 1.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        onNewWalletButtonClick()
                    }
                }
            }

            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.large)
                .opacity(progressBarOpacity)
        }
    }
}
