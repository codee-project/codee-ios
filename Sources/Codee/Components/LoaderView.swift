//
//  LoaderView.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import SwiftUI

public extension View {
    @ViewBuilder func loader(_ isLoading: Binding<Bool>) -> some View {
        ZStack {
            self
                .disabled(isLoading.wrappedValue)
                .allowsHitTesting(!isLoading.wrappedValue)

            if isLoading.wrappedValue {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)

                LoaderView()
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isLoading.wrappedValue)
    }
}

public struct LoaderView: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1
    
    public var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 60, height: 60)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    self.scale = 1.4
                    self.opacity = 1
                }
            }
    }
}
