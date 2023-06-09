// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : CTButton.swift
// Description : App Button Component

import Foundation
import SwiftUI

public struct CTButton: View {
    let labelKey: String
    let onClick: () -> Void

    public init(
        labelKey: String,
        onClick: @escaping () -> Void
    ) {
        self.labelKey = labelKey
        self.onClick = onClick
    }

    @GestureState private var press: Bool = false
    @State private var isButtonPressed: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var buttonOpacity: CGFloat = 1.0

    public var body: some View {
        HStack {
            Spacer()
            Text(NSLocalizedString(labelKey, bundle: .appResources, comment: ""))
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
        .onChange(of: press) { press in
            withAnimation {
                isButtonPressed = press
            }

            if !press {
                onClick()
            }
        }
    }
}
