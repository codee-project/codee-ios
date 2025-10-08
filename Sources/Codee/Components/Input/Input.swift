//
//  InputPassword.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import SwiftUI
import Combine

public struct InputModel {
    var placeholder: String
    var validatorType: ValidatorType? = .name
    var keyboardType: UIKeyboardType
    
    var leadingPadding: CGFloat
    var trailingPadding: CGFloat
    var verticalPadding: CGFloat
    var lineLimit: Int
    var isBlocked: Bool
    var alignment: TextAlignment
    var backgroundColor: Color
    var textColor: Color
    var cornerRadius: CGFloat
    
    public init(
        placeholder: String,
        validatorType: ValidatorType? = .name,
        keyboardType: UIKeyboardType = .default,
        alignment: TextAlignment = .leading,
        leadingPadding: CGFloat = 16,
        trailingPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        lineLimit: Int = 1,
        isBlocked: Bool = false,
        backgroundColor: Color = Color.gray.opacity(0.15),
        textColor: Color = .white,
        cornerRadius: CGFloat = 30
    ) {
        self.placeholder = placeholder
        self.validatorType = validatorType
        self.keyboardType = keyboardType
        
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        self.verticalPadding = verticalPadding
        self.lineLimit = lineLimit
        self.isBlocked = isBlocked
        self.alignment = alignment
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }
}

public struct Input: View {
    @Binding private var text: String
    @State private var errorMessage: String? = nil
    
    private var model: InputModel
    
    public init(
        model: InputModel,
        text: Binding<String>
    ) {
        self.model = model
        _text = text
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                TextField(text: $text) {
                    Text(model.placeholder)
                        .foregroundColor(model.textColor.opacity(0.4))
                        .padding(.vertical, model.verticalPadding)
                }
                .keyboardType(model.keyboardType)
                .foregroundColor(model.textColor)
                .frame(minHeight: 58)
                .padding(.leading, model.leadingPadding)
                .padding(.trailing, model.trailingPadding)
                .multilineTextAlignment(model.alignment)
                .lineLimit(model.lineLimit)
                .frame(idealWidth: .infinity, maxWidth: .infinity)
                .disabled(model.isBlocked)
                .onReceive(Just(text)) { newValue in
                    if let validatorType = model.validatorType {
                        errorMessage = Validator.isValid(for: validatorType, newValue)
                    }
                }
            }
            .background(model.backgroundColor)
            .cornerRadius(model.cornerRadius)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
