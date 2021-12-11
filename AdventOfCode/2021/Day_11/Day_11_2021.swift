//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/11

enum Day_11_2021: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var energyLevels: [[Int]] = []
        for line in input {
            let numbers = Array(line).compactMap({ Int(String($0)) })
            energyLevels.append(numbers)
        }

        var n = 0
        var flashes = 0
        while n < 100 {
            n += 1

            for row in 0..<energyLevels.count {
                for column in 0..<energyLevels[0].count {
                    energyLevels[row][column] += 1
                }
            }

            let result = countFlashes(energyLevels: energyLevels)
            flashes += result.0
            energyLevels = result.1
        }
        
        return "\(flashes)"
    }

    static func solvePart2(input: [String]) -> String {
        var energyLevels: [[Int]] = []
        for line in input {
            let numbers = Array(line).compactMap({ Int(String($0)) })
            energyLevels.append(numbers)
        }

        var n = 0
        while true {
            n += 1

            for row in 0..<energyLevels.count {
                for column in 0..<energyLevels[0].count {
                    energyLevels[row][column] += 1
                }
            }

            let result = countFlashes(energyLevels: energyLevels)
            if result.0 == energyLevels.count * energyLevels[0].count {
                break
            }
            energyLevels = result.1
        }

        return "\(n)"
    }

    static func countFlashes(energyLevels: [[Int]]) -> (Int, [[Int]]) {
        var flashes = 0
        var energyLevels = energyLevels
        while true {
            var noFlashes = true

            for row in 0..<energyLevels.count {
                for column in 0..<energyLevels[0].count {
                    if energyLevels[row][column] > 9 {
                        flashes += 1
                        energyLevels[row][column] = 0
                        let result = flashNeighbours(row: row, column: column, energyLevels: energyLevels)
                        energyLevels = result.0
                        noFlashes = noFlashes && result.1
                    }
                }
            }

            if noFlashes {
                break
            }
        }

        return (flashes, energyLevels)
    }

    static func flashNeighbours(row:Int, column: Int, energyLevels: [[Int]]) -> ([[Int]], Bool) {
        let neighbours = [(row-1,column-1), (row,column-1), (row+1,column-1),
                          (row-1,column  ),                 (row+1,column  ),
                          (row-1,column+1), (row,column+1), (row+1,column+1)]
        var energyLevels = energyLevels
        var noFlashes = true
        for neighbour in neighbours {
            if neighbour.0 >= 0 && neighbour.1 >= 0 && neighbour.0 < energyLevels[0].count && neighbour.1 < energyLevels.count {
                if energyLevels[neighbour.0][neighbour.1] != 0 {
                    energyLevels[neighbour.0][neighbour.1] += 1
                }
                if energyLevels[neighbour.0][neighbour.1] > 9 {
                    noFlashes = false
                }
            }
        }

        return (energyLevels, noFlashes)
    }
}



