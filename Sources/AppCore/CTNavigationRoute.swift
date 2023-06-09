// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : CTNavigationRoute.swift
// Description : App Navigation Route

import Foundation

public protocol CTNavigationRoute: Equatable, Codable, Sendable, Hashable {}

public enum CTNavigationScreenRoute: String, CTNavigationRoute, Identifiable {
    case intro
    case nameInputScreen
    case walletCreateLoadingScreen
    case gettingStart

    public var id: String {
        return rawValue
    }
}
