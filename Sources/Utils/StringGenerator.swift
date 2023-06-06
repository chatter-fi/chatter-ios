// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : StringGenerator.swift
// Description : Random String Generator

import Foundation

public func generateRandomPasswords(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    return String((0 ..< length).map { _ in letters.randomElement()! })
}
