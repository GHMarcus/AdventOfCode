//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/3

enum Day_3_2016: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2016
    
    static func solvePart1(input: [String]) -> String {
        let combinations = [[0,1,2],
                            [1,2,0],
                            [0,2,1]]
        var possibleTriangles = 0
        for line in input {
            let comps = line.components(separatedBy: " ").filter { $0 != "" }.compactMap { Int($0) }
            var isPossible = true
            
            for combination in combinations {
                isPossible = isPossible && (comps[combination[0]] + comps[combination[1]] > comps[combination[2]])
            }
            
            if isPossible {
                possibleTriangles += 1
            }
        }
        
        return "\(possibleTriangles)"
    }

    static func solvePart2(input: [String]) -> String {
        let combinations = [[0,1,2],
                            [1,2,0],
                            [0,2,1]]
        var possibleTriangles = 0

        let input = input.map {
            $0.components(separatedBy: " ").filter { $0 != "" }.compactMap { Int($0) }
        }

        let blocks3x3 = input.chunked(into: 3)
        var newLines: [[Int]] = []
        
        for block in blocks3x3 {
            for i in 0..<block.count {
                var newLine: [Int] = []
                for line in block {
                    newLine.append(line[i])
                }
                newLines.append(newLine)
            }
        }

        for line in newLines {
            var isPossible = true

            for combination in combinations {
                isPossible = isPossible && (line[combination[0]] + line[combination[1]] > line[combination[2]])
            }

            if isPossible {
                possibleTriangles += 1
            }
        }

        return "\(possibleTriangles)"
    }
}
