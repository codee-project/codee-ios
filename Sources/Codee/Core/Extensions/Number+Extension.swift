//
//  Number+Extension.swift
//  Codee
//
//  Created by Eryk on 25/03/2025.
//

import Foundation

public extension Int {
    var toString: String {
        String(self)
    }
}

public extension Optional<Int> {
    var orZero: Int {
        return self ?? 0
    }
}

public extension Optional<CGFloat> {
    var orZero: CGFloat {
        return self ?? 0
    }
}

public extension String {
    var toInt: Int {
        Int(self) ?? 0
    }
}

public extension Int {
    var amount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.usesGroupingSeparator = true
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
