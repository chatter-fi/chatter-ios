// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : ShapeBackground.swift
// Description : Moving Background shape component

import SwiftUI

public struct CTShapeBackground: View {
    public init() {}

    public var body: some View {
        ZStack {
            ForEach(0 ..< 15) { _ in
                MovingRectangle()
            }
        }
    }
}
