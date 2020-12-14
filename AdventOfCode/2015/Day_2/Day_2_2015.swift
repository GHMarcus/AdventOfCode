//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/2

enum Day_2_2015: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        var footOfPaper = 0
        for line in input {
            let dimensions = line.components(separatedBy: "x").compactMap{ Int($0) }
            guard dimensions.count == 3 else { fatalError("Wrong number of Dimensions: \(dimensions.count)")}
            var shiftedDimensions = dimensions.dropFirst()
            shiftedDimensions.append(dimensions[0])
            let squares = zip(dimensions, shiftedDimensions).map(*)
            footOfPaper += squares.min() ?? 0
            footOfPaper += squares.map({ $0 * 2}).reduce(0, +)
        }
        return "\(footOfPaper)"
    }

    static func solvePart2(input: [String]) -> String {
        var footOfRibbon = 0
        for line in input {
            var dimensions = line.components(separatedBy: "x").compactMap{ Int($0) }
            guard dimensions.count == 3 else { fatalError("Wrong number of Dimensions: \(dimensions.count)")}
            dimensions.sort()
            footOfRibbon += 2 * (dimensions[0] + dimensions[1]) + dimensions.reduce(1, *)
        }
        return "\(footOfRibbon)"
    }
}

/*
 ********** Day_2 Year 2015 **********
 Solution for Part 1: 1588178
 Solution for Part 2: 3798106
 *************************************
 Took 0.04610097408294678 seconds
 Program ended with exit code: 0
 */
