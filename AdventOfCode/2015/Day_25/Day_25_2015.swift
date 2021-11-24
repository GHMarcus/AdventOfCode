//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/25

enum Day_25_2015: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        let comp = input[0].replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").components(separatedBy: " ")
        let rowIndex = comp.firstIndex(of: "row")!
        let columnIndex = comp.firstIndex(of: "column")!
        let row = Int(comp[rowIndex+1])!
        let column = Int(comp[columnIndex+1])!
        
        let diagonalNumber = row + column - 1
        
        // Subtract the right not filled triangle under the diagonal.
        // Each triangle contains (n * n - n) / 2 elements
        let maxCodeNumberInDiagonal = diagonalNumber * diagonalNumber - (diagonalNumber * diagonalNumber - diagonalNumber) / 2
        let codeNumber = maxCodeNumberInDiagonal - diagonalNumber + column
        
        var code = 20151125
        let multiplier = 252533
        let divisor = 33554393
        if codeNumber == 1 {
            return "\(code)"
        }
        for _ in 2...codeNumber {
            code = (code * multiplier) % divisor
        }
        return "\(code)"
    }

    static func solvePart2(input: [String]) -> String {
        "Nothing to do here"
    }
}
