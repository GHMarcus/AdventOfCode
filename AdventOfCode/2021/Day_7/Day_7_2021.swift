//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/7

enum Day_7_2021: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        let  positions = input[0].components(separatedBy: ",").compactMap { Int($0) }

        var minFuel = Int.max
        for pos in 0...(positions.max()!) {
            var fuel = 0
            for position in  positions {
                fuel += abs(position-pos)
            }
            minFuel = min(fuel, minFuel)
        }

        return "\(minFuel)"
    }
    
    static func solvePart2(input: [String]) -> String {
        let  positions = input[0].components(separatedBy: ",").compactMap { Int($0) }
        
        var minFuel = Int.max
        for pos in 0...(positions.max()!) {
            var fuel = 0
            for position in  positions {
                let distance = abs(position-pos)
                if distance > 0 {
                    fuel += (0...distance).reduce(0, +)
                    if fuel > minFuel {
                        break
                    }
                }
            }
            minFuel = min(fuel, minFuel)
        }
        
        return "\(minFuel)"
    }
}

