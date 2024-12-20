//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/19

enum Day_19_2024: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (patterns: [String], designs: [String])
    
    static func convert(input: [String]) -> ConvertedInput {
        var lines = input
        let towels = lines.removeFirst().components(separatedBy: ", ")
        lines.removeFirst()
        return (towels, lines)
    }
    
    static func isPossible(design: String, patterns: [String]) -> Bool {
        guard !design.isEmpty else { return true }
        for pattern in patterns {
            var design = design
            if design.starts(with: pattern) {
                design.removeFirst(pattern.count)
                if isPossible(design: design, patterns: patterns) {
                    return true
                }
            }
        }
        return false
    }
    
    static func possibleCount(design: String, patterns: [String], cache: inout [String: Int]) -> Int {
        guard !design.isEmpty else { return 1 }
        
        if let cached = cache[design] {
            return cached
        }
        
        var count = 0
        for pattern in patterns {
            var design = design
            if design.starts(with: pattern) {
                design.removeFirst(pattern.count)
                count += possibleCount(design: design, patterns: patterns, cache: &cache)
            }
        }
        
        cache[design] = count
        
        return count
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let possibleDesigns = input.designs.filter { isPossible(design: $0, patterns: input.patterns) }
        return "\(possibleDesigns.count)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var count = 0
        var cache: [String: Int] = [:]
        input.designs.forEach { design in
            count += possibleCount(design: design, patterns: input.patterns, cache: &cache)
        }
        return "\(count)"
    }
}
