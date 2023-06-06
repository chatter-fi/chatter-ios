// Copyright (c) 2023 Rocketdan
//
// Chatter Venom iOS Project
// File Name : NameInputScreen.swift
// Description : Name Input Screen

import AppResources
import SwiftUI

struct NameInputScreen: View {
    @State private var nameFieldValue: String = ""

    @State private var nameFieldBorderColor: Color = .init("ColorMono500", bundle: .appResources)
    @State private var formErrorType: FormErrorType? = nil

    @FocusState private var focusedField: FormField?

    @GestureState private var press: Bool = false
    @State private var isButtonPressed: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var buttonOpacity: CGFloat = 1.0

    let onNextButtonClick: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Text("name_input.title", bundle: .appResources)
                        .font(.system(size: 28, design: .serif))
                        .foregroundColor(Color("ColorMono100", bundle: .appResources))
                    Spacer()
                }
                .padding(.horizontal, 40)

                VStack {
                    TextField(
                        NSLocalizedString("name_input.placeholder", bundle: .appResources, comment: "Placeholder"),
                        text: $nameFieldValue
                    )
                    .focused($focusedField, equals: .nameField)
                    .submitLabel(.done)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    Rectangle()
                        .foregroundColor(nameFieldBorderColor)
                        .frame(height: 1)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .padding(.top, 44)
                .padding(.horizontal, 40)

                ZStack {
                    HStack {
                        var errorMessage: String {
                            var message = ""

                            switch formErrorType {
                            case .maxLength:
                                message = NSLocalizedString("name_input.error_max_length", bundle: .appResources, comment: "Min Length")
                            case .minLength:
                                message = NSLocalizedString("name_input.error_min_length", bundle: .appResources, comment: "Max Length")
                            default:
                                message = ""
                            }

                            return message
                        }

                        Text(errorMessage)
                            .font(.system(size: 12, weight: .medium))
                            .padding(.top, 8)
                            .foregroundColor(nameFieldBorderColor)
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 100)

                Spacer()
            }
            .onChange(of: focusedField) { value in
                if value == .nameField {
                    withAnimation {
                        nameFieldBorderColor = .white

                        if nameFieldValue.count > 1, nameFieldValue.count < 4 {
                            nameFieldBorderColor = .init("ColorRedLight", bundle: .appResources)
                        } else if nameFieldValue.count > 10 {
                            nameFieldBorderColor = .init("ColorRedLight", bundle: .appResources)
                        } else if nameFieldValue.count > 3, nameFieldValue.count < 11 {
                            nameFieldBorderColor = .init("ColorGreenLight", bundle: .appResources)
                        } else {
                            nameFieldBorderColor = .init("ColorMono500", bundle: .appResources)
                        }
                    }
                } else {
                    withAnimation {
                        nameFieldBorderColor = .init("ColorMono500", bundle: .appResources)
                    }
                }
            }
            .onChange(of: nameFieldValue) { value in
                withAnimation {
                    if value.count < 4 {
                        formErrorType = .minLength
                        nameFieldBorderColor = .init("ColorRedLight", bundle: .appResources)
                    } else if value.count > 10 {
                        formErrorType = .maxLength
                        nameFieldBorderColor = .init("ColorRedLight", bundle: .appResources)
                    } else if nameFieldValue.count > 3, nameFieldValue.count < 11 {
                        formErrorType = .noError
                        nameFieldBorderColor = .init("ColorGreenLight", bundle: .appResources)
                    } else {
                        formErrorType = nil
                        nameFieldBorderColor = .init("ColorMono500", bundle: .appResources)
                    }
                }
            }
            .onChange(of: press) { press in
                withAnimation {
                    isButtonPressed = press
                }

                if !press {
                    onNextButtonClick()
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("next", bundle: .appResources)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(formErrorType == .noError ? Color("ColorMono800", bundle: .appResources) : Color("ColorMono600", bundle: .appResources))
                        .padding(.vertical, 12)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(formErrorType == .noError ? Color("ColorMono100", bundle: .appResources) : Color("ColorMono500", bundle: .appResources))
                )
                .disabled(formErrorType == nil)
                .padding(.top, 44)
                .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                .opacity(isButtonPressed ? 0.8 : 1.0)
                .gesture(
                    LongPressGesture(minimumDuration: 5, maximumDistance: 50)
                        .updating($press) { currentState, gestureState, _ in
                            gestureState = currentState
                        }
                )
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 40)
        }
    }
}

private enum FormField {
    case nameField
}

private enum FormErrorType {
    case noError
    case maxLength
    case minLength
}