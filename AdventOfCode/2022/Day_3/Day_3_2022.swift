//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/3

enum Day_3_2022: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2022

    static func solvePart1(input: [String]) -> String {

        var wrongItems: [Character] = []

        for line in input {
            let cmp = line.split(every: line.count/2)
            let cmp1 = cmp[0].getCountedCharacters
            let cmp2 = cmp[1].getCountedCharacters

            for (c, _) in cmp1 {
                if cmp2.keys.contains(c) {
                    wrongItems.append(c)
                }
            }
        }

        return "\(wrongItems.compactMap({ $0.letterValueCaseSensitive }).reduce(0, +))"
    }

    static func solvePart2(input: [String]) -> String {

        var commonItems: [Character] = []

        let groups = input.chunked(into: 3)

        for group in groups {
            let cmp1 = group[0].getCountedCharacters
            let cmp2 = group[1].getCountedCharacters
            let cmp3 = group[2].getCountedCharacters

            for (c, _) in cmp1 {
                if cmp2.keys.contains(c) && cmp3.keys.contains(c) {
                    commonItems.append(c)
                }
            }
        }

        return "\(commonItems.compactMap({ $0.letterValueCaseSensitive }).reduce(0, +))"
    }
}
