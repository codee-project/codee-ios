//
//  File.swift
//  Codee
//
//  Created by Eryk Chrustek on 03/10/2025.
//

import SwiftUI

public struct SeparatorView: View {
    public var body: some View {
        VStack {}
            .fill(.horizontal)
            .frame(height: 6)
            .background(Color.blackDefault)
            .cornerRadius(6)
            .padding(.horizontal, 48)
            .padding(.bottom, 8)
            .opacity(0.02)
    }
}
