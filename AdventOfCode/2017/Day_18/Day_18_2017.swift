//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/18

enum Day_18_2017: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2017
    
    enum Instruction {
        case set(String, String)
        case add(String, String)
        case mul(String, String)
        case mod(String, String)
        case jgz(String, String)
        case snd(String)
        case rcv(String)
        
        static func parse(_ string: String) -> Instruction {
            let cmp = string.components(separatedBy: " ")
            switch cmp[0] {
            case "set":
                return .set(cmp[1], cmp[2])
            case "add":
                return .add(cmp[1], cmp[2])
            case "mul":
                return .mul(cmp[1], cmp[2])
            case "mod":
                return .mod(cmp[1], cmp[2])
            case "jgz":
                return .jgz(cmp[1], cmp[2])
            case "snd":
                return .snd(cmp[1])
            case "rcv":
                return .rcv(cmp[1])
            default:
                fatalError()
            }
        }
    }
    
    class SingleComputer {
        var registers: [String: Int] = [:]
        var instructions: [Instruction]
        var pos: Int = 0
        
        init(instructions: [Instruction]) {
            self.instructions = instructions
        }
        
        private func set(value: Int, to register: String) {
            registers.updateValue(value, forKey: register)
        }
        
        private func getValue(from register: String) -> Int {
            if let value = registers[register] {
                return value
            } else {
                registers.updateValue(0, forKey: register)
                return 0
            }
        }
        
        func run() -> Int {
            var soundPlayed = 0
        runloop:
            while pos < instructions.count {
                let current = instructions[pos]
                switch current {
                case .set(let x, let y):
                    if let value = Int(y) {
                        set(value: value, to: x)
                    } else {
                        set(value: getValue(from: y), to: x)
                    }
                case .add(let x, let y):
                    let xValue = getValue(from: x)
                    if let value = Int(y) {
                        set(value: xValue + value, to: x)
                    } else {
                        set(value: xValue + getValue(from: y), to: x)
                    }
                case .mul(let x, let y):
                    let xValue = getValue(from: x)
                    if let value = Int(y) {
                        set(value: xValue * value, to: x)
                    } else {
                        set(value: xValue * getValue(from: y), to: x)
                    }
                case .mod(let x, let y):
                    let xValue = getValue(from: x)
                    if let value = Int(y) {
                        set(value: xValue % value, to: x)
                    } else {
                        set(value: xValue % getValue(from: y), to: x)
                    }
                case .jgz(let x, let y):
                    let xValue = Int(x) ?? getValue(from: x)
                    let yValue = Int(y) ?? getValue(from: y)
                    if xValue > 0 {
                        pos += yValue
                        continue
                    }
                case .snd(let x):
                    soundPlayed = getValue(from: x)
                case .rcv(let x):
                    if getValue(from: x) != 0 {
                        break runloop
                    }
                }
                pos += 1
            }
            return soundPlayed
        }
        
    }
    
    class DuetComputer {
        let id: Int
        var registers: [String: Int]
        var instructions: [Instruction]
        var pos: Int = 0
        var queue: [Int] = []
        var deadlock: Bool = false
        var counter = 0
        
        init(instructions: [Instruction], id: Int) {
            self.instructions = instructions
            self.id = id
            registers = ["p": id]
        }
        
        private func set(value: Int, to register: String) {
            registers.updateValue(value, forKey: register)
        }
        
        private func getValue(from register: String) -> Int {
            if let value = registers[register] {
                return value
            } else {
                registers.updateValue(0, forKey: register)
                return 0
            }
        }
        
        func run() {
            guard pos < instructions.count else {
                deadlock = true
                return
            }
            
            let current = instructions[pos]
            switch current {
            case .set(let x, let y):
                if let value = Int(y) {
                    set(value: value, to: x)
                } else {
                    set(value: getValue(from: y), to: x)
                }
            case .add(let x, let y):
                let xValue = getValue(from: x)
                if let value = Int(y) {
                    set(value: xValue + value, to: x)
                } else {
                    set(value: xValue + getValue(from: y), to: x)
                }
            case .mul(let x, let y):
                let xValue = getValue(from: x)
                if let value = Int(y) {
                    set(value: xValue * value, to: x)
                } else {
                    set(value: xValue * getValue(from: y), to: x)
                }
            case .mod(let x, let y):
                let xValue = getValue(from: x)
                if let value = Int(y) {
                    set(value: xValue % value, to: x)
                } else {
                    set(value: xValue % getValue(from: y), to: x)
                }
            case .jgz(let x, let y):
                let xValue = Int(x) ??  getValue(from: x)
                let yValue = Int(y) ?? getValue(from: y)
                if xValue > 0 {
                    pos += yValue - 1
                }
            case .snd(let x):
                let value = getValue(from: x)
                computers[1-id].queue.append(value)
                counter += 1
            case .rcv(let x):
                if queue.isEmpty {
                    pos -= 1
                    deadlock = true
                } else {
                    set(value: queue.removeFirst(), to: x)
                    deadlock = false
                }
            }
            
            pos += 1
        }
    }
    
    static func convert(input: [String]) -> [Instruction] {
        return input.map{ Instruction.parse($0) }
    }

    static func solvePart1(input: [Instruction]) -> String {
        let singleComputer = SingleComputer(instructions: input)
        let recoveredFrequency = singleComputer.run()
        return "\(recoveredFrequency)"
    }
    
    static var computers: [DuetComputer] = []

    static func solvePart2(input: [Instruction]) -> String {
        computers = [DuetComputer(instructions: input, id: 0), DuetComputer(instructions: input, id: 1)]
        
        while !(computers[0].deadlock && computers[1].deadlock) {
            _ = computers.map { $0.run() }
        }
        
        return "\(computers[1].counter)"
    }
}
