//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/9

enum Day_9_2021: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var map: [[Int]] = []
        for line in input {
            map.append(Array(line).compactMap({ Int(String($0)) }))
        }

        var sum = 0

        for row in 0..<map.count {
            for column in 0..<map[0].count {
                if isLowerPoint(row: row, column: column, map: map) {
                    sum += map[row][column] + 1
                }
            }
        }

        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[Int]] = []
        var stringMap: [String] = []
        for line in input {
            map.append(Array(line).compactMap({ Int(String($0)) }))
            stringMap.append(line.replacingOccurrences(of: "9", with: "."))
        }

        var lowerPoints: [(row: Int, column: Int)] = []

        for row in 0..<map.count {
            for column in 0..<map[0].count {
                if isLowerPoint(row: row, column: column, map: map) {
                    lowerPoints.append((row,column))
                }
            }
        }

        var basins: [Int] = []

        for point in lowerPoints {
            basins.append(exploreBasin(row: point.row, column: point.column, map: map, points: []).count)
        }

        return "\(basins.sorted(by: >).dropLast(basins.count - 3).reduce(1, *))"
    }

    static func isLowerPoint(row: Int, column: Int, map: [[Int]]) -> Bool {
        let  currentValue = map[row][column]
        var isLower = true
        if row > 0 {
            let value = map[row-1][column]
            isLower  = isLower && value > currentValue
        }
        if row < map.count - 1 {
            let value = map[row+1][column]
            isLower  = isLower && value > currentValue
        }

        if column > 0 {
            let value = map[row][column-1]
            isLower  = isLower && value > currentValue
        }
        if column < map[0].count - 1 {
            let value = map[row][column+1]
            isLower  = isLower && value > currentValue
        }

        return isLower
    }

    static func exploreBasin(row: Int, column: Int, map: [[Int]], points: [(row: Int, column: Int)]) -> [(row: Int, column: Int)] {
        let neighbours = getNeighboursPart1(row: row, column: column, map: map)
        var newPoints: [(row: Int, column: Int)] = []
        for neighbour in neighbours {
            if points.contains(where: { $0.row == neighbour.row && $0.column == neighbour.column }){
                continue
            }
            if map[neighbour.row][neighbour.column] == 9 {
                continue
            }
            newPoints.append(neighbour)
        }

        for newPoint in newPoints {
            newPoints += exploreBasin(row: newPoint.row, column: newPoint.column, map: map, points: newPoints+points)
        }
        return newPoints
    }

    private static func getNeighboursPart1(row: Int, column: Int, map: [[Int]]) -> [(row: Int, column: Int)] {
        var neighbours: [(row: Int, column: Int)] = []
        let possibleNeighbours = [
                                   (row - 1, column),
            (row    , column - 1),                   (row    , column + 1),
                                   (row + 1, column),
        ]
        for n in possibleNeighbours {
            guard  n.0 >= 0, n.1 >= 0, n.0 < map.count, n.1 < map[0].count else {
                continue
            }
            neighbours.append(n)
        }
        return neighbours
    }
}
