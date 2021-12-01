//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/1

enum Day_1_2021: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [Int]) -> String {
        var previousValue = Int.max
        var increasings = 0
        for measurement in input {
            if measurement > previousValue {
                increasings += 1
            }
            previousValue = measurement
        }
        return "\(increasings)"
    }

    static func solvePart2(input: [Int]) -> String {
        var previousValue = Int.max
        var increasings = 0
        for i in 0...input.count-3 {
            let window = input[i] + input[i+1] + input[i+2]
            if window > previousValue {
                increasings += 1
            }
            previousValue = window
        }
        return "\(increasings)"
    }
}
