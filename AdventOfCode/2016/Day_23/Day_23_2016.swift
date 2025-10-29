//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/23

enum Day_23_2016: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2016
    
    enum Command {
        case cpy(String, String, Bool)
        case inc(String, Bool)
        case dec(String, Bool)
        case jnz(String, String, Bool)
        case tgl(String, Bool)
        case mul(String, String, String)
        
        static func parse(_ string: String) -> Command {
            let cmp = string.components(separatedBy: " ")
            switch cmp[0] {
            case "cpy":
                return .cpy(cmp[1], cmp[2], false)
            case "inc":
                return .inc(cmp[1], false)
            case "dec":
                return .dec(cmp[1], false)
            case "jnz":
                return .jnz(cmp[1], cmp[2], false)
            case "tgl":
                return .tgl(cmp[1], false)
            default:
                fatalError()
            }
        }
    }
    
    class Computer {
        var a, b ,c, d: Int
        var commands: [Command]
        var pos: Int
        var isPart2: Bool
        
        init(program: [Command], isPart2: Bool) {
            a = isPart2 ? 12 : 7
            b = 0
            c = 0
            d = 0
            pos = 0
            commands = program
            self.isPart2 = isPart2
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
            var commands = commands
            while pos < commands.count {
                let current = commands[pos]
                switch current {
                case .cpy(let x, let y, let s):
                    if s { break }
                    if let value = Int(x) {
                        set(value: value, to: y)
                    } else {
                        set(value: getValue(from: x), to: y)
                    }
                case .inc(let x, let s):
                    if s { break }
                    let value = getValue(from: x)
                    set(value: value + 1, to: x)
                case .dec(let x, let s):
                    if s { break }
                    let value = getValue(from: x)
                    set(value: value - 1, to: x)
                case .jnz(let x, let y, let s):
                    if s { break }
                    let value = Int(x) ?? getValue(from: x)
                    if value != 0 {
                        pos += Int(y) ?? getValue(from: y)
                        continue
                    }
                case .tgl(let x, _):
                    let delta = getValue(from: x)
                    
                    let newPos = pos + delta
                    if newPos >= commands.count {
                        break
                    }
                    let newCommand: Command
                    switch commands[newPos] {
                    case .cpy(let x, let y, _):
                        let skip = Int(x) == nil
                        newCommand = .jnz(x, y, skip)
                    case .inc(let x, _):
                        let skip = Int(x) != nil
                        newCommand = .dec(x, skip)
                    case .dec(let x, _):
                        let skip = Int(x) != nil
                        newCommand = .inc(x, skip)
                    case .jnz(let x, let y, _):
                        let skip = Int(y) != nil
                        newCommand = .cpy(x, y, skip)
                    case .tgl(let x, _):
                        let skip = Int(x) != nil
                        newCommand = .inc(x, skip)
                    case .mul:
                        fatalError()
                    }
                    commands[newPos] = newCommand
                case .mul(let x, let y, let z):
                    set(value: getValue(from: x) * getValue(from: y), to: z)
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
        // Note found out that program lines at pos 4-9 will be repeated several times (exact b*d)
        // So to speed up the program we replace this lines and add a multiply (mul) to the commands
        // Note: Help from this post -> https://www.reddit.com/r/adventofcode/comments/5jvbzt/comment/dbjbocc/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        let newCommands: [Command] = [
            .mul("b", "d", "a"),
            .cpy("0", "c", true),
            .cpy("0", "c", true),
            .cpy("0", "c", true),
            .cpy("0", "c", true),
            .cpy("0", "d", true),
        ]
        
        let program = Array(input[0..<4]) + newCommands + Array(input[10...])
        
        let computer = Computer(program: program, isPart2: true)
        let result = computer.run()
        return "\(result)"
    }
}
