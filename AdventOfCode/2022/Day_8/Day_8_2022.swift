//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/8

enum Day_8_2022: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2022

    static func solvePart1(input: [String]) -> String {
        var map: [[Int]] = []

        for line in input {
            let numbers = Array(line)
                .compactMap{ String($0) }
                .compactMap { Int($0) }
            map.append(numbers)
        }

        var innerVisible = 0

        for y in 1 ..< (map.count-1) {
            for x in 1 ..< (map[0].count-1) {
                let tree = map[y][x]

                var leftTrees: [Int] = []
                for dx in 1...x {
                    leftTrees.append(map[y][x-dx])
                }
                if leftTrees.allSatisfy({ $0 < tree }) {
                    innerVisible += 1
                    continue
                }

                var rightTrees: [Int] = []
                for dx in 1..<(map.count-x) {
                    rightTrees.append(map[y][x+dx])
                }
                if rightTrees.allSatisfy({ $0 < tree }) {
                    innerVisible += 1
                    continue
                }

                var upTrees: [Int] = []
                for dy in 1...y {
                    upTrees.append(map[y-dy][x])
                }
                if upTrees.allSatisfy({ $0 < tree }) {
                    innerVisible += 1
                    continue
                }

                var downTrees: [Int] = []
                for dy in 1..<(map.count-y) {
                    downTrees.append(map[y+dy][x])
                }
                if downTrees.allSatisfy({ $0 < tree }) {
                    innerVisible += 1
                    continue
                }

            }
        }


        let outerVisible = 2 * map.count + 2 * (map[0].count - 2)

        return "\(innerVisible + outerVisible)"
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[Int]] = []

        for line in input {
            let numbers = Array(line)
                .compactMap{ String($0) }
                .compactMap { Int($0) }
            map.append(numbers)
        }

        var highestScore = 0

        for y in 1 ..< (map.count-1) {
            for x in 1 ..< (map[0].count-1) {
                let tree = map[y][x]

                var leftTrees: [Int] = []
                for dx in 1...x {
                    let leftTree = map[y][x-dx]
                    leftTrees.append(leftTree)
                    if leftTree >= tree {
                        break
                    }
                }

                var rightTrees: [Int] = []
                for dx in 1..<(map.count-x) {
                    let rightTree = map[y][x+dx]
                    rightTrees.append(rightTree)
                    if rightTree >= tree {
                        break
                    }
                }

                var upTrees: [Int] = []
                for dy in 1...y {
                    let upTree = map[y-dy][x]
                    upTrees.append(upTree)
                    if upTree >= tree {
                        break
                    }
                }

                var downTrees: [Int] = []
                for dy in 1..<(map.count-y) {
                    let downTree = map[y+dy][x]
                    downTrees.append(downTree)
                    if downTree >= tree {
                        break
                    }
                }
                let score = leftTrees.count * rightTrees.count * upTrees.count * downTrees.count
                if score > highestScore {
                    highestScore = score
                }
            }
        }

        return "\(highestScore)"
    }
}
