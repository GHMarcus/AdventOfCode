//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/18

enum Day_18_2015: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2015
    
    static var matrix: [[String.Element]] = []

    static func solvePart1(input: [String]) -> String {
        matrix = convertInputToLightMatrix(input)
        
        let maxSteps = 100
        for _ in 1...maxSteps {
            var tmpMatrix = matrix
            
            for y in 0..<tmpMatrix.count {
                for x in 0..<tmpMatrix[0].count {
                    let value = matrix[y][x]
                    let neighbours = countLightedNeighbours(x: x, y: y)
                    
                    if value == "." && neighbours == 3 {
                        tmpMatrix[y][x] = "#"
                    } else if value == "#" && (neighbours < 2 || neighbours > 3) {
                        tmpMatrix[y][x] = "."
                    }
                }
            }
            
            matrix = tmpMatrix
        }
        
        return "\(numberOffOnLights)"
    }

    static func solvePart2(input: [String]) -> String {
        matrix = convertInputToLightMatrix(input)
        
        // Make corners initially on
        matrix[0][0] = "#" // Top Left Corner
        matrix[matrix.count-1][0] = "#" // Bottom Left Corner
        matrix[matrix.count-1][matrix[0].count-1] = "#" // Bottom Right Corner
        matrix[0][matrix[0].count-1] = "#" // Top Right Corner
        
        let maxSteps = 100
        for _ in 1...maxSteps {
            var tmpMatrix = matrix
            
            for y in 0..<tmpMatrix.count {
                for x in 0..<tmpMatrix[0].count {
                    let value = matrix[y][x]
                    let neighbours = countLightedNeighbours(x: x, y: y, alwaysOnCorners: true)
                    
                    if value == "." && neighbours == 3 {
                        tmpMatrix[y][x] = "#"
                    } else if value == "#" && (neighbours < 2 || neighbours > 3) {
                        tmpMatrix[y][x] = "."
                    }
                }
            }
            
            matrix = tmpMatrix
        }
        
        return "\(numberOffOnLights)"
    }
}

extension Day_18_2015 {
    static func convertInputToLightMatrix(_ input: [String]) -> [[String.Element]] {
        var matrix: [[String.Element]] = []
        for line in input {
            matrix.append(Array(line))
        }
        return matrix
    }
    
    static func countLightedNeighbours(x: Int, y: Int, alwaysOnCorners: Bool = false) -> Int {
        let neighbours = [(x-1,y-1), (x,y-1), (x+1,y-1),
                          (x-1,y  ),          (x+1,y  ),
                          (x-1,y+1), (x,y+1), (x+1,y+1)]
        
        var lightsOnCount = 0
        for neighbour in neighbours {
            if neighbour.0 >= 0 && neighbour.1 >= 0 && neighbour.0 < matrix[0].count && neighbour.1 < matrix.count {
                
                if alwaysOnCorners {
                    if (x == 0 && y == 0) // Top Left Corner
                        || (x == 0 && y == matrix.count-1) // Bottom Left Corner
                        || (x == matrix[0].count-1 && y == matrix.count-1) // Bottom Right Corner
                        || (x == matrix[0].count-1 && y == 0) { // Top Right Corner
                        lightsOnCount += 1
                    } else {
                        if matrix[neighbour.1][neighbour.0] == "#" {
                            lightsOnCount += 1
                        }
                    }
                } else {
                    if matrix[neighbour.1][neighbour.0] == "#" {
                        lightsOnCount += 1
                    }
                }
            }
        }
        
        return lightsOnCount
    }
    
    static var numberOffOnLights: Int {
        var onLights = 0
        
        for line in matrix {
            onLights += String(line).countInstances(of: "#")
        }
        
        return onLights
    }
    
    static func printMatrix() {
        matrix.forEach { line in
            print(String(line))
        }
    }
}
