//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

// https://adventofcode.com/2020/day/1

enum Day_1_2020: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [Int]) -> String {
        for i in 0..<input.count {
            for j in 0..<input.count {
                let sum = input[i] + input[j]
                if sum == 2020 {
                    return "\(input[i] * input[j])"
                }
            }
        }

        return "No combination found"
    }

    static func solvePart2(input: [Int]) -> String {
        for i in 0..<input.count {
            for j in 0..<input.count {
                for n in 0..<input.count {
                    let sum = input[i] + input[j] + input[n]
                    if sum == 2020 {
                        return "\(input[i] * input[j] * input[n])"
                    }
                }
            }
        }

        return "No combination found"
    }
}




