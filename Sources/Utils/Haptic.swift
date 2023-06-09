//
//  File.swift
//
//
//  Created by 도라도라 on 2023/06/09.
//

import Foundation
import UIKit

public class HapticManager {
    public static let shared = HapticManager()

    // warning, error, success
    public func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    // heavy, light, meduium, rigid, soft
    public func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
