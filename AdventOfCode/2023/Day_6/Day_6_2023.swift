//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/6

enum Day_6_2023: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2023
    
    struct Race {
        let totalTime: Int
        let distance: Int
        
        var winningRaces: Int {
            // To calculate the driven distance this function is used:
            // distance = (totalTime - t) * t -> -t^2 + (totalTime * t)
            // To find the values above the given distance we shift the parabola
            // -t^2 + (totalTime * t) - distance
            let zeros = findFunctionZeros(a: -1, b: totalTime, c: (-1*distance)) .sorted()
            
            let roundedLower = zeros[0].rounded(.up)
            let roundedUpper = zeros[1].rounded(.down)
            
            if roundedLower == zeros[0] && roundedUpper == zeros[1] {
                // If both zeros exactly one time unit, we have to exclude both
                return Int(roundedUpper - roundedLower - 1)
            } else if roundedLower == zeros[0] || roundedUpper == zeros[1] {
                // If one zero is exactly one time unit, we have to exclude only one
                return Int(roundedUpper - roundedLower)
            } else {
                // If both zeros not exactly one time unit, we have to use all points between
                return Int(roundedUpper - roundedLower + 1)
            }
        }
    }
    
    static func convert(input: [String]) -> [Race] {
        let times = input[0]
            .components(separatedBy: ":   ")[1]
            .components(separatedBy: "  ")
            .map { $0.trimmingCharacters(in: [" "]) }
            .filter { !$0.isEmpty }
        let distances = input[1]
            .components(separatedBy: ": ")[1]
            .components(separatedBy: "  ")
            .map { $0.trimmingCharacters(in: [" "]) }
            .filter { !$0.isEmpty }
        
        guard times.count == distances.count else { fatalError() }
        
        var races: [Race] = []
        // For Part 1
        for i in 0..<times.count {
            races.append(Race(totalTime: Int(times[i])!, distance: Int(distances[i])!))
        }
        
        // For Part 2
        races.append(Race(totalTime: Int(times.joined())!, distance: Int(distances.joined())!))
        
        return races
    }

    static func solvePart1(input: [Race]) -> String {
        
        let sum = input.dropLast().reduce(1) { $0 * $1.winningRaces }
        
        return "\(sum)"
    }

    static func solvePart2(input: [Race]) -> String {
        let race = input.last!
        return "\(race.winningRaces)"
    }
}
