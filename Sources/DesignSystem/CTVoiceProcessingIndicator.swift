// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : CTVoiceProcessingIndicator.swift
// Description : Voice Processing Indicator

import AppResources
import Foundation
import SwiftUI

public struct CTVoiceProcessingIndicator: View {
    private var currentState: Binding<CurrentType>

    public init(
        currentState: Binding<CurrentType>
    ) {
        self.currentState = currentState
    }

    @State private var firstRectangleXOffset: CGFloat = .zero
    @State private var firstShapeAngle: Angle = .degrees(0)

    @State private var secondRectangleXOffset: CGFloat = .zero
    @State private var secondShapeAngle: Angle = .degrees(90)

    @State private var thirdRectangleXOffset: CGFloat = .zero
    @State private var thirdShapeAngle: Angle = .degrees(45)

    @State private var fourthRectangleXOffset: CGFloat = .zero
    @State private var fourthShapeAngle: Angle = .degrees(-45)

    @State private var allAngle: Angle = .degrees(0)

    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 6, height: 54)
                .foregroundColor(Color("ColorBrandGreen", bundle: .appResources))
                .rotationEffect(firstShapeAngle)
                .offset(x: firstRectangleXOffset)
            Rectangle()
                .frame(width: 6, height: 54)
                .foregroundColor(Color("ColorBrandBlue", bundle: .appResources))
                .rotationEffect(secondShapeAngle)
                .offset(x: secondRectangleXOffset)
            Rectangle()
                .frame(width: 6, height: 54)
                .foregroundColor(Color("ColorBrandNeon", bundle: .appResources))
                .rotationEffect(thirdShapeAngle)
                .offset(x: thirdRectangleXOffset)
            Rectangle()
                .frame(width: 6, height: 54)
                .foregroundColor(Color("ColorBrandCyan", bundle: .appResources))
                .rotationEffect(fourthShapeAngle)
                .offset(x: fourthRectangleXOffset)
        }
        .rotationEffect(allAngle)
        .onChange(of: currentState.wrappedValue) { state in
            switch state {
            case .idle:
                withAnimation {
                    allAngle = .zero
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        allAngle = .zero
                    }
                }
            case .voiceRecognizing:
                withAnimation(.easeInOut(duration: 0.6)) {
                    firstRectangleXOffset = 128
                    secondRectangleXOffset -= 48
                    thirdRectangleXOffset = 48
                    fourthRectangleXOffset = -128

                    allAngle = .zero
                }

                Timer.scheduledTimer(withTimeInterval: 0.0025, repeats: true) { timer in
                    withAnimation(.easeOut) {
                        firstShapeAngle = firstShapeAngle + .degrees(0.5)
                    }

                    if currentState.wrappedValue != .voiceRecognizing {
                        timer.invalidate()
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
                    withAnimation(.easeOut) {
                        secondShapeAngle = secondShapeAngle - .degrees(1)
                    }

                    if currentState.wrappedValue != .voiceRecognizing {
                        timer.invalidate()
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
                    withAnimation(.easeInOut) {
                        thirdShapeAngle = thirdShapeAngle + .degrees(2)
                    }

                    if currentState.wrappedValue != .voiceRecognizing {
                        timer.invalidate()
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
                    withAnimation(.easeInOut) {
                        fourthShapeAngle = fourthShapeAngle - .degrees(3)
                    }

                    if currentState.wrappedValue != .voiceRecognizing {
                        timer.invalidate()
                    }
                }
            case .processing:
                withAnimation(.easeInOut(duration: 0.6)) {
                    firstRectangleXOffset = 0
                    secondRectangleXOffset = 0
                    thirdRectangleXOffset = 0
                    fourthRectangleXOffset = 0

                    firstShapeAngle = .degrees(0)
                    secondShapeAngle = .degrees(90)
                    thirdShapeAngle = .degrees(45)
                    fourthShapeAngle = .degrees(-45)
                }

                Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { timer in
                    withAnimation {
                        if allAngle.degrees == 360 {
                            allAngle = .zero
                        } else {
                            allAngle = allAngle + .degrees(0.5)
                        }
                    }

                    if currentState.wrappedValue != .processing {
                        timer.invalidate()
                    }
                }
            }
        }
    }

    public enum CurrentType {
        case idle
        case voiceRecognizing
        case processing
    }
}
