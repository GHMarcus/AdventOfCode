//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/24

enum Day_24_2021: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2021

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
