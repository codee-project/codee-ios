//
//  SceneView.swift
//  Codee
//
//  Created by Eryk on 13/08/2025.
//

import SwiftUI

public struct SceneView<Content: View>: View {
    var title: String
    var onAppear: (() -> Void)?
    var withScroll: Bool
    var withNavigation: Bool
    var withBottomPadding: Bool
    var withBackground: Bool
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let padding: CGFloat?
    let background: ImageResource?
    let backgroundBlur: ImageResource?
    var content: Content
    
    public init(
        title: String,
        withScroll: Bool = true,
        withNavigation: Bool = true,
        withBottomPadding: Bool = true,
        withBackground: Bool = true,
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat? = 16,
        padding: CGFloat? = 16,
        background: ImageResource? = nil,
        backgroundBlur: ImageResource? = nil,
        onAppear: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.withScroll = withScroll
        self.withNavigation = withNavigation
        self.withBottomPadding = withBottomPadding
        self.withBackground = withBackground
        self.alignment = alignment
        self.spacing = spacing
        self.padding = padding
        self.background = background
        self.backgroundBlur = backgroundBlur
        self.onAppear = onAppear
        self.content = content()
    }
    
    public var body: some View {
        if withNavigation {
            NavigationView {
                if withScroll {
                    stackWithScroll
                } else {
                    stack
                }
            }
            .background(Color.whiteDefault.ignoresSafeArea())
        } else {
            if withScroll {
                stackWithScroll
                    .background(Color.whiteDefault.ignoresSafeArea())
            } else {
                stack
                    .if(withBackground) { view in
                            view
                            .background(backgroundImage.ignoresSafeArea())
                                .background(Color.whiteDefault.opacity(0.4).ignoresSafeArea())
                    }
                    .if(!withBackground) { view in
                        view.background(backgroundBlurImage.ignoresSafeArea())
                    }
            }
        }
    }
    
    @ViewBuilder var backgroundImage: some View {
        VStack {
            image
        }
        .background(
            image
        )
        .fill()
    }
    
    @ViewBuilder var backgroundBlurImage: some View {
        VStack {
            imageBlur
        }
        .background(
            imageBlur
        )
        .fill()
    }
    
    @ViewBuilder var image: some View {
        if let background {
            Image(background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .fill()
        }
    }
    
    @ViewBuilder var imageBlur: some View {
        if let backgroundBlur {
            Image(backgroundBlur)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .fill()
        }
    }
    
    @ViewBuilder var stackWithScroll: some View {
        ScrollView {
            stack
        }
        .if(withBackground) { view in
                view
                    .background(backgroundImage)
                    .background(Color.whiteDefault.opacity(0.9))
        }
        .if(!withBackground) { view in
                view
                    .background(backgroundBlurImage)
                    .background(Color.whiteDefault.opacity(0.9))
        }
    }
    
    @ViewBuilder var stack: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
        }
        .navigationBarTitle(title, displayMode: .large)
        .onAppear {
            onAppear?()
        }
        .if(padding.isNotNil) { view in
            view.padding(padding.orZero)
        }
        .if(withBottomPadding) { view in
            view.padding(.bottom)
        }
    }
}
