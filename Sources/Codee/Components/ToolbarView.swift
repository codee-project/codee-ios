//
//  ToolbarView.swift
//  Codee
//
//  Created by Eryk Chrustek on 03/10/2025.
//

import SwiftUI

extension View {
    @ViewBuilder func backAction(_ action: @escaping () -> Void) -> some View {
        self
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SwiftUI.Button {
                        action()
                    } label: {
                        Image(.close)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .foregroundColor(.blackDefault)
                            .frame(width: 18, height: 18)
                    }
                }
            }
    }
}
