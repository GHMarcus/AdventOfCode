//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

// https://adventofcode.com/2020/day/1

enum Day_1_2020: Solvable {
    static func solve() {
        let numbers = Input.getIntArray(for: .Day_1, in: .Year_2020)
        print("Solution for Part 1: \(solvePart1(numbers: numbers))")
        print("Solution for Part 2: \(solvePart2(numbers: numbers))")
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




