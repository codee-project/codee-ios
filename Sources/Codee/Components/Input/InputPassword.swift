//
//  InputPassword.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import SwiftUI
import Combine

public struct InputPassword: View {
    @Binding var text: String
    
    private var placeholder: String
    @State private var errorMessage: String? = nil
    
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        _text = text
    }
    
    public var body: some View {
        VStack {
            VStack(spacing: 6) {
                SecureField(text: $text) {
                    Text(placeholder).foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(
                    idealWidth: .infinity,
                    maxWidth: .infinity
                )
                .onReceive(Just(text)) { newValue in
                    errorMessage = Validator.isValid(for: .password, newValue)
                }
            }
            .frame(minHeight: 58)
            .background(Color.gray.opacity(0.15))
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
