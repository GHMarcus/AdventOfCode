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

    static func solvePart1(input: [String]) -> String {
        var map: [[Character]] = []
        var rocks: [(x: Int, y: Int)] = []

        var maxX = 0
        var maxY = 0

        var minX = Int.max

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


        map = Array(repeating: Array(repeating: ".", count: maxX+1), count: maxY+1)

        rocks.forEach {
            map[$0.y][$0.x] = "#"
        }

        map[0][500] = "+"

        var round = 0



        struct Point {
            enum Direction: String {
                case down, left, right
            }

            var x, y: Int
            var nextDirection: Direction

            func pr() -> String {
                "x:\(x), y:\(y), next:\(nextDirection.rawValue)"
            }
        }

        var openPoints: [Point?] = [Point(x: 500, y: 0, nextDirection: .down)]

        print(maxY)

        while true { //round < 1000 {
            let lastOpenPoint = openPoints.popLast() ?? nil
            guard var nextPoint = lastOpenPoint else {
                print("lastOne \(round)")
                break
            }

            switch nextPoint.nextDirection {
            case .down:
                nextPoint.y += 1
            case .left:
                nextPoint.x -= 1
            case .right:
                nextPoint.x += 1
            }

            if nextPoint.x >= map[0].count || nextPoint.y >= map.count || nextPoint.x < 0 {
                break
            }

            let next = map[nextPoint.y][nextPoint.x]

            if next == "." {
//                print("\(nextPoint.pr()) -> \(next) -> 1")
                nextPoint.nextDirection = .down
                openPoints.append(nextPoint)
            } else if next == "#" || next == "o" {
                switch nextPoint.nextDirection {
                case .down:
//                    print("\(nextPoint.pr()) -> \(next) -> 2")
                    nextPoint.nextDirection = .left
                    openPoints.append(nextPoint)
                case .left:
//                    print("\(nextPoint.pr()) -> \(next) -> 3")
                    nextPoint.nextDirection = .right
                    nextPoint.x += 1
                    openPoints.append(nextPoint)
                case .right:
//                    print("\(nextPoint.pr()) -> \(next) -> 4")
                    map[nextPoint.y-1][nextPoint.x-1] = "o"
                    openPoints.append(Point(x: 500, y: 0, nextDirection: .down))
                    continue
                }
            }

            round += 1

//            for y in 0...(maxY+1) {
//                var str = ""
//                for x in (minX-1)...(maxX+1) {
//
//                    if x == nextPoint.x && y == nextPoint.y {
//                        str.append("o")
//                    } else {
//                        str.append(map[y][x])
//                    }
//                }
//                print(str)
//            }
//            print("---------------------------")
        }

        var sand = 0

        for row in map {
            sand += row.countedElements["o"] ?? 0
        }


        return "\(sand)"
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[Character]] = []
        var rocks: [(x: Int, y: Int)] = []

        var maxX = 0
        var maxY = 0

        var minX = Int.max

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


        map = Array(repeating: Array(repeating: ".", count: maxX+maxX), count: maxY+3)

        rocks.forEach {
            map[$0.y][$0.x] = "#"
        }

        map[0][500] = "+"

        var round = 0



        struct Point {
            enum Direction: String {
                case down, left, right
            }

            var x, y: Int
            var nextDirection: Direction

            func pr() -> String {
                "x:\(x), y:\(y), next:\(nextDirection.rawValue)"
            }
        }

        var openPoints: [Point?] = [Point(x: 500, y: 0, nextDirection: .down)]
        var sourceIsFree = true
//        while sourceIsFree { //round < 1000 {
        while round < 1000 {
            let lastOpenPoint = openPoints.popLast() ?? nil
            guard var nextPoint = lastOpenPoint else {
                print("lastOne \(round)")
                break
            }

            switch nextPoint.nextDirection {
            case .down:
                nextPoint.y += 1
            case .left:
                nextPoint.x -= 1
            case .right:
                nextPoint.x += 1
            }

            if nextPoint.x >= map[0].count || nextPoint.y >= map.count || nextPoint.x < 0 {
                openPoints.append(Point(x: 500, y: 0, nextDirection: .down))
                continue
            }

            let next = map[nextPoint.y][nextPoint.x]

            if next == "." {
//                print("\(nextPoint.pr()) -> \(next) -> 1")
                nextPoint.nextDirection = .down
                openPoints.append(nextPoint)
            } else if next == "#" || next == "o" {
                switch nextPoint.nextDirection {
                case .down:
//                    print("\(nextPoint.pr()) -> \(next) -> 2")
                    nextPoint.nextDirection = .left
                    openPoints.append(nextPoint)
                case .left:
//                    print("\(nextPoint.pr()) -> \(next) -> 3")
                    nextPoint.nextDirection = .right
                    nextPoint.x += 1
                    openPoints.append(nextPoint)
                case .right:
//                    print("\(nextPoint.pr()) -> \(next) -> 4")
                    map[nextPoint.y-1][nextPoint.x-1] = "o"
                    openPoints.append(Point(x: 500, y: 0, nextDirection: .down))
                    if nextPoint.x == 500, nextPoint.y == 0 {
                        sourceIsFree = false
                    }
                    continue
                }
            }

            round += 1

            for y in 0...(maxY) {
                var str = ""
                for x in (minX-1)...(maxX) {

                    if x == nextPoint.x && y == nextPoint.y {
                        str.append("o")
                    } else {
                        str.append(map[y][x])
                    }
                }
                print(str)
            }
            print("---------------------------")
        }

        var sand = 0

        for row in map {
            sand += row.countedElements["o"] ?? 0
        }


        return "\(sand)"
    }
}
