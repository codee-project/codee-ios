//
//  CheckBoxView.swift
//  Codee
//
//  Created by Eryk Chrustek on 03/10/2025.
//

import SwiftUI

struct CheckBox<Content: View>: View {
    let action: () -> Void
    let content: Content
    let spacing: CGFloat
    
    let selectedIconColor: Color
    let selectedBackgroundColor: Color
    
    @Binding var isOn: Bool
    @Binding var errorMessage: String?

    init(
        isOn: Binding<Bool>,
        errorMessage: Binding<String?> = .constant(nil),
        spacing: CGFloat = 16,
        action: @escaping () -> Void,
        selectedIconColor: Color = .whiteDefault,
        selectedBackgroundColor: Color = .blackDefault,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.action = action
        self.content = content()
        
        self.selectedIconColor = selectedIconColor
        self.selectedBackgroundColor = selectedBackgroundColor
        
        _isOn = isOn
        _errorMessage = errorMessage
    }
    
    var body: some View {
        SwiftUI.Button {
            isOn.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                action()
            }
        } label: {
            HStack(alignment: .center, spacing: spacing) {
                Image(.check)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(isOn ? selectedIconColor : .gray.opacity(0.6))
                    .frame(width: 12, height: 12)
                    .padding(8)
                    .background(isOn ? selectedBackgroundColor : .gray.opacity(0.2))
                    .cornerRadius(24)
                
                content
            }
            .fill(.horizontal)
        }
    }
}
