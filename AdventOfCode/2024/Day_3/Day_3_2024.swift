//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/3

import Foundation

enum Day_3_2024: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2024
    
    enum Statement {
        case mul, `do`, dont
    }

    static func convert(input: [String]) -> String {
        input.joined()
    }

    static func solvePart1(input: String) -> String {
        let muls = input.matches(for: "mul\\([0-9]{1,3},[0-9]{1,3}\\)")
        let sum = muls.reduce(0){ $0 + getValue(for: $1) }
        return "\(sum)"
    }

    static func solvePart2(input: String) -> String {
        let muls = input.ranges(for: "mul\\([0-9]{1,3},[0-9]{1,3}\\)")
        let dos = input.ranges(for: "do\\(\\)")
        let donts = input.ranges(for: "don't\\(\\)")
        
        var statements: [(Statement, Range<String.Index>)] = []
        muls.forEach { statements.append((.mul, $0)) }
        dos.forEach { statements.append((.do, $0)) }
        donts.forEach { statements.append((.dont, $0)) }
        statements.sort { $0.1.lowerBound < $1.1.lowerBound }
        
        var enabledStatements: [String] = []
        var isEnabled = true
        
        for statement in statements {
            switch statement.0 {
            case .mul:
                if isEnabled {
                    let range = statement.1
                    enabledStatements.append(String(input[range.lowerBound..<range.upperBound]))
                }
            case .do:
                isEnabled = true
            case .dont:
                isEnabled = false
            }
        }
        
        let sum = enabledStatements.reduce(0){ $0 + getValue(for: $1) }
        return "\(sum)"
    }
    
    static func getValue(for text: String) -> Int {
        let numbersText = text.dropFirst(4).dropLast()
        let numbers = numbersText.split(separator: ",").map{Int($0)!}
        return numbers.reduce(1, *)
    }
}
