//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/4

enum Day_4_2017: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2017

    static func solvePart1(input: [String]) -> String {
        var validCount = 0
        
        for line in input {
            let phrases = line.components(separatedBy: " ").countedElements
            var isValid = true
            for phrase in phrases {
                if phrase.value > 1 {
                    isValid = false
                    break
                }
            }
            if isValid {
                validCount += 1
            }
        }
        
        return "\(validCount)"
    }

    static func solvePart2(input: [String]) -> String {
        var validCount = 0
        
        for line in input {
            var phrases = line.components(separatedBy: " ")
            var isValid = true
            
            for _ in 0..<phrases.count {
                let phrase = Array(phrases.removeFirst()).sorted()
                phrases.append(String(phrase))
            }
            
            let countedPhrases = phrases.countedElements
            for phrase in countedPhrases {
                if phrase.value > 1 {
                    isValid = false
                    break
                }
            }
            if isValid {
                validCount += 1
            }
        }
        
        return "\(validCount)"
    }
}
