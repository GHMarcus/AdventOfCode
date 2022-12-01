//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/1

enum Day_1_2022: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2022

    static func solvePart1(input: [String]) -> String {
        var calories: [Int] = []

        var currentElfsCalorien = 0
        for line in input {
            if line.isEmpty {
                calories.append(currentElfsCalorien)
                currentElfsCalorien = 0
                continue
            }

            currentElfsCalorien += Int(line)!
        }
        calories.append(currentElfsCalorien)


        return "\(calories.max()!)"
    }

    static func solvePart2(input: [String]) -> String {
        var calories: [Int] = []

        var currentElfsCalorien = 0
        for line in input {
            if line.isEmpty {
                calories.append(currentElfsCalorien)
                currentElfsCalorien = 0
                continue
            }

            currentElfsCalorien += Int(line)!
        }
        calories.append(currentElfsCalorien)

        calories.sort { $0 > $1 }

        let total = calories.prefix(3).reduce(0, +)

        return "\(total)"
    }
}
