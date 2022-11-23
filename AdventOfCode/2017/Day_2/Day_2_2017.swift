//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/2

enum Day_2_2017: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2017

    static func solvePart1(input: [String]) -> String {
        var sum = 0
        
        for line in input {
            let numbers = line
                // filters a random number of spaces and replace it with an `-`
                .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
                .components(separatedBy: "-")
                .map { Int($0)! }
                .sorted()
            sum += numbers.last! - numbers.first!
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        var sum = 0
        
        for line in input {
            let numbers = line
                // filters a random number of spaces and replace it with an `-`
                .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
                .components(separatedBy: "-")
                .map { Int($0)! }
            
            for number in numbers {
                for innerNumber in numbers {
                    if number == innerNumber {
                        continue
                    } else if number % innerNumber == 0 {
                        sum += number / innerNumber
                        break
                    }
                }
            }
        }
        
        return "\(sum)"
    }
}
