// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : MainScreenViewModel.swift
// Description : ViewModel for Main Screen

import DesignSystem
import Foundation
import SwiftUI

@MainActor
class MainScreenViewModel: ObservableObject {
    @Published private var totalBalance: Float = 0.0
    var formattedTotalBalance: String {
        "$\(String(format: "%.2f", totalBalance))"
    }

    @Published private var balanceDifferencePercentage: Float = 0.0
    var formattedBalanceDifferencePercentage: String {
        let differencePercentage = balanceDifferencePercentage

        var sign = "+"

        if differencePercentage < 0 {
            sign = "-"
        }

        let percentage = String(format: "%.2f", balanceDifferencePercentage)
        return "\(sign) \(percentage)"
    }

    @Published var voiceRecognitionStatus: CTVoiceProcessingIndicator.CurrentType = .idle

    @Published var currentTranscript: String = ""

    init() {}

    func updateCurrentTranscript(_ transcript: String) {
        currentTranscript = transcript
    }
}
