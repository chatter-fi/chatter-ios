// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : Message.swift
// Description : Message Model

import Foundation

public struct Message: Codable, Hashable, Equatable {
    public let role: String
    public let content: String

    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }

    enum CodingKeys: CodingKey {
        case role
        case content
    }
}
