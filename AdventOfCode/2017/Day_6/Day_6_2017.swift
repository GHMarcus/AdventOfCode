//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/6

enum Day_6_2017: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2017
    
    static var duplicatedState: [Int] = []

    static func solvePart1(input: [String]) -> String {
        var registers = input
            .first!
            // filters a random number of spaces and replace it with an `-`
            .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
            .components(separatedBy: "-")
            .map { Int($0)! }
        
        var seenStates: Set<[Int]> = []
        
        var cycles = 0
        while true {
            var newRegisters = registers
            let maxIndex = newRegisters.firstIndex(of: newRegisters.max()!)!
            let registersToMove = newRegisters[maxIndex]
            newRegisters[maxIndex] = 0
            var index = maxIndex + 1
            for _ in 1...registersToMove {
                if index >= newRegisters.count {
                    index = 0
                }
                newRegisters[index] += 1
                index += 1
            }
            cycles += 1
            if !seenStates.insert(newRegisters).inserted {
                Day_6_2017.duplicatedState = newRegisters
                break
            } else {
                registers = newRegisters
            }
        }
        
        return "\(cycles)"
    }

    static func solvePart2(input: [String]) -> String {
        var registers = Day_6_2017.duplicatedState
        
        var cycles = 0
        while true {
            var newRegisters = registers
            let maxIndex = newRegisters.firstIndex(of: newRegisters.max()!)!
            let registersToMove = newRegisters[maxIndex]
            newRegisters[maxIndex] = 0
            var index = maxIndex + 1
            for _ in 1...registersToMove {
                if index >= newRegisters.count {
                    index = 0
                }
                newRegisters[index] += 1
                index += 1
            }
            cycles += 1
            if newRegisters == Day_6_2017.duplicatedState {
                break
            } else {
                registers = newRegisters
            }
        }
        
        return "\(cycles)"
    }
}
