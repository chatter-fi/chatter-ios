// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : CTBackdropBlurView.swift
// Description : UIVisualEffectView wrapper for SwiftUI

import SwiftUI

struct BackdropView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect(style: .extraLight)
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(true)
        animator.finishAnimation(at: .start)
        return view
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {}
}

public struct BackdropBlurView: View {
    public let radius: CGFloat

    public init(radius: CGFloat) {
        self.radius = radius
    }

    @ViewBuilder
    public var body: some View {
        BackdropView()
            .blur(radius: radius, opaque: true)
    }
}
