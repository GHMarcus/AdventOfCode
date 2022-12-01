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
        var calories = sumUpCaloriesPerElf(for: input)

        return "\(calories.max()!)"
    }

    static func solvePart2(input: [String]) -> String {
        var calories = sumUpCaloriesPerElf(for: input)
        
        calories.sort { $0 > $1 }

        let total = calories.prefix(3).reduce(0, +)

        return "\(total)"
    }
    
    private static func sumUpCaloriesPerElf(for input: [String]) -> [Int] {
        var calories: [Int] = []
        var currentElfsCalories = 0
        var input = input
        // To collect the last sum automatically
        input.append("")
        for line in input {
            if line.isEmpty {
                calories.append(currentElfsCalories)
                currentElfsCalories = 0
                continue
            }

            currentElfsCalories += Int(line)!
        }
        return calories
    }
}
