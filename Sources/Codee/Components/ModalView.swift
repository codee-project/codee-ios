//
//  ModalView.swift
//  Codee
//
//  Created by Eryk on 20/08/2025.
//

import SwiftUI

public enum Modal {
    @MainActor
    public class ViewModel: ObservableObject {
        // MARK: Properties
        @Published var isPresented: Bool
        @Published var visibilityTime: TimeInterval?

        var text: String

        // MARK: Initializer
        public init(
            text: String,
            visibilityTime: TimeInterval? = nil
        ) {
            self.text = text
            self.visibilityTime = visibilityTime
            self.isPresented = false
        }

        // MARK: Helpers
        public func display(text: String? = nil) {
            if let text = text {
                self.text = text
            }

            isPresented = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.isPresented = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                    self?.isPresented = false
                }
            }
        }

        public func hide() {
            isPresented = false
        }
    }
}

public extension Modal {
    struct ContentView: View {
        // MARK: Properties
        @ObservedObject private var viewModel: ViewModel

        // MARK: Initializers
        public init(viewModel: ViewModel) {
            self.viewModel = viewModel
        }

        // MARK: View
        public var body: some View {
            withAnimation {
                VStack {
                    if viewModel.isPresented {
                        content
                            .padding(4)
                            .fill(.horizontal, .center)
                            .background(Color.white.opacity(0.1))
                            .background(Color.black.opacity(0.6))
                            .background(VisualEffectView(
                                blurStyle: .dark,
                                vibrancyStyle: .separator
                            ))
                            .cornerRadius(38)
                            .padding(12)
                            .padding(.bottom, 50)
                    }
                }
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: viewModel.isPresented)
            }
        }
    }
}

// MARK: View elements
private extension Modal.ContentView {
    @ViewBuilder var content: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    text
                }
                .padding(.vertical, 16)
                .padding(.leading, 24)
                .padding(.trailing, 16)
            }
            
            closeButton
                .padding(.vertical, 10)
                .padding(.trailing, 10)
        }
    }

    @ViewBuilder var text: some View {
        Text(viewModel.text)
            .font(.body)
            .fill(.horizontal, .leading)
            .foregroundColor(.white)
    }

    @ViewBuilder var closeButton: some View {
        SwiftUI.Button {
            viewModel.isPresented = false
            viewModel.visibilityTime = nil
        } label: {
            Image(systemName: "x.circle.fill")
                .foregroundColor(.gray)
                .font(.system(size: 26, weight: .bold))
                .padding(6)
                .frame(width: 40, height: 40)
        }
    }
}

public struct ModalContainerView<ContentView: View>: View {
    private let isPresented: Binding<Bool>
    private let dismissAfterSeconds: TimeInterval?
    private let contentView: () -> ContentView
    private let text: String

    public init(
        isPresented: Binding<Bool>,
        text: String,
        dismissAfterSeconds: TimeInterval?,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) {
        self.isPresented = isPresented
        self.text = text
        self.dismissAfterSeconds = dismissAfterSeconds
        self.contentView = contentView
    }

    public var body: some View {
        ZStack {
            contentView()

            VStack {
                if isPresented.wrappedValue {
                    HStack {
                        Text(text)
                            .foregroundColor(Color.whiteDefault)
                    }
                    .background(Color.blackDefault)
                    .padding(16)
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        guard let dismissAfterSeconds = dismissAfterSeconds else { return }

                        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfterSeconds) {
                            withAnimation {
                                self.isPresented.wrappedValue = false
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isPresented.wrappedValue)
        }
    }
}

public enum ModalAlignment {
    case top
    case bottom
    
    public var rawAlignment: Alignment {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

// MARK: View extension
public extension View {
    @ViewBuilder func modal<Content: View>(
        showModal: Binding<Bool>,
        hideModal: @escaping () -> Void = {},
        content: () -> Content
    ) -> some View {
        ZStack(alignment: .center) {
            self
            
            if showModal.wrappedValue {
                Color.blackDefault.opacity(0.1)
                    .background(VisualEffectView(
                        blurStyle: .dark,
                        vibrancyStyle: .separator
                    ))
                    .ignoresSafeArea()
                    .onTapGesture {
                        showModal.wrappedValue = false
                        hideModal()
                    }
                
                VStack(spacing: 24) {
                    content()
                }
                .padding(16)
                .fill(.horizontal, .center)
                .background(Color.black.opacity(0.6))
                .background(VisualEffectView(
                    blurStyle: .dark,
                    vibrancyStyle: .separator
                ))
                .cornerRadius(32)
                .padding()
            }
        }
    }
}
