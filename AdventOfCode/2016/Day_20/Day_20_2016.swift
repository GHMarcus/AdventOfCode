//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/20

enum Day_20_2016: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2016
    
    static func convert(input: [String]) -> [ClosedRange<Int>] {
        var ranges: [ClosedRange<Int>] = []
        for line in input {
            let cmp = line.components(separatedBy: "-")
            ranges.append(ClosedRange(uncheckedBounds: (lower: Int(cmp[0])!, upper: Int(cmp[1])!)))
        }
        return ranges.sorted { $0.lowerBound < $1.lowerBound }
    }

    static func solvePart1(input: [ClosedRange<Int>]) -> String {
        var ranges: [ClosedRange<Int>] = [ClosedRange(uncheckedBounds: (lower: 0, upper: 4294967295))]
        for blockedRange in input {
            var newRanges: [ClosedRange<Int>] = []
            for range in ranges {
                if let overlap = range.intersection(blockedRange) {
                    newRanges.append(contentsOf: range.subtract(overlap))
                } else {
                    newRanges.append(range)
                }
            }
            ranges = newRanges
        }
        
        let minAllowedIp = ranges.min(by: { $0.lowerBound < $1.lowerBound })?.lowerBound ?? -1
        
        return "\(minAllowedIp)"
    }

    static func solvePart2(input: [ClosedRange<Int>]) -> String {
        var ranges: [ClosedRange<Int>] = [ClosedRange(uncheckedBounds: (lower: 0, upper: 4294967295))]
        for blockedRange in input {
            var newRanges: [ClosedRange<Int>] = []
            for range in ranges {
                if let overlap = range.intersection(blockedRange) {
                    newRanges.append(contentsOf: range.subtract(overlap))
                } else {
                    newRanges.append(range)
                }
            }
            ranges = newRanges
        }
        
        var allowedCount = 0
        
        for range in ranges {
            allowedCount += range.upperBound - range.lowerBound + 1
        }
        
        return "\(allowedCount)"
    }
}
