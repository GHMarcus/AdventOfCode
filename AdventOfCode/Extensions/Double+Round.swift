//
//  Double+Round.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 13.12.24.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
