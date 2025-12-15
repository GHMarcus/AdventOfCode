//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/2

enum Day_2_2025: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [ClosedRange<Int>]

    static func convert(input: [String]) -> ConvertedInput {
        var ranges: [ClosedRange<Int>] = []
        for line in input[0].components(separatedBy: ",") {
            let split = line.components(separatedBy: "-")
            let start = Int(split[0])!
            let end = Int(split[1])!
            ranges.append(start...end)
        }
        return ranges
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var sum = 0
        for range in input {
            for number in range {
                let str = String(number)
                let count = str.count
                guard count.isEven else { continue }
                let firstHalf = str.prefix(count / 2)
                let secondHalf = str.suffix(count / 2)
                if firstHalf == secondHalf {
                    sum += number
                }
            }
        }
        return "\(sum)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var sum = 0
        for range in input {
            for number in range {
                let str = String(number)
                let count = str.count
                let halfCount = str.count / 2
                guard count > 1 else { continue }
                for c in 1...halfCount {
                    let pattern = str.suffix(c)
                    let newStr = str.replacingOccurrences(of: String(pattern), with: "")
                    if newStr.isEmpty {
                        sum += number
                        break
                    }
                }
            }
        }
        return "\(sum)"
    }
}
