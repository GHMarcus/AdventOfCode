//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/5

enum Day_5_2021: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2021

    struct Point {
        let x: Int
        let y: Int
    }

    struct Line {
        let start: Point
        let end: Point
    }

    static func solvePart1(input: [String]) -> String {
        var lines: [Line] = []
        var maxX = 0
        var maxY = 0

        for line in input {
            let comps = line.components(separatedBy: " ")
            let start = comps[0].components(separatedBy: ",")
            let end = comps[2].components(separatedBy: ",")
            let startPoint = Point(x: Int(start[0])!, y: Int(start[1])!)
            let endPoint = Point(x: Int(end[0])!, y: Int(end[1])!)

            maxX = max(maxX, max(startPoint.x, endPoint.x))
            maxY = max(maxY, max(startPoint.y, endPoint.y))

            if startPoint.x == endPoint.x || startPoint.y == endPoint.y {
                lines.append(Line(start: startPoint, end: endPoint))
            }
        }

        var field = Array(repeating: Array(repeating: 0, count: maxX+1), count: maxY+1)

        for line in lines {
            if line.start.x == line.end.x {
                if line.start.y <= line.end.y {
                    for i in line.start.y...line.end.y {
                        field[i][line.start.x] += 1
                    }
                } else {
                    for i in line.end.y...line.start.y {
                        field[i][line.start.x] += 1
                    }
                }
            } else {
                if line.start.x <= line.end.x {
                    for i in line.start.x...line.end.x {
                        field[line.start.y][i] += 1
                    }
                } else {
                    for i in line.end.x...line.start.x {
                        field[line.start.y][i] += 1
                    }
                }
            }
        }

        var number = 0

        for row in field {
            for n in row {
                if n >= 2 {
                    number += 1
                }
            }
        }

        return "\(number)"
    }

    static func solvePart2(input: [String]) -> String {
        var lines: [Line] = []
        var diagonals: [Line] = []
        var maxX = 0
        var maxY = 0

        for line in input {
            let comps = line.components(separatedBy: " ")
            let start = comps[0].components(separatedBy: ",")
            let end = comps[2].components(separatedBy: ",")
            let startPoint = Point(x: Int(start[0])!, y: Int(start[1])!)
            let endPoint = Point(x: Int(end[0])!, y: Int(end[1])!)

            maxX = max(maxX, max(startPoint.x, endPoint.x))
            maxY = max(maxY, max(startPoint.y, endPoint.y))

            if startPoint.x == endPoint.x || startPoint.y == endPoint.y {
                lines.append(Line(start: startPoint, end: endPoint))
            } else {
                diagonals.append(Line(start: startPoint, end: endPoint))
            }
        }

        var field = Array(repeating: Array(repeating: 0, count: maxX+1), count: maxY+1)

        for line in lines {
            if line.start.x == line.end.x {
                if line.start.y <= line.end.y {
                    for i in line.start.y...line.end.y {
                        field[i][line.start.x] += 1
                    }
                } else {
                    for i in line.end.y...line.start.y {
                        field[i][line.start.x] += 1
                    }
                }
            } else {
                if line.start.x <= line.end.x {
                    for i in line.start.x...line.end.x {
                        field[line.start.y][i] += 1
                    }
                } else {
                    for i in line.end.x...line.start.x {
                        field[line.start.y][i] += 1
                    }
                }
            }
        }

        for diagonal in diagonals {
            let distance = abs(diagonal.start.x - diagonal.end.x)

            if diagonal.start.x < diagonal.end.x {
                if diagonal.start.y <= diagonal.end.y {
                    for i in 0...distance {
                        field[diagonal.start.y+i][diagonal.start.x+i] += 1
                    }
                } else {
                    for i in 0...distance {
                        field[diagonal.start.y-i][diagonal.start.x+i] += 1
                    }
                }
            } else {
                if diagonal.start.y <= diagonal.end.y {
                    for i in 0...distance {
                        field[diagonal.start.y+i][diagonal.start.x-i] += 1
                    }
                } else {
                    for i in 0...distance {
                        field[diagonal.start.y-i][diagonal.start.x-i] += 1
                    }
                }
            }
        }

        var number = 0

        for row in field {
            for n in row {
                if n >= 2 {
                    number += 1
                }
            }
        }

        return "\(number)"
    }
}
