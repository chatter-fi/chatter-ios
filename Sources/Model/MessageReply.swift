// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : MessageReply.swift
// Description : Message Reply Model

import Foundation

public struct MessageReply: Codable, Hashable, Equatable {
    public let action: String
    public let text: String?
    public let recipient: String?
    public let amount: Int?
    public let token: String?

    public init(action: String, text: String?, recipient: String?, amount: Int?, token: String?) {
        self.action = action
        self.text = text
        self.recipient = recipient
        self.amount = amount
        self.token = token
    }

    enum CodingKeys: CodingKey {
        case action
        case text
        case recipient
        case amount
        case token
    }
}
