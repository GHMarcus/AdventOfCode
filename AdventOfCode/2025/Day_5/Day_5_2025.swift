//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/5

enum Day_5_2025: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = (ranges: [ClosedRange<Int>], ingredients: [Int])

    static func convert(input: [String]) -> ConvertedInput {
        var ranges: [ClosedRange<Int>] = []
        var ingredients: [Int] = []

        var isRanges = true

        for line in input {
            if line.isEmpty {
                isRanges = false
                continue
            }
            if isRanges {
                let cmp = line.components(separatedBy: "-")
                ranges.append(Int(cmp[0])!...Int(cmp[1])!)
            } else {
                ingredients.append(Int(line)!)
            }
        }

        return (ranges, ingredients)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var freshCount = 0

        for id in input.ingredients {
            if isFresh(id: id, in: input.ranges) {
                freshCount += 1
            }
        }
        
        return "\(freshCount)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var freshIdCount = 0

        var prevRange: ClosedRange<Int>? = nil

        for range in input.ranges.sorted (by: { $0.lowerBound < $1.lowerBound }) {
            if let pRange = prevRange {
                if pRange.contains(range.lowerBound) {
                    if pRange.contains(range.upperBound) {
                        continue
                    } else {
                        let intersection = pRange.intersection(range)!
                        freshIdCount += range.count - intersection.count
                        prevRange = range
                    }
                } else {
                    freshIdCount += range.count
                    prevRange = range
                }
            } else {
                freshIdCount += range.count
                prevRange = range
            }
        }

        return "\(freshIdCount)"
    }

    static func isFresh(id: Int, in ranges: [ClosedRange<Int>]) -> Bool {
        for range in ranges {
            if range.contains(id) {
                return true
            }
        }
        return false
    }
}
