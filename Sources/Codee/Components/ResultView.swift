//
//  ResultView.swift
//  Codee
//
//  Created by Eryk on 02/04/2025.
//

import SwiftUI

public struct ResultView: View {
    let icon: Icon
    let color: Color
    let title: String
    let description: String?
    let isSmall: Bool
    let withBackground: Bool
    
    public init(
        isSmall: Bool = false,
        withBackground: Bool = false,
        icon: Icon,
        color: Color,
        title: String,
        description: String?
    ) {
        self.isSmall = isSmall
        self.icon = icon
        self.color = color
        self.title = title
        self.description = description
        self.withBackground = withBackground
    }
    
    public init(
        isSuccess: Bool,
        isSmall: Bool = false,
        withBackground: Bool = false,
        title: String,
        description: String?
    ) {
        self.icon = isSuccess ? .checkmark : .xmark
        self.color = isSuccess ? .green : .red
        self.isSmall = isSmall
        self.title = title
        self.description = description
        self.withBackground = withBackground
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon.rawValue)
                .font(.system(size: isSmall ? 80 : 120))
                .foregroundStyle(color, color.opacity(0.12))
            
            Text(title)
                .font(isSmall ? .title3 : .title)
                .multilineTextAlignment(.center)
                .bold()
            
            if let description {
                Text(description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .if(withBackground) { view in
            view.backgroundBlur()
        }
    }
}

public struct ResultCustomView<Content: View>: View {
    let icon: Icon
    let color: Color
    let title: String
    let description: String?
    var content: Content?
    
    public init(
        icon: Icon,
        color: Color,
        title: String,
        description: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.icon = icon
        self.color = color
        self.title = title
        self.description = description
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            ResultView(
                icon: icon,
                color: color,
                title: title,
                description: description
            )
            
            if let content {
                content
            }
        }
    }
}

