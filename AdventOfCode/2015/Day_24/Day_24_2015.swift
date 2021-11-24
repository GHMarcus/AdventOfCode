//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/24

enum Day_24_2015: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [Int]) -> String {
        let sum = input.reduce(0, +)
        let combinations = perfectSumCombinations(for: input, sum: sum/3)
        
        let amountOfPackages = combinations.map { $0.count }
        let minimumAmount = amountOfPackages.min() ?? 0
        let possibleFirstGroupCombinations = combinations.filter { $0.count == minimumAmount }
        
        let quantumEntanglementsForPossibleCombinations = possibleFirstGroupCombinations.map { $0.reduce(1, *) }
        
        return "\(quantumEntanglementsForPossibleCombinations.min() ?? 0)"
    }

    static func solvePart2(input: [Int]) -> String {
        let sum = input.reduce(0, +)
        let combinations = perfectSumCombinations(for: input, sum: sum/4)
        
        let amountOfPackages = combinations.map { $0.count }
        let minimumAmount = amountOfPackages.min() ?? 0
        let possibleFirstGroupCombinations = combinations.filter { $0.count == minimumAmount }
        
        let quantumEntanglementsForPossibleCombinations = possibleFirstGroupCombinations.map { $0.reduce(1, *) }
        
        return "\(quantumEntanglementsForPossibleCombinations.min() ?? 0)"
    }
}
