//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/11

enum Day_11_2018: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2018
    
    static var grid: [[Int]] = []

    static func solvePart1(input: [String]) -> String {
        let serialNumber = Int(input.first!)!
        
        grid = Array(repeating: Array(repeating: 0, count: 300), count: 300)
        
        for y in 0..<300 {
            for x in 0..<300 {
                /*
                 For example, to find the power level of the fuel cell at 3,5 in a grid with serial number 8:

                 The rack ID is 3 + 10 = 13.
                 The power level starts at 13 * 5 = 65.
                 Adding the serial number produces 65 + 8 = 73.
                 Multiplying by the rack ID produces 73 * 13 = 949.
                 The hundreds digit of 949 is 9.
                 Subtracting 5 produces 9 - 5 = 4.
                 */
                
                let rackId = x+1 + 10
                let start = rackId * (y+1)
                let addSerialNumber = start + serialNumber
                let multiWithRackId = addSerialNumber * rackId
                
                let hundret = multiWithRackId % 1000 / 100
                let powerLevel = hundret - 5
                
                grid[y][x] = powerLevel
            }
        }
        
        let size = 3
        var maxSum = 0
        var maxSumPoint = (0,0)
        
        for y in 0..<300 {
            for x in 0..<300 {
                let newSum = sumOfNeighbours(x: x, y: y, size: size)
                if newSum > maxSum {
                    maxSum = newSum
                    maxSumPoint = (x,y)
                }
            }
        }

        return "\(maxSumPoint.0+1),\(maxSumPoint.1+1)"
    }

    // Use speed optimization -> average time ~46 sec
    static func solvePart2(input: [String]) -> String {
        var maxSum = 0
        var maxSumPoint = (0,0)
        var maxSize = 0
        
        for size in 1...300 {
            print("\(Int(Double(size)/300.0*100)) %")
            for y in 0..<300 {
                for x in 0..<300 {
                    let newSum = sumOfNeighbours(x: x, y: y, size: size)
                    if newSum > maxSum {
                        maxSum = newSum
                        maxSumPoint = (x,y)
                        maxSize = size
                    }
                }
            }
        }

        return "\(maxSumPoint.0+1),\(maxSumPoint.1+1),\(maxSize)"
    }
    
    static func sumOfNeighbours(x: Int, y: Int, size: Int) -> Int {
            var sum = 0
            if (x + size) <= grid[0].count, (y + size) <= grid.count {
                for yOffset in 0..<size {
                    for xOffset in 0..<size {
                        sum += grid[y+yOffset][x+xOffset]
                    }
                }
            }
        
            return sum
    }
    
}
