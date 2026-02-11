//
//  ModalView.swift
//  Codee
//
//  Created by Eryk on 20/08/2025.
//

import SwiftUI

public struct SizeObserver<Content: View>: View {
    @State private var size: CGSize = .zero
    let view: Content
    let updateSizeHandler: (CGSize) -> Void
    
    public init(view: Content, updateSizeHandler: @escaping (CGSize) -> Void) {
        self.view = view
        self.updateSizeHandler = updateSizeHandler
    }
    
    public var body: some View {
        view.background(
            GeometryReader { proxy in
                SwiftUI.Color.clear
                    .accessibilityElement(children: .ignore)
                    .accessibilityHidden(true)
                    .onChange(of: proxy.size) { newSize in
                        DispatchQueue.main.async {
                            if self.size != newSize {
                                self.size = newSize
                                updateSizeHandler(newSize)
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            updateSizeHandler(proxy.size)
                        }
                    }
            }
        )
    }
}

// MARK: - Extension helper
public extension View {
    func getSize(perform: @escaping (CGSize) -> ()) -> some View {
        self.modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                perform($0)
            }
    }
}

public struct SizeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
    }
}

public struct SizePreferenceKey: @MainActor PreferenceKey {
    @MainActor public static var defaultValue: CGSize = .zero
    
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - Modal View Extension
public extension View {
    @ViewBuilder func modal<Content: View>(
        showModal: Binding<Bool>,
        hideModal: @escaping () -> Void = {},
        withTapOnBackground: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            if showModal.wrappedValue {
                Color.blackDefault.opacity(0.1)
                    .background(VisualEffectView(
                        blurStyle: .dark,
                        vibrancyStyle: .separator
                    ))
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                        
                        if withTapOnBackground {
                            showModal.wrappedValue = false
                            hideModal()
                        }
                    }
                
                ModalContentView(content: content)
            }
        }
    }
}

// MARK: - Modal Content View
public struct ModalContentView<Content: View>: View {
    @State private var scrollViewSize: CGSize = .zero
    private let content: Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        content
                            .padding(16)
                    }
                    .frame(maxWidth: .infinity)
                    .getSize { scrollViewSize = $0 }
                }
                .frame(height: scrollViewSize.height < geometry.size.height ? scrollViewSize.height : nil)
            }
            .background(Color.black.opacity(0.6))
            .background(VisualEffectView(
                blurStyle: .dark,
                vibrancyStyle: .separator
            ))
            .cornerRadius(38)
            .padding()
        }
        .frame(maxHeight: scrollViewSize.height + 32)
    }
}
