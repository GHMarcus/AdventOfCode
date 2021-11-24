//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/23

enum Day_23_2015: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2015
    
    static var a = 0
    static var b = 0

    static func solvePart1(input: [String]) -> String {
        var position = 0
        
        while true {
            let result = run(code: input[position], position: position, maxPosition: input.count)
            position = result.position
            if !result.isRunning {
                break
            }
        }
        
        return "\(b)"
    }

    static func solvePart2(input: [String]) -> String {
        a = 1
        b = 0
        var position = 0
        
        while true {
            let result = run(code: input[position], position: position, maxPosition: input.count)
            position = result.position
            if !result.isRunning {
                break
            }
        }
        
        return "\(b)"
    }
}

extension Day_23_2015 {
    static func run(code: String, position: Int, maxPosition: Int) -> (isRunning: Bool, position: Int) {
        let components = code.replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        var newPosition = position
        var isRunning = true
        switch components[0] {
        case "hlf":
            switch components[1] {
            case "a":
                a /= 2
            case "b":
                b /= 2
            default:
                fatalError("No valid register: \(components[1])")
            }
            newPosition += 1
        case "tpl":
            switch components[1] {
            case "a":
                a *= 3
            case "b":
                b *= 3
            default:
                fatalError("No valid register: \(components[1])")
            }
            newPosition += 1
        case "inc":
            switch components[1] {
            case "a":
                a += 1
            case "b":
                b += 1
            default:
                fatalError("No valid register: \(components[1])")
            }
            newPosition += 1
        case "jmp":
            guard let offset = Int(components[1]) else { fatalError("Can not form offset from: \(components[1])") }
            newPosition += offset
        case "jie":
            guard let offset = Int(components[2]) else { fatalError("Can not form offset from: \(components[2])") }
            let value: Int
            switch components[1] {
            case "a":
                value = a
            case "b":
                value = b
            default:
                fatalError("No valid register: \(components[1])")
            }
            if value % 2 == 0 {
                newPosition += offset
            } else {
                newPosition += 1
            }
        case "jio":
            guard let offset = Int(components[2]) else { fatalError("Can not form offset from: \(components[2])") }
            let value: Int
            switch components[1] {
            case "a":
                value = a
            case "b":
                value = b
            default:
                fatalError("No valid register: \(components[1])")
            }
            if value == 1 {
                newPosition += offset
            } else {
                newPosition += 1
            }
        default:
            fatalError("Wrong command: \(components[0])")
        }
        if newPosition >= maxPosition {
            isRunning = false
        }
        
        return (isRunning, newPosition)
    }
}
