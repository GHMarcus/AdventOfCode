//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/14

enum Day_14_2022: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2022
    
    struct Point {
        enum Direction: String {
            case down, left, right
        }

        var x, y: Int
        var nextDirection: Direction
        
        mutating func move() {
            switch nextDirection {
            case .down:
                y += 1
            case .left:
                x -= 1
            case .right:
                x += 1
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        var maxX = 0
        var maxY = 0
        var minX = Int.max
        
        let rocks = convert(input, maxX: &maxX, maxY: &maxY, minX: &minX)

        var map: [[Character]] = []
        map = Array(repeating: Array(repeating: ".", count: maxX+1), count: maxY+1)

        rocks.forEach {
            map[$0.y][$0.x] = "#"
        }

        map[0][500] = "+"

        var openPoints: [Point?] = [Point(x: 500, y: 0, nextDirection: .down)]

        while true {
            let lastOpenPoint = openPoints.popLast() ?? nil
            guard var nextPoint = lastOpenPoint else {
                break
            }

            nextPoint.move()

            if nextPoint.x >= map[0].count || nextPoint.y >= map.count || nextPoint.x < 0 {
                break
            }

            let next = map[nextPoint.y][nextPoint.x]

            if next == "." {
                nextPoint.nextDirection = .down
                openPoints.append(nextPoint)
            } else if next == "#" || next == "o" {
                switch nextPoint.nextDirection {
                case .down:
                    nextPoint.nextDirection = .left
                    openPoints.append(nextPoint)
                case .left:
                    nextPoint.nextDirection = .right
                    nextPoint.x += 1
                    openPoints.append(nextPoint)
                case .right:
                    map[nextPoint.y-1][nextPoint.x-1] = "o"
                    openPoints.append(Point(x: 500, y: 0, nextDirection: .down))
                    continue
                }
            }
        }

        var sand = 0

        for row in map {
            sand += row.countedElements["o"] ?? 0
        }
        
        return "\(sand)"
    }

    static func solvePart2(input: [String]) -> String {
        var maxX = 0
        var maxY = 0
        var minX = Int.max
        
        let rocks = convert(input, maxX: &maxX, maxY: &maxY, minX: &minX)
        
        var map: [[Character]] = []
        map = Array(repeating: Array(repeating: ".", count: maxX+maxX), count: maxY+3)

        rocks.forEach {
            map[$0.y][$0.x] = "#"
        }
        
        for x in 0..<map[0].count {
            map[map.count-1][x] = "#"
        }

        map[0][500] = "+"

        var openPoints: [Point?] = [Point(x: 500, y: 0, nextDirection: .down)]
        var sourceIsFree = true
        while sourceIsFree {
            let lastOpenPoint = openPoints.popLast() ?? nil
            guard var nextPoint = lastOpenPoint else {
                break
            }

            nextPoint.move()

            if nextPoint.x >= map[0].count || nextPoint.y >= map.count || nextPoint.x < 0 {
                openPoints.append(Point(x: 500, y: 0, nextDirection: .down))
                continue
            }

            let next = map[nextPoint.y][nextPoint.x]

            if next == "." {
                nextPoint.nextDirection = .down
                openPoints.append(nextPoint)
            } else if next == "#" || next == "o" {
                switch nextPoint.nextDirection {
                case .down:
                    nextPoint.nextDirection = .left
                    openPoints.append(nextPoint)
                case .left:
                    nextPoint.nextDirection = .right
                    nextPoint.x += 1
                    openPoints.append(nextPoint)
                case .right:
                    map[nextPoint.y-1][nextPoint.x-1] = "o"
                    openPoints.append(Point(x: 500, y: 0, nextDirection: .down))
                    if map[0][500] == "o" {
                        sourceIsFree = false
                    }
                    continue
                }
            }
        }

        var sand = 0

        for row in map {
            sand += row.countedElements["o"] ?? 0
        }

        return "\(sand)"
    }
    
    static func convert(_ input: [String], maxX: inout Int, maxY: inout Int, minX: inout Int) -> [(x: Int, y: Int)] {
        var rocks: [(x: Int, y: Int)] = []
        
        for line in input {
            let cmp = line.components(separatedBy: " -> ")

            var previousX: Int?
            var previousY: Int?

            for c in cmp {
                let coords = c.components(separatedBy: ",").map { Int($0)! }

                if let pX = previousX, let pY = previousY {
                    let currentX = coords[0]
                    let currentY = coords[1]
                    if pX == currentX {
                        let stride = pY < currentY
                        ? pY ... currentY
                        : currentY ... pY
                        for y in stride {
                            rocks.append((currentX, y))
                        }
                    } else if pY == currentY {
                        let stride = pX < currentX
                        ? pX ... currentX
                        : currentX ... pX
                        for x in stride {
                            rocks.append((x, currentY))
                        }
                    }
                    previousX = currentX
                    previousY = currentY
                } else {
                    previousX = coords[0]
                    previousY = coords[1]
                }

                maxY = coords[1] > maxY ? coords[1] : maxY
                maxX = coords[0] > maxX ? coords[0] : maxX
                minX = coords[0] < minX ? coords[0] : minX
            }
        }
        
        return rocks
    }
}
