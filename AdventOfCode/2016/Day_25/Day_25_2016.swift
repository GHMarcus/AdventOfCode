//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/25

enum Day_25_2016: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2016

    enum Command {
        case cpy(String, String)
        case inc(String)
        case dec(String)
        case jnz(String, String)
        case out(String)
        
        static func parse(_ string: String) -> Command {
            let cmp = string.components(separatedBy: " ")
            switch cmp[0] {
            case "cpy":
                return .cpy(cmp[1], cmp[2])
            case "inc":
                return .inc(cmp[1])
            case "dec":
                return .dec(cmp[1])
            case "jnz":
                return .jnz(cmp[1], cmp[2])
            case "out":
                return .out(cmp[1])
            default:
                fatalError()
            }
        }
    }
    
    class Computer {
        var a, b ,c, d: Int
        var commands: [Command]
        var pos: Int
        
        init(program: [Command], a: Int) {
            self.a = a
            b = 0
            c = 0
            d = 0
            pos = 0
            commands = program
        }
        
        private func set(value: Int, to register: String) {
            switch register {
            case "a": a = value
            case "b": b = value
            case "c": c = value
            case "d": d = value
            default: fatalError()
            }
        }
        
        private func getValue(from register: String) -> Int {
            switch register {
            case "a": return a
            case "b": return b
            case "c": return c
            case "d": return d
            default: fatalError()
            }
        }
        
        func run() -> String {
            var count = 0
            var output: [String] = []
            while pos < commands.count, count < 10 {
                let current = commands[pos]
                switch current {
                case .cpy(let x, let y):
                    if let value = Int(x) {
                        set(value: value, to: y)
                    } else {
                        set(value: getValue(from: x), to: y)
                    }
                case .inc(let x):
                    let value = getValue(from: x)
                    set(value: value + 1, to: x)
                case .dec(let x):
                    let value = getValue(from: x)
                    set(value: value - 1, to: x)
                case .jnz(let x, let y):
                    let value = Int(x) ?? getValue(from: x)
                    if value != 0 {
                        pos += Int(y)!
                        continue
                    }
                case .out(let x):
                    output.append("\(getValue(from: x))")
                    count += 1
                }
                pos += 1
            }
            return output.joined()
        }
        
    }
    
    static func convert(input: [String]) -> [Command] {
        return input.map{ Command.parse($0) }
    }

    static func solvePart1(input: [Command]) -> String {
        let sample = Array(repeating: "01", count: 5).joined()
        
        var number = 0
        while true {
            let computer = Computer(program: input, a: number)
            let result = computer.run()
            if result == sample {
                break
            } else {
                number += 1
            }
        }
        return "\(number)"
    }

    static func solvePart2(input: [Command]) -> String {
        "Nothing to do here"
    }
}
