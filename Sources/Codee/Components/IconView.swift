//
//  IconView.swift
//  Codee
//
//  Created by Eryk on 09/09/2025.
//

import SwiftUI

public struct IconView: View {
    let icon: Icon
    let size: CGFloat?
    let foregroundColor: Color?
    
    public init(
        icon: Icon,
        size: CGFloat? = nil,
        foregroundColor: Color? = nil
    ) {
        self.icon = icon
        self.size = size
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        Image(systemName: icon.rawValue)
            .foregroundColor(foregroundColor)
            .if(size != nil) { view in
                view.font(.system(size: size.orZero))
            }
    }
}
