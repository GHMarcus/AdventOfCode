//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/18

enum Day_18_2016: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2016
    
    static func convert(input: [String]) -> String {
        input.first!
    }

    static func solvePart1(input: String) -> String {
        var currentRow = input
        var safeTiles = input.countInstances(of: ".")
        for _ in 1..<40 {
            let (nextRow, nextSafeTiles) = getNextRow(for: currentRow)
            safeTiles += nextSafeTiles
            currentRow = nextRow
        }
        return "\(safeTiles)"
    }
    
    static func solvePart2(input: String) -> String {
        var currentRow = input
        var safeTiles = input.countInstances(of: ".")
        for _ in 1..<400000 {
            let (nextRow, nextSafeTiles) = getNextRow(for: currentRow)
            safeTiles += nextSafeTiles
            currentRow = nextRow
        }
        return "\(safeTiles)"
    }
    
    static func getNextRow(for current: String) -> (String, Int) {
        var nextRow: String = ""
        var safeTiles: Int = 0
        let extendedCurrent = ["."] + Array(current) + ["."]
        for i in 1...current.count {
            switch (extendedCurrent[i-1], extendedCurrent[i], extendedCurrent[i+1]) {
            case ("^", "^", "."),
                (".", "^", "^"),
                ("^", ".", "."),
                (".", ".", "^"):
                nextRow.append("^")
            default:
                safeTiles += 1
                nextRow.append(".")
            }
        }
        return (nextRow, safeTiles)
    }
}
