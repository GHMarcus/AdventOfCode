//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/1

enum Day_1_2015: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        var floor = 0
        let instructions = Array(input[0])
        for instruction in instructions {
            if instruction == "(" {
                floor += 1
            } else if instruction == ")" {
                floor -= 1
            }
        }
        return "\(floor)"
    }

    static func solvePart2(input: [String]) -> String {
        let instructions = Array(input[0])
        var floor = 0
        for i in 0..<instructions.count {
            let instruction = instructions[i]
            if instruction == "(" {
                floor += 1
            } else if instruction == ")" {
                floor -= 1
            }

            if floor == -1 {
                return "\(i+1)"
            }
        }
        return "No instruction found"
    }
}
