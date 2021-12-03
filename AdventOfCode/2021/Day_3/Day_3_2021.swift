//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/3

enum Day_3_2021: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var gamma = ""
        var epsilon = ""
        let columns = getColumns(from: input)
        
        for column in columns {
            let counted = column
                .getCountedCharacters
                .sorted { $0.value > $1.value }
            gamma.append(counted.first!.key)
            epsilon.append(counted.last!.key)
        }
        
        return "\((Int(gamma, radix: 2) ?? 0) * (Int(epsilon, radix: 2) ?? 0))"
    }

    static func solvePart2(input: [String]) -> String {
        let oxygen = findOxygen(input: input, pos: 0)
        let co2 = findCo2(input: input, pos: 0)

        return "\((Int(oxygen, radix: 2) ?? 0) * (Int(co2, radix: 2) ?? 0))"
    }
}

extension Day_3_2021 {
    static func findOxygen(input: [String], pos: Int) -> String {
        if input.count == 1 {
            return input.first!
        }
        
        let columns = getColumns(from: input)
        let mostCommon: Character
        let counts = columns[pos]
            .getCountedCharacters
            .sorted { $0.value > $1.value }
        
        if counts.count == 2,
           counts[0].value == counts[1].value {
            mostCommon = "1"
        } else {
            mostCommon = counts.first!.key
        }
        
        return findOxygen(
            input: input.filter{ Array($0)[pos] == mostCommon },
            pos: pos+1
        )
    }
    
    static func findCo2(input: [String], pos: Int) -> String {
        if input.count == 1 {
            return input.first!
        }
        
        let columns = getColumns(from: input)
        let mostCommon: Character
        let counts = columns[pos]
            .getCountedCharacters
            .sorted { $0.value < $1.value }
        
        if counts.count == 2,
           counts[0].value == counts[1].value {
            mostCommon = "0"
        } else {
            mostCommon = counts.first!.key
        }
        
        return findCo2(
            input: input.filter{ Array($0)[pos] == mostCommon },
            pos: pos+1
        )
    }
    
    static func getColumns(from input: [String]) -> [String] {
        var columns = Array(repeating: "", count: input[0].count)
        for line in input {
            let letters = Array(line)
            for i in 0..<letters.count {
                columns[i].append(letters[i])
            }
        }
        return columns
    }
}
