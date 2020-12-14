//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/5

enum Day_5_2015: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        var niceStrings = 0
        let vowels: [Character] = ["a", "e", "i", "o", "u"]
        for line in input {
            if line.contains("ab") || line.contains("cd") || line.contains("pq") || line.contains("xy") {
                continue
            }
            var vowelNumber = 0

            for c in Array(line) {
                if vowels.contains(c) {
                    vowelNumber += 1
                }
            }

            guard vowelNumber >= 3 else {
                continue
            }
            let letters = Array(line)
            for i in 0..<letters.count-1 {
                if letters[i] == letters[i+1] {
                    niceStrings += 1
                    break
                }
            }
        }
        return "\(niceStrings)"
    }

    static func solvePart2(input: [String]) -> String {
        var niceStrings = 0
        for line in input {

            var firstPassed = false
            let letters = Array(line)
            for i in 0..<letters.count-2 {
                if letters[i] == letters[i+2] {
                    firstPassed = true
                    break
                }
            }

            guard firstPassed else { continue }

            for i in 0..<letters.count-3 {
                let first = String(letters[i]) + String(letters[i+1])
                let split = line.replacingOccurrences(of: first, with: "")
                if line.count - split.count >= 4 {
                    niceStrings += 1
                    break
                }
            }
        }
        return "\(niceStrings)"
    }
}
