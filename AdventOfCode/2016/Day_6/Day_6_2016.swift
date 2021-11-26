//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/6

enum Day_6_2016: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2016

    static func solvePart1(input: [String]) -> String {
        let separatedLines = input.map{Array($0)}
        
        var message = ""
        
        for pos in 0..<separatedLines[0].count {
            var extractedLetters: [String.Element] = []
            for letters in separatedLines{
                extractedLetters.append(letters[pos])
            }
            let mostFrequentLetter = String(extractedLetters)
                .getCountedCharacters
                .sorted { $0.value > $1.value }
                .first!
                .key
            
            message.append(mostFrequentLetter)
        }
        
        return message
    }

    static func solvePart2(input: [String]) -> String {
        let separatedLines = input.map{Array($0)}
        
        var message = ""
        
        for pos in 0..<separatedLines[0].count {
            var extractedLetters: [String.Element] = []
            for letters in separatedLines{
                extractedLetters.append(letters[pos])
            }
            let mostFrequentLetter = String(extractedLetters)
                .getCountedCharacters
                .sorted { $0.value < $1.value }
                .first!
                .key
            
            message.append(mostFrequentLetter)
        }
        
        return message
    }
}
