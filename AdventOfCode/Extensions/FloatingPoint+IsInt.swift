//
//  FloatingPoint+IsInt.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 13.12.24.
//

import Foundation

extension FloatingPoint {
    var isInt: Bool {
        return floor(self) == self
    }
}
