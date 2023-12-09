//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/9

enum Day_9_2023: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2023
    
    static func convert(input: [String]) -> [[Int]] {
        input.map {
            $0.components(separatedBy: " ")
                .map {
                    Int($0)!
                }
        }
    }

    static func solvePart1(input: [[Int]]) -> String {
        var predictedValues: [Int] = []
        for history in input {
            let differences = calculateDifferences(for: history).compactMap { $0.last }
            
            let predictedValue = differences.reduce(0) { $0 + $1 }
            predictedValues.append(predictedValue)
        }
        
        let sum = predictedValues.reduce(0) { $0 + $1 }
        return "\(sum)"
    }

    static func solvePart2(input: [[Int]]) -> String {
        var predictedValues: [Int] = []
        for history in input {
            let differences = calculateDifferences(for: history).compactMap { $0.first }
            
            let predictedValue = differences.reduce(0) { $1 - $0 }
            predictedValues.append(predictedValue)
        }
        
        let sum = predictedValues.reduce(0) { $0 + $1 }
        return "\(sum)"
    }
    
    static func calculateDifferences(for history: [Int]) -> [[Int]] {
        var differences: [[Int]] = [history]
        var current = history
        while true {
            var new: [Int] = []
            for i in 0..<current.count-1 {
                new.append(current[i+1] - current[i])
            }
            if new.allSatisfy({ $0 == 0 }) {
                break
            }
            differences.append(new)
            current = new
        }
        
        return differences.reversed()
        
    }
}
