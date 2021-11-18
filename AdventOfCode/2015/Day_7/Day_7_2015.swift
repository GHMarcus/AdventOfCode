//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/7

enum Day_7_2015: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2015
    static var override: UInt16 = 0

    static func solvePart1(input: [String]) -> String {
        var wires: [String: UInt16] = [:]
        
        var commands = (input.map { $0.components(separatedBy: " ") }).sorted {
            $0.count < $1.count
        }
        
        while commands.count > 0 {
            let command = commands.removeFirst()
            if let result = execute(command, on: wires) {
                wires.updateValue(result.value, forKey: result.wire)
            } else {
                commands.append(command)
            }
        }
        guard let value = wires["a"] else { return "error" }
        override = value
        return "\(value)"
    }

    static func solvePart2(input: [String]) -> String {
        var wires: [String: UInt16] = [:]
        
        var commands = (input.map { $0.components(separatedBy: " ") }).sorted {
            $0.count < $1.count
        }
        
        
        for i in 0..<commands.count {
            guard commands[i].last == "b" else { continue }
            commands[i][0] = "\(override)"
            break
        }
        
        while commands.count > 0 {
            let command = commands.removeFirst()
            if let result = execute(command, on: wires) {
                wires.updateValue(result.value, forKey: result.wire)
            } else {
                commands.append(command)
            }
        }
        guard let value = wires["a"] else { return "error" }
        return "\(value)"
    }
}

extension Day_7_2015 {
    static func execute(_ command: [String], on wires: [String: UInt16]) -> (wire: String, value: UInt16)? {
        var wire = ""
        var value: UInt16 = 0
        
        // 123 -> x
        // a -> x
        if command.count == 3 {
            wire = String(command.last ?? "")
            if let value = UInt16(command[0]) {
                return (wire, value)
            } else if let signal = wires[command[0]] {
                return (wire, signal)
            } else {
                return nil
            }
        }
        
        // NOT x -> h
        if command.count == 4, command[0] == "NOT" {
            if let signal = wires[command[1]] {
                wire = String(command.last ?? "")
                return (wire, ~signal)
            } else {
                return nil
                
            }
        }
        
        if command.count == 5 {
            wire = String(command.last ?? "")
            let operant = String(command[1])
            
            switch operant {
            case "AND":
                guard let signal_1 = wires[command[0]] ?? UInt16(command[0]),
                      let signal_2 = wires[command[2]] ?? UInt16(command[2])
                else {
                    return nil
                }
                
                value = signal_1 & signal_2
                return (wire, value)

            case "OR":
                guard let signal_1 = wires[command[0]] ?? UInt16(command[0]),
                      let signal_2 = wires[command[2]] ?? UInt16(command[2])
                else {
                    return nil
                }
                
                value = signal_1 | signal_2
                return (wire, value)
                
            case "LSHIFT":
                guard let signal_1 = wires[command[0]] ?? UInt16(command[0]),
                      let signal_2 = Int(command[2])
                else {
                    return nil
                }
                
                value = signal_1 << signal_2
                return (wire, value)
                
            case "RSHIFT":
                guard let signal_1 = wires[command[0]] ?? UInt16(command[0]),
                      let signal_2 = Int(command[2])
                else {
                    return nil
                }
                
                value = signal_1 >> signal_2
                return (wire, value)
                
            default:
                fatalError("No known operant: \(operant)")
            }
            
            
        }

        fatalError("Wrong command execution: \(command)")
    }
}
