//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/2

enum Day_2_2024: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2024

    static func convert(input: [String]) -> [[Int]] {
        var reports: [[Int]] = []
        for line in input {
            let levels = line.components(separatedBy: " ").map { Int($0)! }
            reports.append(levels)
        }
        return reports
    }

    static func isSafe(_ diffs: [Int]) -> Bool {
        diffs.allSatisfy {
            $0 > 0 && abs($0) <= 3 && abs($0) >= 1
        }
        ||
        diffs.allSatisfy{
            $0 < 0 && abs($0) <= 3 && abs($0) >= 1
        }
    }
    
    static func determineSafetyness(for levels: [Int]) -> Bool {
        let diffs = zip(levels.dropFirst(), levels).map { $0 - $1 }
        return isSafe(diffs)
    }
    
    static func solvePart1(input: [[Int]]) -> String {
        var safeCount = 0
        for levels in input {
            if determineSafetyness(for: levels) {
                safeCount += 1
            }
        }
        return "\(safeCount)"
    }

    static func solvePart2(input: [[Int]]) -> String {
        var safeCountWithoutRemoving = 0
        var safeCountAfterRemoving = 0
        
        var levelsForProblemDampener: [[Int]] = []
        
        for levels in input {
            if determineSafetyness(for: levels) {
                safeCountWithoutRemoving += 1
            } else {
                levelsForProblemDampener.append(levels)
            }
        }
        
        for levels in levelsForProblemDampener {
            for i in 0..<levels.count {
                var newLevels = levels
                newLevels.remove(at: i)
                if determineSafetyness(for: newLevels) {
                    safeCountAfterRemoving += 1
                    break
                }
            }
        }
        
        return "\(safeCountWithoutRemoving + safeCountAfterRemoving)"
    }
}
