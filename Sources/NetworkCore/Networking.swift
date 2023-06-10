// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : Networking.swift
// Description : Network Manager

import Foundation

public class Networking {
    public static let shared = Networking()

    public static let baseApiUrl = ProcessInfo.processInfo.environment["API_URL"]!

    private init() {}
}
