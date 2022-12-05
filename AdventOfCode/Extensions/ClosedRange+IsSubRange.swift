//
//  ClosedRange+IsSubRange.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 05.12.22.
//

extension ClosedRange {
    func isSubRange(of other: Self) -> Bool {
        other.clamped(to: self) == other
    }
}
