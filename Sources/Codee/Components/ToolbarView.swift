//
//  ToolbarView.swift
//  Codee
//
//  Created by Eryk Chrustek on 03/10/2025.
//

import SwiftUI

public extension View {
    @ViewBuilder func backAction(_ action: @escaping () -> Void) -> some View {
        self
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SwiftUI.Button {
                        action()
                    } label: {
                        VStack {
                            Image(.closeDefault)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFill()
                                .foregroundColor(.blackDefault)
                                .frame(width: 24, height: 24)
                        }
                        .background(.white.opacity(0.001))
                    }
                }
            }
    }
}
