// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : Networking+PostMessage.swift
// Description : Post Message API

import Foundation
import Model

// MARK: - POST /api/chat

public extension Networking {
    func postMessage(messages: [Message]) async throws -> MessageReply {
        let payload = try JSONEncoder().encode(RequestPostMessagePayload(messages: messages))

        guard let url = URL(string: "\(Networking.baseApiUrl)/api/chat") else { fatalError("Missing URL") }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"

        let requestTask = Task { [urlRequest = urlRequest] in
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

            let reply = try JSONDecoder().decode(MessageReply.self, from: data)

            print("============== [/api/chat] Result ========================================")
            print(String(data: data, encoding: .utf8) ?? "")
            print("==========================================================================\n")

            return reply
        }

        return try await requestTask.result.get()
    }
}
