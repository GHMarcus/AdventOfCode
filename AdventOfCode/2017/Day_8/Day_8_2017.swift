//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/8

enum Day_8_2017: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2017
    
    enum Operation: String {
        case inc = "inc"
        case dec = "dec"
    }
    
    enum Comparator: String {
        case equal = "=="
        case notEqual = "!="
        case lessThan = "<"
        case lessThanOrEqual = "<="
        case greaterThan = ">"
        case greaterThanOrEqual = ">="
        
        func compare(_ a: Int, _ b: Int) -> Bool {
            switch self {
            case .equal: return a == b
            case .notEqual: return a != b
            case .lessThan: return a < b
            case .lessThanOrEqual: return a <= b
            case .greaterThan: return a > b
            case .greaterThanOrEqual: return a >= b
            }
        }
    }
    
    struct Condition {
        let register: String
        let comparator: Comparator
        let value: Int
        
        func isTrue(_ registers: inout [String: Int]) -> Bool {
            if let registerValue = registers[register] {
                return comparator.compare(registerValue, value)
            } else {
                registers[register] = 0
                return comparator.compare(0, value)
            }
        }
    }
    
    struct Instruction {
        let register: String
        let operation: Operation
        let value: Int
        let condition: Condition
        
        init(_ line: String) {
            let cmp = line.components(separatedBy: " ")
            register = cmp[0]
            operation = .init(rawValue: cmp[1])!
            value = Int(cmp[2])!
            condition = .init(
                register: cmp[4],
                comparator: .init(rawValue: cmp[5])!,
                value: Int(cmp[6])!
            )
        }
        
        func execute(_ registers: inout [String: Int]) {
            if condition.isTrue(&registers) {
                switch operation {
                case .inc:
                    registers[register, default: 0] += value
                case .dec:
                    registers[register, default: 0] -= value
                }
            }
        }
    }
    
    static func convert(input: [String]) -> [Instruction] {
        input.map { Instruction($0) }
    }

    static func solvePart1(input: [Instruction]) -> String {
        var registers: [String: Int] = [:]
        
        for instruction in input {
            instruction.execute(&registers)
        }
        
        return "\(registers.values.max()!)"
    }

    static func solvePart2(input: [Instruction]) -> String {
        var registers: [String: Int] = [:]
        var highestValue: Int = 0
        
        for instruction in input {
            instruction.execute(&registers)
            if let currentMax = registers.values.max(), currentMax > highestValue {
                highestValue = currentMax
            }
        }
        
        return "\(highestValue)"
    }
}
