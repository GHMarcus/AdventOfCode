//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/6

enum Day_6_2025: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = (numbers: [[String]], operations: [Operation])

    enum Operation: Character {
        case add = "+"
        case multiply = "*"
    }

    static func convert(input: [String]) -> ConvertedInput {
        var lines = input
        var numbers: [[String]] = Array(repeating: [], count: input[0].count)
        var operations: [Operation] = []

        let operatorLine = lines.removeLast()
        var prevIndex: Int? = nil

        for (i, c) in operatorLine.enumerated() {
            if c != " " {
                operations.append(Operation(rawValue: c)!)
                if let prevIndex = prevIndex {
                    for (lineIndex, line) in lines.enumerated() {
                        numbers[lineIndex].append(String(Array(line)[prevIndex..<i-1]))
                    }
                }
                prevIndex = i
            }
        }

        if let prevIndex = prevIndex {
            for (lineIndex, line) in lines.enumerated() {
                numbers[lineIndex].append(String(Array(line)[prevIndex...]))
            }
        }

        numbers = numbers.filter {
            !$0.isEmpty
        }

        return (numbers, operations)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let numbers = input.numbers.map { $0.map { Int($0.trimmingCharacters(in: .whitespaces))! }}

        var total = 0
        for i in 0..<numbers[0].count {
            let op = input.operations[i]
            let nums = numbers.map { $0[i] }

            switch op {
            case .add:
                total += nums.reduce(0, +)
            case .multiply:
                total += nums.reduce(1, *)
            }
        }
        return "\(total)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        let switchedNumbers = input.numbers.map { $0.reversed().map { Array($0.reversed()) }}
        let switchedOperations = Array(input.operations.reversed())

        var completeNumbers: [[Int]] = []

        for problemIndex in 0..<switchedNumbers[0].count {
            let problemNumbers = switchedNumbers.map { $0[problemIndex] }
            var currentNumbers: [Int] = []
            for numberIndex in 0..<problemNumbers[0].count {
                let number = problemNumbers.map { $0[numberIndex] }
                currentNumbers.append(Int(String(number).trimmingCharacters(in: .whitespaces))!)
            }
            completeNumbers.append(currentNumbers)
        }

        var total = 0
        for (i, nums) in completeNumbers.enumerated() {
            let op = switchedOperations[i]
            switch op {
            case .add:
                total += nums.reduce(0, +)
            case .multiply:
                total += nums.reduce(1, *)
            }
        }

        return "\(total)"
    }
}
