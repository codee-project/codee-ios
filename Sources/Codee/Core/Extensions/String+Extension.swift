//
//  String+Extension.swift
//  Codee
//
//  Created by Eryk on 02/04/2025.
//

import Foundation

public extension String {
    static let empty: String = ""
}

public extension Optional<String> {
    var orEmpty: String {
        self ?? ""
    }
}

public extension String {
    var firstCapitalized: String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}
