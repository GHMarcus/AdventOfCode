//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/1

enum Day_1_2023: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2023

    static let numbers = zip(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"],  1...9).reduce(into: [:]) { $0[$1.0] = $1.1 }
    
    static func solvePart1(input: [String]) -> String {
        let lines = input
            .map { line in
                Array(line).compactMap {
                    Int(String($0))
                }
            }
        
        let sum = lines.reduce(into: 0) { partialResult, line in
            partialResult += (line.first ?? 0) * 10 + (line.last ?? 0)
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        
        let lines = input.map { line in
            let wordNumbers = findWordNumbers(in: line).sorted {
                $0.key < $1.key
            }
            if wordNumbers.isEmpty {
                return line
            } else {
                var newLine = line
                let firstRange = line.range(of: wordNumbers.first!.value)!
                if wordNumbers.count > 1 {
                    let lastRange = line.range(of: wordNumbers.last!.value, options: .backwards)!
                    newLine.replaceSubrange(lastRange, with: " \(numbers[wordNumbers.last!.value] ?? 0) ")
                }
                newLine.replaceSubrange(firstRange, with: " \(numbers[wordNumbers.first!.value] ?? 0) ")
                return newLine
            }
        }.map { line in
            Array(line).compactMap {
                Int(String($0))
            }
        }
        
        let sum = lines.reduce(into: 0) { partialResult, line in
            partialResult += (line.first ?? 0) * 10 + (line.last ?? 0)
        }
        
        return "\(sum)"
    }
    
    static func findWordNumbers(in line: String) -> [String.Index: String] {
        var indices: [String.Index: String] = [:]
        for number in numbers {
            let founds = line.indices(of: number.key)
            for found in founds {
                indices[found] = number.key
            }
        }
        
        return indices
    }
}
