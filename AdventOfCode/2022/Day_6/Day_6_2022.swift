//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/6

enum Day_6_2022: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2022

    static func solvePart1(input: [Character]) -> String {
        return "\(findMarker(length: 4, input: input))"
    }

    static func solvePart2(input: [Character]) -> String {
        return "\(findMarker(length: 14, input: input))"
    }

    static func findMarker(length: Int, input: [Character]) -> Int {
        var i = 0
        var length = length - 1

        while i+length < input.count {
            let marker = input[i...i+length]
            let isRealMarker = String(marker).getCountedCharacters.allSatisfy { $0.value == 1 }
            if isRealMarker {
                // length for the offset of characters and 1 for array starting with 0
                i += length + 1
                break
            } else {
                i += 1
            }
        }

        return i
    }
}
