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
        let map =  reuseTreePattern(map: lines, multiplier: 3)
        let positions = getPositions(stepsRight: 3, stepsDown: 1, height: map.count)
        var trees = 0
        for pos in positions {
            let row = Array(map[pos.y])
            if row[pos.x] == "#" {
                trees += 1
            }
        }
        return "\(trees)"
    }

    private static func solvePart2(lines: [String]) -> String {
        let moves:[(right: Int, down: Int)] = [(1,1),(3,1),(5,1),(7,1),(1,2)]
        var trees: [Int] = []
        for move in moves {
            let map =  reuseTreePattern(map: lines, multiplier: move.right)
            let positions = getPositions(stepsRight: move.right, stepsDown: move.down, height: map.count)
            var tree = 0
            for pos in positions {
                let row = Array(map[pos.y])
                if row[pos.x] == "#" {
                    tree += 1
                }
            }
            trees.append(tree)
        }

        return "\(trees.reduce(1, *))"
    }

    private static func reuseTreePattern(map: [String], multiplier: Int) -> [String] {
        var newMap = map
        let minWidth = map.count * multiplier
        while newMap[0].count < minWidth {
            newMap = newMap.map{ $0 + $0 }
        }
        return newMap
    }

    private static func getPositions(stepsRight: Int, stepsDown: Int, height: Int) -> [(x:Int, y:Int)] {
        var positions: [(x:Int, y:Int)] = []
        let setps = height / stepsDown
        for i in 1..<setps {
            positions.append((stepsRight*i, stepsDown*i))
        }
        return positions
    }
}
