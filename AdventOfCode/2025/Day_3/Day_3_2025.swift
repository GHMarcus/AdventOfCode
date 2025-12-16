//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/3

enum Day_3_2025: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [[Battery]]

    struct Battery {
        let pos: Int
        let joltage: Int
    }

    static func convert(input: [String]) -> ConvertedInput {
        var banks: [[Battery]] = []
        for line in input {
            var batteries: [Battery] = []
            let joltages = Array(line).map { Int(String($0))! }
            for (i, joltage) in joltages.enumerated() {
                batteries.append(.init(pos: i, joltage: joltage))
            }
            banks.append(batteries)
        }
        return banks
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var sum = 0
        for bank in input {
            sum += calculateJoltage(for: bank, with: 2)
        }
        return "\(sum)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var sum = 0
        for bank in input {
            sum += calculateJoltage(for: bank, with: 12)
        }
        return "\(sum)"
    }

    static func calculateJoltage(for bank: [Battery], with lenght: Int) -> Int {
        var usedBatteries: [Int] = []

        var lowerBound = 0
        var upperBound = bank.count - lenght

        while usedBatteries.count < lenght {
            let sorted = bank[lowerBound...upperBound].sorted { $0.joltage > $1.joltage }
            let chosen = sorted.first!
            usedBatteries.append(chosen.joltage)
            lowerBound = chosen.pos + 1
            upperBound = bank.count - lenght + usedBatteries.count
        }
        return Int(usedBatteries.map{ String($0) }.joined())!
    }
}
