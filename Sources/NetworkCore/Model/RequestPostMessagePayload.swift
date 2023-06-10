// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : RequestPostMessagePayload.swift
// Description : Payload of Request PostMessage API

import Foundation
import Model

struct RequestPostMessagePayload: Codable, Hashable, Equatable {
    let messages: [Message]

    enum CodingKeys: CodingKey {
        case messages
    }
}
