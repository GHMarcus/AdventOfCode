//
//  Day_3_2020.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 02.12.20.
//

// https://adventofcode.com/2020/day/3

enum Day_3_2020: Solvable {
    static func solve() {
        let day: Input.Day = .Day_3
        let year: Input.Year = .Year_2020

        let lines = Input.getStringArray(for: day, in: year)
        print("********** \(day.rawValue) Year \(year.rawValue) **********")
        print("Solution for Part 1: \(solvePart1(lines: lines))")
        print("Solution for Part 2: \(solvePart2(lines: lines))")
        print("*************************************")
    }

    private static func solvePart1(lines: [String]) -> String {
        "Add some code here"
    }

    private static func solvePart2(lines: [String]) -> String {
        "Add some code here"
    }
}
