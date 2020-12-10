//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/10

import Foundation

enum Day_10_2020: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [Int]) -> String {
        let sortedInput = [0] + input.sorted()
        var oneJolts = 0
        var threeJolts = 0


        for i in 0 ..< sortedInput.count {
            guard i+1 < sortedInput.count else { break }
            let jolt = sortedInput[i]
            let nextJolt = sortedInput[i+1]
            let diff = nextJolt - jolt
            if diff == 1 {
                oneJolts += 1
            } else if diff == 3 {
                threeJolts += 1
            }
        }

        threeJolts += 1

        return "\(oneJolts * threeJolts)"
    }

    static func solvePart2(input: [Int]) -> String {
        var diffs = ""
        let sortedInput = [0] + input.sorted()
        for i in 0 ..< sortedInput.count {
            guard i+1 < sortedInput.count else { break }
            let jolt = sortedInput[i]
            let nextJolt = sortedInput[i+1]
            let diff = nextJolt - jolt
            diffs.append("\(diff)")
        }

        let fourInARow = diffs.components(separatedBy: "1111").count - 1
        diffs = diffs.replacingOccurrences(of: "1111", with: "")
        let threeInARow = diffs.components(separatedBy: "111").count - 1
        diffs = diffs.replacingOccurrences(of: "111", with: "")
        let twoInARow = diffs.components(separatedBy: "11").count - 1
        let result = pow(7, fourInARow) * pow(4, threeInARow) * pow(2, twoInARow)

        return "\(result)"
    }
}
