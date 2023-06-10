// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : OnboardingScreen.swift
// Description : Onboarding Screen

import AVKit
import Foundation
import SwiftUI

struct OnboardingScreen: View {
    let videoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "chatter_onboarding", ofType: "mp4")!)
    @State private var player: AVPlayer? = nil

    @State private var step: Int = 1
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("ColorOnboardingBackground", bundle: .appResources)
                .edgesIgnoringSafeArea(.all)
            VideoPlayer(player: player)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player = AVPlayer(url: videoUrl)

                    player?.play()

                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if (player?.currentItem?.currentTime().seconds ?? 0.0) > 3.4 {
                            player?.pause()

                            step = 2
                            timer.invalidate()
                        }
                    }
                }
                .disabled(true)

            Color.black.opacity(0.01)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .allowsHitTesting(true)
                .onTapGesture {
                    print("OKOKS")
                    if player?.rate != 0 {
                        return
                    }

                    if step == 2 {
                        player?.play()

                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if (player?.currentItem?.currentTime().seconds ?? 0.0) > 5 {
                                player?.pause()

                                step = 3
                                timer.invalidate()
                            }
                        }
                    }

                    if step == 3 {
                        player?.play()

                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if player?.rate == 0.0 {
                                step = 4
                                timer.invalidate()
                            }
                        }
                    }

                    if step == 4 {
                        dismiss()
                    }
                }
        }
    }
}
