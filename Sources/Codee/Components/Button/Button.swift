//
//  Button.swift
//  Codee
//
//  Created by Eryk on 02/04/2025.
//

import SwiftUI

public enum ButtonStyle {
    case primary
    case secondary
    case tertiary
    case purple
    case blue
    case red
    case green
    case gray
    case custom(Color, Color)
}

public struct Button: View {
    let title: String
    let icon: Icon?
    let iconColor: Color?
    let style: ButtonStyle
    let isFill: Bool
    let isSmall: Bool
    let isDisabled: Bool
    let isOn: Binding<Bool>?
    let action: (() -> Void)?
    
    public init(
        style: ButtonStyle = .primary,
        title: String,
        icon: Icon? = nil,
        iconColor: Color? = nil,
        isFill: Bool = true,
        isSmall: Bool = false,
        isDisabled: Bool = false,
        isOn: Binding<Bool>? = nil,
        action: (() -> Void)? = nil
    ) {
        self.style = style
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.isFill = isFill
        self.isSmall = isSmall
        self.isDisabled = isDisabled
        self.isOn = isOn
        self.action = action
    }
    
    public var body: some View {
        if let action {
            SwiftUI.Button(action: {
                action()
            }) {
                text
            }
            .disabled(isDisabled)
        } else {
            text
        }
    }
    
    var text: some View {
        HStack {
            if let icon {
                Image(systemName: icon.rawValue)
                    .foregroundColor(
                        isDisabled ? foregroundColor :
                            (iconColor ?? foregroundColor)
                    )
                    .opacity(isDisabled ? 0.6 : 1)
            }
            
            if !title.isEmpty {
                Text(title)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
                    .if(isOn.isNotNil) { view in
                        view.fill(.horizontal, .leading)
                    }
            }
            
            if isOn.isNotNil {
                HStack {
                    HStack {
                        
                    }
                    .frame(width: 32, height: 32)
                    .background(isOn.isTrue ? Color.blackDefault : .gray)
                    .cornerRadius(32)
                    .padding(4)
                }
                .frame(width: 60, height: 40, alignment: isOn.isTrue ? .trailing : .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(32)
            }
        }
        .padding(.vertical, isSmall ? (isSecondary ? 8 : 10) : (isSecondary ? 14 : 18))
        .padding(.horizontal, isSmall ? 12 : 30)
        .if(isFill) { view in
            view.fill(.horizontal, isOn.isTrue ? .leading : .center)
        }
        .background(backgroundColor)
        .cornerRadius(isSmall ? 16 : 30)
        .if(isSecondary) { view in
            view
                .backgroundBlur()
                .border(color: iconColor?.opacity(0.3) ?? .gray.opacity(0.2))
        }
    }
    
    var isSecondary: Bool {
        switch style {
        case .secondary:
            return true
        default:
            return false
        }
    }
    
    var foregroundColor: Color {
        if !isDisabled {
            switch style {
            case .primary:
                return .whiteDefault
            case .secondary:
                return .blackDefault
            case .tertiary:
                return .black
            case .purple:
                return .purple
            case .blue:
                return .blue
            case .red:
                return .red
            case .green:
                return .green
            case .gray:
                return .white
            case .custom(let textColor, _):
                return textColor
            }
        } else {
            return .gray.opacity(0.6)
        }
    }
    
    var backgroundColor: Color {
        if !isDisabled {
            switch style {
            case .primary:
                return .blackDefault
            case .secondary:
                return .clear
            case .tertiary:
                return .white
            case .purple:
                return .purple.opacity(0.2)
            case .blue:
                return .blue.opacity(0.2)
            case .red:
                return .red.opacity(0.2)
            case .green:
                return .green.opacity(0.2)
            case .gray:
                return .gray.opacity(0.05)
            case .custom(_, let backgroundColor):
                return backgroundColor
            }
        } else {
            return .gray.opacity(0.4)
        }
    }
}
