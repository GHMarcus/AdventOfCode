//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/25

enum Day_25_2024: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (locks: [[Int]], keys: [[Int]])

    static func convert(input: [String]) -> ConvertedInput {
        var locks: [[Int]] = []
        var keys: [[Int]] = []
        
        var index = 0
        
        while index < input.count {
            let line = input[index]
            if line.isEmpty {
                index += 1
                continue
            }
            if line.contains("#") {
                var lock = Array(repeating: 0, count: 5)
                for n in 1...5 {
                    for (i,c) in Array(input[index + n]).enumerated() {
                        lock[i] += c == "#" ? 1 : 0
                    }
                }
                index += 7
                locks.append(lock)
                continue
            } else {
                var key = Array(repeating: 0, count: 5)
                for n in 1...5 {
                    for (i,c) in Array(input[index + n]).enumerated() {
                        key[i] += c == "#" ? 1 : 0
                    }
                }
                index += 7
                keys.append(key)
                continue
            }
        }
        
        
        return (locks, keys)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var fittingKeys = 0
        for lock in input.locks {
            for key in input.keys {
                let fit = zip(lock, key).allSatisfy { $0 + $1 <= 5 }
                if fit {
                    fittingKeys += 1
                }
            }
        }
        return "\(fittingKeys)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        return "Add some Code here"
    }
}


/*
 0,5,3,4,3
 1,2,0,5,3

 5,0,2,1,3
 4,3,4,0,2
 3,0,2,0,1
 */
