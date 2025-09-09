//
//  SocialButton.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import SwiftUI

public struct SocialButton: View {
    let icon: ImageResource
    let borderColor: Color
    let action: () -> Void
    
    public init(
        icon: ImageResource,
        borderColor: Color,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.borderColor = borderColor
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            ZStack {
                VStack {}
                    .frame(width: 60, height: 60)
                    .background(Circle().stroke(borderColor.opacity(0.4), lineWidth: 6))
                
                Image(icon)
                    .resizable()
                    .scaledToFill()
                    .padding(16)
                    .frame(width: 80, height: 80)
            }
        }
    }
}
