//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/7

enum Day_7_2017: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2017
    
    struct Program {
        let name: String
        let weight: Int
        let holding: [String]
    }
    
    static func convert(input: [String]) -> [Program] {
        var programs: [Program] = []
        for line in input {
            let cmp = line.components(separatedBy:  " ")
            let name = String(cmp[0])
            let weight = Int(cmp[1].dropLast().dropFirst())!
            let holding: [String] = cmp.count > 2 ? cmp[3...].map{ $0.replacingOccurrences(of: ",", with: "") } : []
            programs.append(Program(name: name, weight: weight, holding: holding))
        }
        return programs
    }

    static func solvePart1(input: [Program]) -> String {
        var heldPrograms: Set<String> = []
        var nonHeldPrograms: Set<String> = []
        input.forEach { heldPrograms.formUnion($0.holding) }
        
        for program in input {
            if heldPrograms.contains(program.name) { continue }
            nonHeldPrograms.insert(program.name)
        }
        
        return "\(nonHeldPrograms.first!)"
    }

    static func solvePart2(input: [Program]) -> String {
        var heldPrograms: Set<String> = []
        var nonHeldPrograms: Set<String> = []
        input.forEach { heldPrograms.formUnion($0.holding) }
        
        for program in input {
            if heldPrograms.contains(program.name) { continue }
            nonHeldPrograms.insert(program.name)
        }
        
        let (program, weightDiff) = findWrongProgram(for: nonHeldPrograms.first!, in: input, diff: 0)
        
        return "\(program.weight + weightDiff)"
    }
    
    static func getWeight(of name: String, in programs: [Program]) -> Int {
        let program = programs.first(where: { $0.name == name })!
        return program.weight + program.holding.reduce(0) { $0 + getWeight(of: $1, in: programs) }
    }
    
    static func findWrongProgram(for name: String, in programs: [Program], diff: Int) -> (Program, Int) {
        let root = programs.first(where: { $0.name == name })!
        
        var weights: [String: Int] = [:]
        
        for program in root.holding {
            weights[program] = getWeight(of: program, in: programs)
        }
        
        let grouped = Dictionary(grouping: weights.keys, by: { weights[$0]! })
        if let wrong = grouped.first(where: { $0.value.count == 1 }),
           let otherWeight = grouped.first(where: { $0.value.count > 1 })?.key {
            return findWrongProgram(for: wrong.value.first!, in: programs, diff: otherWeight-wrong.key)
        } else {
            return (root, diff)
        }
    }
}
