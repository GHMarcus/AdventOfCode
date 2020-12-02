//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

// https://adventofcode.com/2020/day/1

enum Day_1_2020: Solvable {
    static func solve() {
        let day: Input.Day = .Day_1
        let year: Input.Year = .Year_2020

        let numbers = Input.getIntArray(for: day, in: year)
        print("********** \(day.rawValue) Year \(year.rawValue) **********")
        print("Solution for Part 1: \(solvePart1(numbers: numbers))")
        print("Solution for Part 2: \(solvePart2(numbers: numbers))")
        print("*************************************")
    }

    private static func solvePart1(numbers: [Int]) -> String {
        for i in 0..<numbers.count {
            for j in 0..<numbers.count {
                let sum = numbers[i] + numbers[j]
                if sum == 2020 {
                    return "\(numbers[i] * numbers[j])"
                }
            }
        }

        return "No combination found"
    }

    private static func solvePart2(numbers: [Int]) -> String {
        for i in 0..<numbers.count {
            for j in 0..<numbers.count {
                for n in 0..<numbers.count {
                    let sum = numbers[i] + numbers[j] + numbers[n]
                    if sum == 2020 {
                        return "\(numbers[i] * numbers[j] * numbers[n])"
                    }
                }
            }
        }

        return "No combination found"
    }
}




