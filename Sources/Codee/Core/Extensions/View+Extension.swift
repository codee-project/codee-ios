//
//  View+Extension.swift
//  Codee
//
//  Created by Eryk on 16/03/2025.
//

import SwiftUI

public extension View {
    func action(_ action: OptionalAction) -> some View {
        SwiftUI.Button {
            action?()
        } label: {
            self
        }
    }
}

public extension View {
    func border(color: Color, width: CGFloat = 6, radius: CGFloat = 30) -> some View {
        return VStack {
            self
                .background(Color.whiteDefault)
                .cornerRadius(radius)
                .padding(width)
        }
        .background(color)
        .cornerRadius(radius + 4)
    }
}

public extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

public extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public extension View {
    func defaultBackground(padding: CGFloat = 8, radius: CGFloat = 16, color: Color? = nil) -> some View {
        self
            .padding(padding)
            .background(color ?? Color.gray.opacity(0.12))
            .cornerRadius(radius)
    }
}

public extension View {
    func onFirstAppear(_ action: @escaping Action) -> some View {
        return modifier(OnFirstAppear(action))
    }
}

public struct OnFirstAppear: ViewModifier {
    private let action: () -> Void
    @State private var hasAppeared: Bool = false
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                action()
            }
    }
}

public extension View {
    func fill(_ axios: Axis.Set? = nil, _ alignment: Alignment? = nil) -> some View {
        switch axios {
        case .horizontal:
            return self.frame(
                idealWidth: .infinity,
                maxWidth: .infinity,
                alignment: alignment ?? .leading
            )
        case .vertical:
            return self.frame(
                idealHeight: .infinity,
                maxHeight: .infinity,
                alignment: alignment ?? .leading
            )
        default:
            return self.frame(
                idealWidth: .infinity,
                maxWidth: .infinity,
                idealHeight: .infinity,
                maxHeight: .infinity,
                alignment: alignment ?? .leading
            )
        }
    }
    
    func fill(alignment: Alignment? = nil) -> some View {
        return self.frame(
            idealWidth: .infinity,
            maxWidth: .infinity,
            idealHeight: .infinity,
            maxHeight: .infinity,
            alignment: alignment ?? .leading
        )
    }
    
    func softFill(alignment: Alignment? = nil) -> some View {
        return self.frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: alignment ?? .leading
        )
    }
    
    @ViewBuilder func fill(on: Alignment) -> some View {
        switch on {
        case .top:
            VStack(spacing: .zero) {
                Spacer()
                    .fill(.vertical)
                self
            }
        case .bottom:
            VStack(spacing: .zero) {
                self
                Spacer()
                    .fill(.vertical)
            }
        case .leading:
            HStack(spacing: .zero) {
                Spacer()
                    .fill(.vertical)
                self
            }
        case .trailing:
            HStack(spacing: .zero) {
                self
                Spacer()
                    .fill(.vertical)
            }
        default:
            self
        }
    }
}

public extension View {
    func backgroundBlur(
        lightStyle: UIBlurEffect.Style = .systemThinMaterial,
        darkStyle: UIBlurEffect.Style = .systemThinMaterial,
        colorScheme: ColorScheme = .light,
        cornerRadius: CGFloat = 24
    ) -> some View {
        return self
            .background(Color.whiteDefault.opacity(0.6))
            .background(VisualEffectView(
                blurStyle: colorScheme == .light ? lightStyle : darkStyle,
                vibrancyStyle: .separator
            ))
            .cornerRadius(cornerRadius)
    }
}

public struct VisualEffectBlur<Content: View>: View {
    var blurStyle: UIBlurEffect.Style
    var vibrancyStyle: UIVibrancyEffectStyle?
    let content: Content

    public init(blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle? = nil, @ViewBuilder content: () -> Content) {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        self.content = content()
    }

    public var body: some View {
        ZStack {
            VisualEffectView(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
            content
        }
    }
}

public struct VisualEffectView: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    var vibrancyStyle: UIVibrancyEffectStyle?
    
    public init(blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle? = nil) {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

