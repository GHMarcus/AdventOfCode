//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/12

enum Day_12_2018: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2018
    
    struct Rule {
        let condition: String
        let next: Character
    }

    static func convert(input: [String]) -> (initial: [Character], rules: [Rule]) {
        var lines = input
        let initial = Array(lines.removeFirst().components(separatedBy: " ").last!)
        lines.removeFirst()
        
        var rules: [Rule] = []
        for line in lines {
            let cmp = line.components(separatedBy: " => ")
            rules.append(.init(condition: cmp[0], next: cmp[1].first!))
        }
        
        return (initial, rules)
    }
    
    static func solvePart1(input: (initial: [Character], rules: [Rule])) -> String {
        var current = input.initial
        
        let generations = 20
        for _ in 1...generations {
            var nextGeneration: [Character] = []
            for index in -1 ... current.count {
                let ll = getPlant(for: index - 2, in: current)
                let l = getPlant(for: index - 1, in: current)
                let c = getPlant(for: index, in: current)
                let r = getPlant(for: index + 1, in: current)
                let rr = getPlant(for: index + 2, in: current)
                let condition = String([ll, l, c, r, rr])
                
                if let rule = input.rules.first(where: { $0.condition == condition }) {
                    nextGeneration.append(rule.next)
                } else {
                    nextGeneration.append(".")
                }
            }
            current = nextGeneration
        }
        
        var sum = 0
        
        for (index, c) in current.enumerated() where c == "#" {
            sum += index - generations
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: (initial: [Character], rules: [Rule])) -> String {
        // Note that after nearly 100 iterations there is one pattern left which will shifted to right
        //....#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#..#
        // That means there is a fixed amount which will added each generation to the sum
        
        var current = input.initial

        let realGenerations = 50000000000
        let generations = 200
        var diffs: [Int] = []
        var prevSum = 0
        
        for g in 1...generations {
            var nextGeneration: [Character] = []
            for index in -1 ... current.count {
                let ll = getPlant(for: index - 2, in: current)
                let l = getPlant(for: index - 1, in: current)
                let c = getPlant(for: index, in: current)
                let r = getPlant(for: index + 1, in: current)
                let rr = getPlant(for: index + 2, in: current)
                let condition = String([ll, l, c, r, rr])
                
                if let rule = input.rules.first(where: { $0.condition == condition }) {
                    nextGeneration.append(rule.next)
                } else {
                    nextGeneration.append(".")
                }
            }
            current = nextGeneration
            
            let sum = sumPlants(current, generation: g)
            diffs.append(sum - prevSum)
            prevSum = sum
        }
        
        let stabilizedDiff = diffs[100...].reduce(0, +) / 100
        let realSum = ((realGenerations - generations) * stabilizedDiff) + prevSum
        
        return "\(realSum)"
    }
    
    static func getPlant(for index: Int, in state: [Character]) -> Character {
        guard index >= 0, index < state.count else { return "." }
        return state[index]
    }
    
    static func sumPlants(_ plants: [Character], generation: Int) -> Int {
        var sum = 0
        for (index, c) in plants.enumerated() where c == "#" {
            sum += index - generation
        }
        return sum
    }
}
