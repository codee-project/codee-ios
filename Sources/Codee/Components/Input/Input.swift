//
//  InputPassword.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import SwiftUI
import Combine

public enum InputStyle {
    case black
    case gray
}

public enum InputType {
    case normalLeft
    case bigCenter
}

public struct Input: View {
    @Binding var text: String
    
    private var placeholder: String
    private var style: InputStyle = .black
    private var type: InputType = .normalLeft
    private var validatorType: ValidatorType = .name
    @State private var errorMessage: String? = nil
    private var keyboardType: UIKeyboardType
    
    public init(
        placeholder: String,
        style: InputStyle = .black,
        type: InputType = .normalLeft,
        validatorType: ValidatorType = .name,
        keyboardType: UIKeyboardType = .default,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self.style = style
        self.type = type
        self.validatorType = validatorType
        self.keyboardType = keyboardType
        _text = text
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                TextField(text: $text) {
                    Text(placeholder).foregroundColor(
                        style == .black ?
                            .white.opacity(0.4) :
                            .blackDefault.opacity(0.4)
                    )
                    .padding(.vertical, padding)
                }
                .keyboardType(keyboardType)
                .foregroundColor(
                    style == .black ?
                        .white :
                        .blackDefault
                )
                .frame(minHeight: 58)
                .padding(.horizontal, 16)
                .multilineTextAlignment(.center)
                .frame(idealWidth: .infinity, maxWidth: .infinity)
                .onReceive(Just(text)) { newValue in
                    errorMessage = Validator.isValid(for: validatorType, newValue)
                }
            }
            .background(
                style == .black ?
                Color.gray.opacity(0.15) :
                    Color.gray.opacity(0.15)
                
            )
            .cornerRadius(30)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var padding: CGFloat {
        switch type {
        case .normalLeft:
            return 12
        case .bigCenter:
            return 16
        }
    }
    
    var alignment: TextAlignment {
        switch type {
        case .normalLeft:
            return .leading
        case .bigCenter:
            return .center
        }
    }
}
