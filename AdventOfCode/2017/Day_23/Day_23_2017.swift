//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/23

enum Day_23_2017: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2017
    
    enum Instruction {
        case set(String, String)
        case sub(String, String)
        case mul(String, String)
        case jnz(String, String)
        
        static func parse(_ string: String) -> Instruction {
            let cmp = string.components(separatedBy: " ")
            switch cmp[0] {
            case "set":
                return .set(cmp[1], cmp[2])
            case "sub":
                return .sub(cmp[1], cmp[2])
            case "mul":
                return .mul(cmp[1], cmp[2])
            case "jnz":
                return .jnz(cmp[1], cmp[2])
            default:
                fatalError()
            }
        }
    }
    
    class Computer {
        var registers: [String: Int] = [:]
        var instructions: [Instruction]
        var pos: Int = 0
        
        init(instructions: [Instruction]) {
            registers = [
                "a": 0,
                "b": 0,
                "c": 0,
                "d": 0,
                "e": 0,
                "f": 0,
                "g": 0,
                "h": 0
            ]
            self.instructions = instructions
        }
        
        private func set(value: Int, to register: String) {
            registers.updateValue(value, forKey: register)
        }
        
        private func getValue(from register: String) -> Int {
            registers[register]!
        }
        
        func run() -> Int {
            var mulInvoked = 0
            while pos < instructions.count {
                let current = instructions[pos]
//                print(current, getValue(from: "g"))
                switch current {
                case .set(let x, let y):
                    if let value = Int(y) {
                        set(value: value, to: x)
                    } else {
                        set(value: getValue(from: y), to: x)
                    }
                case .sub(let x, let y):
                    let xValue = getValue(from: x)
                    if let value = Int(y) {
                        set(value: xValue - value, to: x)
                    } else {
                        set(value: xValue - getValue(from: y), to: x)
                    }
                case .mul(let x, let y):
                    mulInvoked += 1
                    let xValue = getValue(from: x)
                    if let value = Int(y) {
                        set(value: xValue * value, to: x)
                    } else {
                        set(value: xValue * getValue(from: y), to: x)
                    }
                case .jnz(let x, let y):
                    let xValue = Int(x) ?? getValue(from: x)
                    let yValue = Int(y) ?? getValue(from: y)
                    if xValue != 0 {
                        pos += yValue
                        continue
                    }
                }
                pos += 1
            }
            return mulInvoked
        }
    }
    
    static func convert(input: [String]) -> [Instruction] {
        return input.map{ Instruction.parse($0) }
    }


    static func solvePart1(input: [Instruction]) -> String {
        let computer = Computer(instructions: input)
        let mulInvoked = computer.run()
        return "\(mulInvoked)"
    }

    // With the help of: https://www.reddit.com/r/adventofcode/comments/7lms6p/comment/drnhd59/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    static func solvePart2(input: [Instruction]) -> String {
        let a = 1;
        var b = 0;
        var c = 0;
        var d = 0;
//        var e = 0;
        var f = 0;
        var g = 0;
        var h = 0;
        b = 99;
        c = b;
        
        if a != 0 {
            b *= 100;
            b += 100000;
            c = b;
            c += 17000;
        }
        var first = true
        while g != 0 || first {
            first = false
            
            f = 1
            d = 2
//            e = 2
            
            while d < b {
                if b % d == 0 {
                    f = 0
                    break
                }
                d += 1
            }
            
            if f == 0 {
                h += 1
            }
            g = b - c
            b += 17
        }
        
        return "\(h)"
    }
}
