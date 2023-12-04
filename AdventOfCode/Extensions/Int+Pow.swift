//
//  Int+Pow.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.23.
//

extension Int {
    func pow(_ toPower: Int) -> Int {
        guard toPower >= 0 else { return 0 }
        return Array(repeating: self, count: toPower).reduce(1, *)
    }
}
