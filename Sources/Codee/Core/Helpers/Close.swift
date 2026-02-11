//
//  File.swift
//  Codee
//
//  Created by Eryk Chrustek on 11/02/2026.
//

import SwiftUI

public extension View {
    @ViewBuilder func closeAction(isClose: Binding<Bool> = .constant(false), _ action: @escaping () -> Void) -> some View {
        self
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Spacer()
                        
                        SwiftUI.Button {
                            action()
                        } label: {
                            VStack {
                                Image(isClose.wrappedValue ? .close : .arrowRight)
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFill()
                                    .foregroundColor(.blackDefault)
                                    .frame(
                                        width: isClose.wrappedValue ? 18 : 22,
                                        height: isClose.wrappedValue ? 18 : 22
                                    )
                                    .rotationEffect(.degrees(180))
                            }
                            .background(.white.opacity(0.001))
                        }
                        
                        Spacer()
                    }
                }
                
            }
            .enableSwipeBack()
    }
}
