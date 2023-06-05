// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : MovingRectangle.swift
// Description : Moving Rectangle Component for ShapeBackground Component

import AppResources
import SwiftUI

struct MovingRectangle: View {
    let colorSet: [Color] = [
        Color("ColorBrandGreen", bundle: .appResources),
        Color("ColorBrandBlue", bundle: .appResources),
        Color("ColorBrandCyan", bundle: .appResources),
        Color("ColorBrandNeon", bundle: .appResources),
    ]
    @State var shapeColor = Color.white

    let randomWidth: CGFloat = .random(in: 2 ... 50)
    let randomHeight: CGFloat = .random(in: 50 ... 150)
    @State var randomX: CGFloat = .random(in: 0 ... UIScreen.main.bounds.width - 100)
    @State var randomY: CGFloat = .random(in: 0 ... UIScreen.main.bounds.height - 200)
    @State var randomRotate: CGFloat = .random(in: 0 ... 360)

    @State var isXReversed: Bool = false
    @State var isYReversed: Bool = false

    let randomXDelta: CGFloat = .random(in: 0.01 ... 0.15)
    let randomYDelta: CGFloat = .random(in: 0.01 ... 0.15)
    let randomRotateDelta: CGFloat = .random(in: 0.01 ... 0.08)
    let randomDeltaTimerInterval: CGFloat = .random(in: 0.01 ... 0.01)

    var body: some View {
        Rectangle()
            .fill(shapeColor)
            .frame(width: randomWidth, height: randomHeight)
            .position(x: randomX, y: randomY)
            .rotationEffect(.degrees(randomRotate))
            .onAppear {
                if shapeColor == .white {
                    shapeColor = colorSet.randomElement() ?? Color.white
                }

                Timer.scheduledTimer(withTimeInterval: randomDeltaTimerInterval, repeats: true) { _ in
                    if randomX > UIScreen.main.bounds.width {
                        isXReversed = true
                    }
                    if randomX < 0 {
                        isXReversed = false
                    }

                    if randomY > UIScreen.main.bounds.height {
                        isYReversed = true
                    }
                    if randomY < 0 {
                        isYReversed = false
                    }

                    withAnimation {
                        if isXReversed {
                            randomX -= randomXDelta
                        } else {
                            randomX += randomXDelta
                        }

                        if isYReversed {
                            randomY -= randomYDelta
                        } else {
                            randomY += randomYDelta
                        }

                        randomRotate += randomRotateDelta
                    }
                }
            }
    }
}
