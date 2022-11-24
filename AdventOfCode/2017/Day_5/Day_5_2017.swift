//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/5

enum Day_5_2017: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2017

    static func solvePart1(input: [Int]) -> String {
        var instructions = input
        var pointer = 0
        var steps = 0
        
        while true {
            if pointer >= instructions.count || pointer < 0 {
                break
            }
            steps += 1
            var current = instructions[pointer]
            let nextPointer = pointer + current
            current += 1
            instructions[pointer] = current
            pointer = nextPointer
        }
        
        return "\(steps)"
    }

    static func solvePart2(input: [Int]) -> String {
        var instructions = input
        var pointer = 0
        var steps = 0
        
        while true {
            if pointer >= instructions.count || pointer < 0 {
                break
            }
            steps += 1
            var current = instructions[pointer]
            let nextPointer = pointer + current
            if current >= 3 {
                current -= 1
            } else {
                current += 1
            }
            instructions[pointer] = current
            pointer = nextPointer
        }
        
        return "\(steps)"
    }
}
