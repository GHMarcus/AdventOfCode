//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/25

enum Day_25_2021: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var map: [[Character]] = input.map { Array($0) }
        var newMap: [[Character]] = map
        var step = 0
        var someoneMoved = true
        while someoneMoved {
            step += 1
            someoneMoved = false
            
            map = newMap
            for row in 0..<map.count {
                for col in 0..<map[0].count where map[row][col] == ">" {
                    
                    let nextCol = col == map[0].count - 1 ? 0 : col + 1
                    guard map[row][nextCol] == "." else { continue }
                    
                    newMap[row][nextCol] = ">"
                    newMap[row][col] = "."
                    someoneMoved = true
                }
            }
            
            map = newMap
            for row in 0..<map.count {
                for col in 0..<map[0].count where map[row][col] == "v" {
                    
                    let nextRow = row == map.count - 1 ? 0 : row + 1
                    guard map[nextRow][col] == "." else { continue }
                    
                    newMap[nextRow][col] = "v"
                    newMap[row][col] = "."
                    someoneMoved = true
                }
            }
        }
        return "\(step)"
    }

    static func solvePart2(input: [String]) -> String {
        "Nothing to do here"
    }
}
