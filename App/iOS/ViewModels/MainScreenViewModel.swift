// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : MainScreenViewModel.swift
// Description : ViewModel for Main Screen

import AVFoundation
import Contacts
import DesignSystem
import Foundation
import MessageUI
import Model
import NetworkCore
import SwiftTTS
import SwiftUI
import UIKit
import WalletCore

class MainScreenViewModel: NSObject, ObservableObject, MFMessageComposeViewControllerDelegate {
    @Published private var totalBalance: Float = 250.0
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

    @Published var messages: [Message] = []
    private var previousReply: MessageReply? = nil

    private var toName: String = ""
    private var amount: Float = 0.0

    private var needReset = false

    override init() {}

    func insertPreviousMessage() {
        if needReset {
            needReset = false
            previousReply = nil
            messages = []
        }

        if let reply = previousReply {
            messages.append(
                Message(role: "assistant", content: String(data: try! JSONEncoder().encode(reply), encoding: .utf8)!)
            )
        }
    }

    func updateCurrentTranscript(_ transcript: String) {
        currentTranscript = transcript
    }

    func processMessage() {
        let message = Message(role: "user", content: currentTranscript)
        updateCurrentTranscript("")

        messages.append(message)

        Task {
            let messageReply = try await Networking.shared.postMessage(messages: messages)

            let tts = SwiftTTS.live

            AVSpeechSynthesisVoice.speechVoices().forEach {
                if $0.identifier.lowercased().contains("samantha") {
                    tts.setVoice($0)
                }
            }

            DispatchQueue.main.async {
                if let text = messageReply.text {
                    self.currentTranscript = text
                    self.voiceRecognitionStatus = .idle
                    self.previousReply = messageReply
                    tts.speak(text)
                }

                if messageReply.action == "send" {
                    self.toName = messageReply.recipient!
                    self.amount = Float(messageReply.amount!)

                    let generatedMessage = "I got it. I sent a message to \(messageReply.recipient!). When \(messageReply.recipient!) claim the token \(messageReply.amount!) \(messageReply.token!), I will let you know. Is it Okay?"

                    self.currentTranscript = generatedMessage
                    self.voiceRecognitionStatus = .idle
                    self.previousReply = MessageReply(
                        action: "send",
                        text: generatedMessage,
                        recipient: messageReply.recipient,
                        amount: messageReply.amount,
                        token: messageReply.token
                    )

                    tts.speak(generatedMessage)
                }
            }
        }
    }

    func cancel() {
        currentTranscript = "Cancel"

        insertPreviousMessage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.voiceRecognitionStatus = .processing

            self.messages.append(Message(role: "user", content: "Cancel"))
            self.currentTranscript = "Transaction canceled."

            let tts = SwiftTTS.live

            AVSpeechSynthesisVoice.speechVoices().forEach {
                if $0.identifier.lowercased().contains("samantha") {
                    tts.setVoice($0)
                }
            }
            tts.speak(self.currentTranscript)

            self.needReset = true
            self.toName = ""
        }
    }

    func confirm() {
        let tts = SwiftTTS.live
        AVSpeechSynthesisVoice.speechVoices().forEach {
            if $0.identifier.lowercased().contains("samantha") {
                tts.setVoice($0)
            }
        }

        currentTranscript = "Approve"
        insertPreviousMessage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.voiceRecognitionStatus = .processing
            self.messages.append(Message(role: "user", content: "Approve"))

            let generatedMessage = "Asks for contact permission to find \(self.toName) in Contacts. If you allow, we can send \(self.toName) a text message with instructions on how to claim your tokens."
            self.voiceRecognitionStatus = .idle
            self.currentTranscript = generatedMessage
            self.previousReply = MessageReply(
                action: "reply",
                text: generatedMessage,
                recipient: self.toName,
                amount: 0,
                token: ""
            )

            tts.speak(generatedMessage)

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                CNContactStore().requestAccess(for: .contacts) { _, _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.insertPreviousMessage()

                        let generatedMessage2 = "Now proceed with biometric authentication to send a transaction that sends the actual token."
                        self.currentTranscript = generatedMessage2
                        self.previousReply = MessageReply(
                            action: "reply",
                            text: generatedMessage2,
                            recipient: self.toName,
                            amount: 0,
                            token: ""
                        )

                        tts.speak(generatedMessage2)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                            self.insertPreviousMessage()

                            VenomWallet.shared.requestDeviceBiometricPermission()

                            let generatedMessage3 = "Processing transaction..."
                            self.currentTranscript = generatedMessage3
                            self.previousReply = MessageReply(
                                action: "reply",
                                text: generatedMessage3,
                                recipient: self.toName,
                                amount: 0,
                                token: ""
                            )

                            tts.speak(generatedMessage3)

                            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                let composeViewController = MFMessageComposeViewController()
                                composeViewController.messageComposeDelegate = self
                                composeViewController.recipients = ["010-2123-0690"]
                                composeViewController.body = """
                                \(UserDefaults.standard.value(forKey: "rocketdan.venom.Chatter.username") ?? "") sent \(self.amount) VENOM Token.
                                To claim these tokens, install the Chatter app via the link below.

                                Receive: https://chatter.deno.dev/o/XyGFjP5zYxE=
                                """

                                UIApplication.topViewController()?.present(composeViewController, animated: true, completion: nil)

                                self.insertPreviousMessage()

                                let generatedMessage4 = "Complete!"
                                self.currentTranscript = generatedMessage4
                                self.previousReply = MessageReply(
                                    action: "reply",
                                    text: generatedMessage4,
                                    recipient: self.toName,
                                    amount: 0,
                                    token: ""
                                )

                                tts.speak(generatedMessage4)
                                self.totalBalance -= self.amount

                                self.needReset = true
                            }
                        }
                    }
                }
            }
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("cancelled")
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        case .sent:
            print("sent message:", controller.body ?? "")
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        case .failed:
            print("failed")
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        @unknown default:
            print("unkown Error")
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController
            { return topViewController(base: selected) }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// i want to send my venom to my friend.
// my friend name is mean, and i will send 10 venom to him.
