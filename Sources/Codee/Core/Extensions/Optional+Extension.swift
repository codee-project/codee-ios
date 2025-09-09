//
//  Optional+Extension.swift
//  Codee
//
//  Created by Eryk on 04/04/2025.
//

import SwiftUI

public extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return !isNil
    }
    
    var isTrue: Bool {
        return self == nil
    }
}

public extension Optional<Bool> {
    var isTrue: Bool {
        return self ?? false
    }
}

public extension Optional<Binding<Bool>> {
    var isTrue: Bool {
        return self?.wrappedValue ?? false
    }
}
