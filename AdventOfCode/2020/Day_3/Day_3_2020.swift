//
//  Day_3_2020.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 02.12.20.
//

// https://adventofcode.com/2020/day/3

enum Day_3_2020: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        let map =  reuseTreePattern(map: input, multiplier: 3)
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

    static func solvePart2(input: [String]) -> String {
        let moves:[(right: Int, down: Int)] = [(1,1),(3,1),(5,1),(7,1),(1,2)]
        var trees: [Int] = []
        for move in moves {
            let map =  reuseTreePattern(map: input, multiplier: move.right)
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
