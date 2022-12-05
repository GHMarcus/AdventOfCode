//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/4

enum Day_4_2022: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2022

    static func solvePart1(input: [String]) -> String {
        var numberOfFullyOverlapping = 0

        for line in input {
            let cmp = line.components(separatedBy: ",")
            let rst1 = cmp[0].components(separatedBy: "-")
            let rst2 = cmp[1].components(separatedBy: "-")

            let r1 = ClosedRange(uncheckedBounds: (Int(rst1[0])!, Int(rst1[1])!))
            let r2 = ClosedRange(uncheckedBounds: (Int(rst2[0])!, Int(rst2[1])!))

            if r1.isSubRange(of: r2) || r2.isSubRange(of: r1) {
                numberOfFullyOverlapping += 1
            }
        }


        return "\(numberOfFullyOverlapping)"
    }

    static func solvePart2(input: [String]) -> String {
        var numberOfOverlapping = 0

        for line in input {
            let cmp = line.components(separatedBy: ",")
            let rst1 = cmp[0].components(separatedBy: "-")
            let rst2 = cmp[1].components(separatedBy: "-")

            let r1 = ClosedRange(uncheckedBounds: (Int(rst1[0])!, Int(rst1[1])!))
            let r2 = ClosedRange(uncheckedBounds: (Int(rst2[0])!, Int(rst2[1])!))

            if r1.isSubRange(of: r2) || r2.isSubRange(of: r1) {
                numberOfOverlapping += 1
            } else if r1.contains(r2.lowerBound) || r1.contains(r2.upperBound) {
                numberOfOverlapping += 1
            } else if r2.contains(r1.lowerBound) || r2.contains(r1.upperBound) {
                numberOfOverlapping += 1
            }
        }
        return "\(numberOfOverlapping)"
    }
}
