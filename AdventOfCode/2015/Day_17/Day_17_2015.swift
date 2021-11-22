//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/17

enum Day_17_2015: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [Int]) -> String {
        let combinations = perfectSumCombinations(for: input, sum: 150)
        
        return "\(combinations.count)"
    }

    static func solvePart2(input: [Int]) -> String {
        var combinations = perfectSumCombinations(for: input, sum: 150)
        
        let min = combinations.map({ $0.count }).min() ?? 0
        combinations = combinations.filter { $0.count == min }
        
        return "\(combinations.count)"
    }
}
