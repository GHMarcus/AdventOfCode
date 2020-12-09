//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/9

enum Day_9_2020: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2020

    static var weakSpot: Int = 0

    static func solvePart1(input: [Int]) -> String {
        let preamble = 25
        var error = true
        for i in preamble..<input.count {
            let current = input[i]
            outerLoop: for f in i-preamble...i {
                let first = input[f]
                for s in i-preamble...i {
                    let second = input[s]
                    if first == second {
                        continue
                    } else if current == first + second{
                        error = false
                        break outerLoop
                    } else {
                        error = true
                    }
                }
            }
            if error {
                weakSpot = current
                return "\(current)"
            }
        }
        return "Nothing found"
    }

    static func solvePart2(input: [Int]) -> String {
        var sum = 0
        var first = 0
        var last = 1
        for f in first..<input.count {
            sum += input[f]
            for l in last..<input.count {
                sum += input[l]
                if sum > weakSpot {
                    break
                } else if sum == weakSpot {
                    let values = input[f...l]
                    return "\((values.min() ?? 0) + (values.max() ?? 0))"
                }
            }
            sum = 0
            first += 1
            last += 1
        }
        return "Nothing found"
    }
}
