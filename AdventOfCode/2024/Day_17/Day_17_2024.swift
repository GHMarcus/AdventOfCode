//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/17

import Foundation

enum Day_17_2024: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = BitComputer
    
    class BitComputer {
        enum Register {
            case A,B,C
        }
        
        var registers: [Int]
        var program: [Int]
        var output: [Int] = []
        
        var A: Int { registers[0] }
        var B: Int { registers[1] }
        var C: Int { registers[2] }
        
        init(registers: [Int], program: [Int]) {
            self.registers = registers
            self.program = program
        }
        
        private func set(_ register: Register, value: Int) {
            switch register {
            case .A: registers[0] = value
            case .B: registers[1] = value
            case .C: registers[2] = value
            }
        }
        
        private func getComboValue(at index: Int) -> Int {
            switch program[index] {
            case 0, 1, 2, 3:
                return program[index]
            case 4:
                return A
            case 5:
                return B
            case 6:
                return C
            case 7:
                assertionFailure("Program contains invalid operands")
                return 0
            default:
                assertionFailure("Unknown operand \(program[index])")
                return 0
            }
        }
        
        func run() -> [Int] {
            output = []
            var index = 0
            while index < program.count {
                switch program[index] {
                case 0: // adv
                    let value = getComboValue(at: index + 1)
                    set(.A, value: A / 2.pow(value))
                case 1: // bxl
                    let value = program[index + 1]
                    set(.B, value: B ^ value)
                case 2: // bst
                    let value = getComboValue(at: index + 1)
                    set(.B, value: value % 8)
                case 3: // jnz
                    if A == 0 {
                        index += 2
                        continue
                    } else {
                        let value = program[index + 1]
                        index = value
                        continue
                    }
                case 4: // bxc
                    set(.B, value: B ^ C)
                case 5: // out
                    let value = getComboValue(at: index + 1)
                    output.append(value % 8)
                case 6: // bdv
                    let value = getComboValue(at: index + 1)
                    set(.B, value: A / 2.pow(value))
                case 7: // cdv
                    let value = getComboValue(at: index + 1)
                    set(.C, value: A / 2.pow(value))
                default:
                    assertionFailure("Unknown opcode \(program[index])")
                    return []
                }
                index += 2
            }
            return output
        }
        
        /// Find the value for register a to get the program as output.
        /// Note: Important to know. Due the fact, that the program prints values with `% 8` we can build up our searched number step by step.
        /// To keep it simple we look at the binary representation of the numbers.
        /// What we have to do is:
        /// - Start at the end of program (the last output are the lowest bits)
        /// - Take the nth last output values (For the first there is only the [last] from the program, for the second iteration there is [secondLast, last] and so on
        /// - Now we have to look which added value from 0...7 (binary: 000 -> 111) will give us the right (shortened) output.
        /// - `Attention`: For this there can be multiple solutions and we have to keep an eye on all of them
        /// - To check an new value we add the binary string of that value to every saved binary string from the output before
        /// - And we do this until we get a bunch of binary strings that give us the program as output
        /// Last thing to do is, find the lowest number of the given binaries
        /// ```
        /// Program: 2,4,1,1,7,5,4,4,1,4,0,3,5,5,3,0
        ///
        /// One Value   | binary string                             | shortened output
        /// 5           | 101                                       | [0]
        /// 46          | 101 110                                   | [3, 0]
        /// 368         | 101 110 000                               | [5, 3, 0]
        /// 2944        | 101 110 000 000                           | [5, 5, 3, 0]
        /// 23.558      | 101 110 000 000 110                       | [3, 5, 5, 3, 0]
        /// 188.468     | 101 110 000 000 110 100                   | [0, 3, 5, 5, 3, 0]
        /// 1.507.748   | 101 110 000 000 110 100 100               | [4, 0, 3, 5, 5, 3, 0]
        /// 12.061.990  | 101 110 000 000 110 100 100 110           | [1, 4, 0, 3, 5, 5, 3, 0]
        /// 96.496.069  | 101 110 000 000 110 100 111 000 101       | [4, 1, 4, 0, 3, 5, 5, 3, 0]
        /// 771.968.555 | 101 110 000 000 110 100 111 000 101 011   | [4, 4, 1, 4, 0, 3, 5, 5, 3, 0]
        /// ```
        func runToFindItself() -> Int {
            var expected: [Int] = []
            var binaries: [String] = [""]
            
            for p in program.reversed() {
                expected.insert(p, at: 0)
                var newBinaries: [String] = []
                for a in 0...7 {
                    for binary in binaries {
                        set(.A, value: Int(binary + binaryStr(for: a), radix: 2)!)
                        set(.B, value: 0)
                        set(.C, value: 0)
                        let output = run()
                        if output == expected {
                            newBinaries.append(binary + binaryStr(for: a))
                        }
                    }
                }
                binaries = newBinaries
            }
            
            return binaries.map { Int($0, radix: 2)! }.min()!
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        var registers: [Int] = []
        var program: [Int] = []
        var isRegister = true
        for line in input {
            if line.isEmpty {
                isRegister = false
                continue
            }
            if isRegister {
                registers.append(Int(line.components(separatedBy: ": ")[1])!)
            } else {
                program.append(contentsOf: line.components(separatedBy: ": ")[1].components(separatedBy: ",").map({Int($0)!}))
            }
        }
        
        return BitComputer(registers: registers, program: program)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        return input.run().map { String($0) }.joined(separator: ",")
    }

    static func solvePart2(input: ConvertedInput) -> String {
        return "\(input.runToFindItself())"
    }
    
    static func binaryStr(for value: Int) -> String {
        var binaryStr = String(value, radix: 2)
        let rest = binaryStr.count % 3
        if rest != 0 {
            let padding = String(repeating: "0", count: 3 - rest)
            binaryStr = padding + binaryStr
        }
        
        return binaryStr.split(every: 3).joined(separator: " ")
    }
}
