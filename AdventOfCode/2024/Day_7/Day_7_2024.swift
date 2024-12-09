//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/7

// Took 69.99163794517517 seconds

enum Day_7_2024: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2024

    enum Operator: String {
        case add = "+"
        case mul = "*"
        case concat = "||"
    }
    
    struct Equation {
        let result: Int
        let operands: [Int]
        
        var possibleOperators: [[Operator]] {
            var combinations: [[Operator]] = []
            let count = 1 << (operands.count-1)
            for i in 0..<count {
                var binary = String(i, radix: 2)
                
                if binary.count < operands.count-1 {
                    binary = String(repeating: "0", count: operands.count-1-binary.count) + binary
                }
                
                combinations.append(Array(binary).map {
                    if $0 == "1" { Operator.add }
                    else { Operator.mul }
                })
            }
            return combinations
        }
        
        var possibleOperators2: [[Operator]] {
            var combinations: [[Operator]] = []
            let count = Array(repeating: 3, count: operands.count-1).reduce(into: 1) { partialResult, next in
                partialResult *= next
            }
            for i in 0..<count {
                var trinary = String(i, radix: 3)
                
                if trinary.count < operands.count-1 {
                    trinary = String(repeating: "0", count: operands.count-1-trinary.count) + trinary
                }
                combinations.append(Array(trinary).map {
                    if $0 == "0" { Operator.add }
                    else if $0 == "1" { Operator.mul }
                    else { Operator.concat }
                })
            }
            return combinations
        }
        
        func calculate(with operators: [Operator]) -> Int {
            var result = operands[0]
            for i in 0..<operators.count {
                switch operators[i] {
                case .add: result += operands[i+1]
                case .mul: result *= operands[i+1]
                case .concat: continue
                }
            }
            return result
        }
        
        func calculate2(with operators: [Operator]) -> Int {
            var result = operands[0]
            for i in 0..<operators.count {
                switch operators[i] {
                case .add: result += operands[i+1]
                case .mul: result *= operands[i+1]
                case .concat: result = Int(String(result)+String(operands[i+1]))!
                }
            }
            return result
        }
    }
    
    static func convert(input: [String]) -> [Equation] {
        var equations: [Equation] = []
        for line in input {
            let cmp = line.components(separatedBy: ": ")
            equations.append(Equation(
                result: Int(cmp[0])!,
                operands: cmp[1].components(separatedBy: " ").map{ Int($0)! }
            ))
        }
        return equations
    }

    static func solvePart1(input: [Equation]) -> String {
        var sum = 0
        
        for equation in input {
            for operators in equation.possibleOperators {
                if equation.calculate(with: operators) == equation.result {
                    sum += equation.result
                    break
                }
            }
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: [Equation]) -> String {
        var sum = 0
        
        for equation in input {
            for operators in equation.possibleOperators2 {
                if equation.calculate2(with: operators) == equation.result {
                    sum += equation.result
                    break
                }
            }
        }
        
        return "\(sum)"
    }
}
