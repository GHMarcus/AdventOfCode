//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/4

enum Day_4_2025: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = Set<Pos>

    struct Pos: Hashable {
        let x, y: Int
    }

    static func convert(input: [String]) -> ConvertedInput {
        var paperRolls: Set<Pos> = []
        for (y, line) in input.enumerated() {
            for (x, c) in Array(line).enumerated() {
                if c == "@" {
                    paperRolls.insert(.init(x: x, y: y))
                }
            }
        }
        return paperRolls
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var accessibleRolls = 0
        for roll in input {
            let neighbors: Set<Pos> = [
                .init(x: roll.x - 1, y: roll.y),
                .init(x: roll.x + 1, y: roll.y),
                .init(x: roll.x, y: roll.y - 1),
                .init(x: roll.x, y: roll.y + 1),
                .init(x: roll.x - 1, y: roll.y - 1),
                .init(x: roll.x + 1, y: roll.y + 1),
                .init(x: roll.x - 1, y: roll.y + 1),
                .init(x: roll.x + 1, y: roll.y - 1),
            ]
            if neighbors.intersection(input).count < 4 {
                accessibleRolls += 1
            }
        }
        return "\(accessibleRolls)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var removedRolls = 0
        var rolls = input
        while true {
            var newRolls: Set<Pos> = []
            for roll in rolls {
                let neighbors: Set<Pos> = [
                    .init(x: roll.x - 1, y: roll.y),
                    .init(x: roll.x + 1, y: roll.y),
                    .init(x: roll.x, y: roll.y - 1),
                    .init(x: roll.x, y: roll.y + 1),
                    .init(x: roll.x - 1, y: roll.y - 1),
                    .init(x: roll.x + 1, y: roll.y + 1),
                    .init(x: roll.x - 1, y: roll.y + 1),
                    .init(x: roll.x + 1, y: roll.y - 1),
                ]
                if neighbors.intersection(rolls).count < 4 {
                    removedRolls += 1
                } else {
                    newRolls.insert(roll)
                }
            }
            if newRolls == rolls {
                break
            } else {
                rolls = newRolls
            }
        }
        return "\(removedRolls)"
    }
}
