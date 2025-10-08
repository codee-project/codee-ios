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

public struct Input: View {
    @Binding var text: String
    
    private var placeholder: String
    private var style: InputStyle = .black
    private var validatorType: ValidatorType? = .name
    @State private var errorMessage: String? = nil
    private var keyboardType: UIKeyboardType
    
    private var leadingPadding: CGFloat
    private var trailingPadding: CGFloat
    private var verticalPadding: CGFloat
    private var lineLimit: Int
    private var isBlocked: Bool
    
    public init(
        placeholder: String,
        style: InputStyle = .black,
        validatorType: ValidatorType? = .name,
        keyboardType: UIKeyboardType = .default,
        alignment: TextAlignment = .leading,
        leadingPadding: CGFloat = 16,
        trailingPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        lineLimit: Int = 1,
        isBlocked: Bool = false,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self.style = style
        self.validatorType = validatorType
        self.keyboardType = keyboardType
        
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        self.verticalPadding = verticalPadding
        self.lineLimit = lineLimit
        self.isBlocked = isBlocked
        
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
                    .padding(.vertical, verticalPadding)
                }
                .keyboardType(keyboardType)
                .foregroundColor(
                    style == .black ?
                        .white :
                        .blackDefault
                )
                .frame(minHeight: 58)
                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
                .multilineTextAlignment(alignment)
                .lineLimit(lineLimit)
                .frame(idealWidth: .infinity, maxWidth: .infinity)
                .disabled(isBlocked)
                .onReceive(Just(text)) { newValue in
                    if let validatorType {
                        errorMessage = Validator.isValid(for: validatorType, newValue)
                    }
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
}
