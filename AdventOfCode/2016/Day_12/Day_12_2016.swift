//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/12

enum Day_12_2016: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2016
    
    enum Command {
        case cpy(String, String)
        case inc(String)
        case dec(String)
        case jnz(String, String)
        
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
            default:
                fatalError()
            }
        }
    }
    
    class Computer {
        var a, b ,c, d: Int
        var commands: [Command]
        var pos: Int
        
        init(program: [Command], isPart2: Bool) {
            a = 0
            b = 0
            c = isPart2 ? 1 : 0
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
        
        func run() -> Int {
            while pos < commands.count {
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
                }
                pos += 1
            }
            return a
        }
        
    }
    
    static func convert(input: [String]) -> [Command] {
        return input.map{ Command.parse($0) }
    }

    static func solvePart1(input: [Command]) -> String {
        let computer = Computer(program: input, isPart2: false)
        let result = computer.run()
        return "\(result)"
    }

    static func solvePart2(input: [Command]) -> String {
        let computer = Computer(program: input, isPart2: true)
        let result = computer.run()
        return "\(result)"
    }
}
