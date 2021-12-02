//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/2

enum Day_2_2021: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var horizontalPos = 0
        var depth = 0
        for line in input {
            let comp = line.components(separatedBy: " ")
            switch comp[0] {
            case "forward":
                horizontalPos += Int(comp[1]) ?? 0
            case "down":
                depth += Int(comp[1]) ?? 0
            case "up":
                depth -= Int(comp[1]) ?? 0
            default:
                fatalError("Can nor perform command \(comp[0])")
            }
        }
        return "\(horizontalPos * depth)"
    }

    static func solvePart2(input: [String]) -> String {
        var horizontalPos = 0
        var depth = 0
        var aim = 0
        for line in input {
            let comp = line.components(separatedBy: " ")
            switch comp[0] {
            case "forward":
                horizontalPos += Int(comp[1]) ?? 0
                depth += aim * (Int(comp[1]) ?? 0)
            case "down":
                aim += Int(comp[1]) ?? 0
            case "up":
                aim -= Int(comp[1]) ?? 0
            default:
                fatalError("Can nor perform command \(comp[0])")
            }
        }
        return "\(horizontalPos * depth)"
    }
}
