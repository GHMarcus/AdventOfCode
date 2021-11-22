//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/20

enum Day_20_2015: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [Int]) -> String {
        let searchPresentAmount = (input.first ?? 0)
        var houses = Array(repeating: 10, count: searchPresentAmount)
        var number = 0
        
        for i in 2...houses.count {
            for n in stride(from: i, to: houses.count, by: i) {
                houses[n] += i*10
            }
            if houses[i] >= searchPresentAmount {
                number = i
                break
            }
        }
        
        return "\(number)"
    }

    static func solvePart2(input: [Int]) -> String {
        let searchPresentAmount = (input.first ?? 0)
        var houses = Array(repeating: 10, count: searchPresentAmount)
        var number = 0
        
        for i in 2...houses.count {
            var visitedHousesPerElf = 0
            for n in stride(from: i, to: houses.count, by: i).prefix(50) {
                visitedHousesPerElf += 1
                houses[n] += i*11
            }
            if houses[i] >= searchPresentAmount {
                number = i
                break
            }
        }
        
        return "\(number)"
    }
}
