//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/4

enum Day_4_2024: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2024

    static func getXMASPositonsFor(x: Int, y: Int, maxX: Int, maxY: Int) -> [[(x: Int, y: Int)]] {
        [
           [(x,y), (x,y+1), (x,y+2), (x,y+3)],
           [(x,y), (x,y-1), (x,y-2), (x,y-3)],
           [(x,y), (x+1,y), (x+2,y), (x+3,y)],
           [(x,y), (x-1,y), (x-2,y), (x-3,y)],
           
           [(x,y), (x+1,y+1), (x+2,y+2), (x+3,y+3)],
           [(x,y), (x+1,y-1), (x+2,y-2), (x+3,y-3)],
           [(x,y), (x-1,y-1), (x-2,y-2), (x-3,y-3)],
           [(x,y), (x-1,y+1), (x-2,y+2), (x-3,y+3)],
        ].filter {
            $0.allSatisfy { (x: Int, y: Int) in
                x >= 0 && y >= 0 && x < maxX && y < maxY
            }
        }
    }
    
    static func getMASPositonsFor(x: Int, y: Int, maxX: Int, maxY: Int) -> [([(x: Int, y: Int)], [(x: Int, y: Int)])] {
        [
           ([(x-1,y-1),(x,y),(x+1,y+1)],[(x+1,y-1),(x,y),(x-1,y+1)]),
           ([(x-1,y-1),(x,y),(x+1,y+1)],[(x-1,y+1),(x,y),(x+1,y-1)]),
           
           ([(x+1,y+1),(x,y),(x-1,y-1)],[(x+1,y-1),(x,y),(x-1,y+1)]),
           ([(x+1,y+1),(x,y),(x-1,y-1)],[(x-1,y+1),(x,y),(x+1,y-1)]),
        ].filter {
            $0.0.allSatisfy { (x: Int, y: Int) in
                x >= 0 && y >= 0 && x < maxX && y < maxY
            } &&
            $0.1.allSatisfy{ (x: Int, y: Int) in
                x >= 0 && y >= 0 && x < maxX && y < maxY
            }
        }
    }
    
    static func convert(input: [String]) -> [[Character]] {
        var map: [[Character]] = []
        for line in input {
            map.append(Array(line))
        }
        return map
    }

    static func solvePart1(input: [[Character]]) -> String {
        var wordsFound = 0
        
        for y in 0..<input.count {
            for x in 0..<input[0].count {
                if input[y][x] == "X" {
                    let possibleWords = getXMASPositonsFor(x: x, y: y, maxX: input[0].count, maxY: input.count)
                    for wordPositions in possibleWords {
                        let word = "\(input[wordPositions[0].y][wordPositions[0].x])"
                        + "\(input[wordPositions[1].y][wordPositions[1].x])"
                        + "\(input[wordPositions[2].y][wordPositions[2].x])"
                        + "\(input[wordPositions[3].y][wordPositions[3].x])"
                        
                        if word == "XMAS" {
                            wordsFound += 1
                        }
                    }
                }
            }
        }
        return "\(wordsFound)"
    }

    static func solvePart2(input: [[Character]]) -> String {
        var xMasFounds = 0
        
        for y in 0..<input.count {
            for x in 0..<input[0].count {
                if input[y][x] == "A" {
                    let possibleWords = getMASPositonsFor(x: x, y: y, maxX: input[0].count, maxY: input.count)
                    for wordPositions in possibleWords {
                        let mas1 = "\(input[wordPositions.0[0].y][wordPositions.0[0].x])"
                        + "\(input[wordPositions.0[1].y][wordPositions.0[1].x])"
                        + "\(input[wordPositions.0[2].y][wordPositions.0[2].x])"
                        
                        let mas2 = "\(input[wordPositions.1[0].y][wordPositions.1[0].x])"
                        + "\(input[wordPositions.1[1].y][wordPositions.1[1].x])"
                        + "\(input[wordPositions.1[2].y][wordPositions.1[2].x])"
                        
                        if mas1 == "MAS" && mas2 == "MAS" {
                            xMasFounds += 1
                            break
                        }
                    }
                }
            }
        }
        return "\(xMasFounds)"
    }
}







//(19-x)*(b-1) = (13-y)*(a+2)
//(19-x)*(c+2) = (30-z)*(a+2)
//(18-x)*(b+1) = (19-y)*(a+1)
//(18-x)*(c+2) = (22-z)*(a+1)
//(20-x)*(b+1) = (25-y)*(a+2)
//(20-x)*(c+4) = (34-z)*(a+2)
