//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/9

enum Day_9_2017: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2017
    
    static func convert(input: [String]) -> String {
        input.first!
    }

    static func solvePart1(input: String) -> String {
        var score = 0
        var nestingLevel = 0
        
        let stream = Array(input)
        var isGarbage = false
        var ignoreNext: Bool = false
        for i in 0..<stream.count {
            let c = stream[i]
            if ignoreNext {
                ignoreNext = false
            } else if c == "<", !isGarbage {
                isGarbage = true
            } else if isGarbage, c == "!" {
                ignoreNext = true
            }else if c == ">", isGarbage {
                isGarbage = false
            } else if c == "{", !isGarbage {
                nestingLevel += 1
                score += nestingLevel
            } else if c == "}", !isGarbage {
                nestingLevel -= 1
            }
        }
        
        return "\(score)"
    }

    static func solvePart2(input: String) -> String {
        var removed = 0
        
        let stream = Array(input)
        var isGarbage = false
        var ignoreNext: Bool = false
        for i in 0..<stream.count {
            let c = stream[i]
            if ignoreNext {
                ignoreNext = false
            } else if c == "<", !isGarbage {
                isGarbage = true
            } else if isGarbage, c == "!" {
                ignoreNext = true
            }else if c == ">", isGarbage {
                isGarbage = false
            } else if c == "{", !isGarbage {
                continue
            } else if c == "}", !isGarbage {
                continue
            } else if isGarbage {
                removed += 1
            }
        }
        
        return "\(removed)"
    }
}
