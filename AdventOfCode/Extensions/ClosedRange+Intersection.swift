//
//  ClosedRange+Intersection.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 29.10.25.
//

extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
    func intersection(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        let lower = Swift.max(self.lowerBound, other.lowerBound)
        let upper = Swift.min(self.upperBound, other.upperBound)
        return lower <= upper ? lower...upper : nil
    }
    
    func subtract(_ other: ClosedRange<Bound>) -> [ClosedRange<Bound>] {
        guard let intersection = self.intersection(other) else {
            // kein overlap → Rückgabe des Originalbereichs
            return [self]
        }

        var result: [ClosedRange<Bound>] = []

        if intersection.lowerBound > self.lowerBound {
            // linker Rest
            let newUpper = intersection.lowerBound.advanced(by: -1)
            if newUpper >= self.lowerBound {
                result.append(self.lowerBound...newUpper)
            }
        }

        if intersection.upperBound < self.upperBound {
            // rechter Rest
            let newLower = intersection.upperBound.advanced(by: 1)
            if newLower <= self.upperBound {
                result.append(newLower...self.upperBound)
            }
        }

        return result
    }
}
