//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/8

enum Day_8_2020: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        var assembler = Assembler(code: input)
        return "\(assembler.run().acc)"
    }

    static func solvePart2(input: [String]) -> String {
        var assembler = Assembler(code: input)
        var changedInput = input
        for i in 0..<changedInput.count {
            if changedInput[i].contains("jmp") {
                changedInput[i] = changedInput[i].replacingOccurrences(of: "jmp", with: "nop")
                assembler = Assembler(code: changedInput)
                let result = assembler.run()
                if result.terminated {
                    changedInput[i] = changedInput[i].replacingOccurrences(of: "nop", with: "jmp")
                } else {
                    return "\(result.acc)"
                }
            }
            if changedInput[i].contains("nop") {
                changedInput[i] = changedInput[i].replacingOccurrences(of: "nop", with: "jmp")
                assembler = Assembler(code: changedInput)
                let result = assembler.run()
                if result.terminated {
                    changedInput[i] = changedInput[i].replacingOccurrences(of: "jmp", with: "nop")
                } else {
                    return "\(result.acc)"
                }
            }
        }
        return "No Result found"
    }
}
