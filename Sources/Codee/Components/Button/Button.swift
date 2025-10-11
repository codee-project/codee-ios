//
//  Button.swift
//  Codee
//
//  Created by Eryk on 02/04/2025.
//

import SwiftUI

public enum ButtonType: Equatable {
    case `default`
    
    case borderd(
        width: CGFloat,
        color: Color,
        radius: CGFloat
    )
}

public enum ButtonIcon {
    case without
    
    case icon(
        alignment: HorizontalAlignment,
        icon: Icon,
        iconColor: Color
    )
}

public enum ButtonSize {
    case fill(
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat
    )
    
    case small(
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat
    )
}

public struct ButtonModel {
    let title: String
    
    let type: ButtonType
    let size: ButtonSize
    let icon: ButtonIcon
    let isDisabled: Bool
    
    let textColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    let action: (() -> Void)?
    
    public init(
        title: String,
        type: ButtonType = .default,
        icon: ButtonIcon = .without,
        size: ButtonSize = .fill(
            horizontalPadding: 16,
            verticalPadding: 16
        ),
        isDisabled: Bool = false,
        textColor: Color = .whiteDefault,
        backgroundColor: Color = .blackDefault,
        cornerRadius: CGFloat = 30,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.type = type
        self.icon = icon
        self.size = size
        self.isDisabled = isDisabled
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
}

public struct Button: View {
    let model: ButtonModel
    
    public init(model: ButtonModel) {
        self.model = model
    }
    
    public init(
        title: String,
        type: ButtonType = .default,
        icon: ButtonIcon = .without,
        size: ButtonSize = .fill(
            horizontalPadding: 16,
            verticalPadding: 16
        ),
        isDisabled: Bool = false,
        textColor: Color = .whiteDefault,
        backgroundColor: Color = .blackDefault,
        cornerRadius: CGFloat = 30,
        action: (() -> Void)? = nil
    ) {
        self.model = .init(
            title: title,
            type: type,
            icon: icon,
            size: size,
            isDisabled: isDisabled,
            textColor: textColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            action: action
        )
    }
    
    public var body: some View {
        if let action = model.action {
            SwiftUI.Button(action: {
                action()
            }) {
                iconAndText
            }
            .disabled(model.isDisabled)
        } else {
            iconAndText
        }
    }
    
    @ViewBuilder var iconAndText: some View {
        HStack {
            switch model.icon {
            case .without:
                text
            case .icon(let alignment, let icon, let iconColor):
                switch alignment {
                case .leading:
                    iconView(icon, iconColor)
                    text
                case .trailing:
                    text
                    iconView(icon, iconColor)
                default:
                    iconView(icon, iconColor)
                    text
                }
            }
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .if(isFill) { view in
            view.fill(.horizontal, .center)
        }
        .background(model.backgroundColor)
        .cornerRadius(model.cornerRadius)
        .if(model.type != ButtonType.default) { view in
            VStack {
                switch model.type {
                case .borderd(let width, let color, let radius):
                    view.border(color: color, width: width, radius: radius)
                default:
                    view
                }
            }
        }
    }
    
    @ViewBuilder func iconView(_ icon: Icon, _ iconColor: Color) -> some View {
        Image(systemName: icon.rawValue)
            .foregroundColor(iconColor)
            .opacity(model.isDisabled ? 0.6 : 1)
    }
    
    @ViewBuilder var text: some View {
        if !model.title.isEmpty {
            Text(model.title)
                .font(.headline)
                .foregroundColor(model.textColor)
        }
    }
    
    var verticalPadding: CGFloat {
        switch model.size {
        case .fill(_, let verticalPadding):
            return verticalPadding
        case .small(_, let verticalPadding):
            return verticalPadding
        }
    }
    
    var horizontalPadding: CGFloat {
        switch model.size {
        case .fill(let horizontalPadding, _):
            return horizontalPadding
        case .small(let horizontalPadding, _):
            return horizontalPadding
        }
    }
    
    var isFill: Bool {
        switch model.size {
        case .fill(_, _):
            return true
        case .small(_, _):
            return false
        }
    }
}

#Preview {
    VStack {
        Button(
            model: .init(title: "Default")
        )
        
        Button(
            model: .init(
                title: "Button",
                type: .borderd(width: 2, color: .red, radius: 2),
                textColor: .red,
                backgroundColor: .white,
                cornerRadius: 2
            )
        )
        
        Button(
            model: .init(
                title: "Green",
                type: .borderd(width: 6, color: .green, radius: 12),
                size: .small(horizontalPadding: 16, verticalPadding: 8),
                textColor: .green,
                backgroundColor: .green.opacity(0.1),
                cornerRadius: 12
            )
        )
        
        Button(
            model: .init(
                title: "Gray",
                size: .small(horizontalPadding: 24, verticalPadding: 12),
                textColor: .black,
                backgroundColor: .gray.opacity(0.2),
                cornerRadius: 24
            )
        )
    }
    .padding()
}
