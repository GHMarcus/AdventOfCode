//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/22

enum Day_22_2022: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2022

    struct Position {
        var x,y,area: Int
    }

    struct Command {
        let distance: Int
        let turn: Character

        func nextDirection(for current: Direction) -> Direction {
            switch turn {
            case "R":
                switch current {
                case .right:
                    return .down
                case .down:
                    return .left
                case .left:
                    return .up
                case .up:
                    return .right
                }
            case "L":
                switch current {
                case .right:
                    return .up
                case .down:
                    return .right
                case .left:
                    return .down
                case .up:
                    return .left
                }
            default:
                return current
            }
        }
    }

    enum Direction: Int {
        case right = 0, down = 1, left = 2, up = 3

        func move(pos: Position) -> Position {
            switch self {
            case .right:
                return Position(x: pos.x+1, y: pos.y, area: pos.area)
            case .down:
                return Position(x: pos.x, y: pos.y+1, area: pos.area)
            case .left:
                return Position(x: pos.x-1, y: pos.y, area: pos.area)
            case .up:
                return Position(x: pos.x, y: pos.y-1, area: pos.area)
            }
        }

        func nextArea(for area: Int) -> (Int,Direction) {
            nextAreas[area][rawValue]
        }

        func changeDirection(for direction: Direction) -> Direction {
            switch direction {
            case .right:
                return .left
            case .down:
                return .up
            case .left:
                return .right
            case .up:
                return .down
            }
        }

        mutating func getPosInNextArea(_ nextArea: (Int,Direction), for pos: Position) -> Position {
            var nextPos = pos

            let oldArea = areas[pos.area]
            let newArea = areas[nextArea.0]

            let dx = pos.x - oldArea.xRange.lowerBound
            let dy = pos.y - oldArea.yRange.lowerBound

            switch self {
            case .right:
                switch nextArea.1 {
                case .right:
                    nextPos.x = newArea.xRange.upperBound
                    nextPos.y = newArea.yRange.upperBound - dy
                case .down:
                    nextPos.x = newArea.xRange.lowerBound + dy
                    nextPos.y = newArea.yRange.upperBound
                case .left:
                    nextPos.x = newArea.xRange.lowerBound
                    nextPos.y = newArea.yRange.lowerBound + dy
                case .up:
                    nextPos.x = newArea.xRange.upperBound - dy
                    nextPos.y = newArea.yRange.lowerBound
                }
            case .down:
                switch nextArea.1 {
                case .right:
                    nextPos.x = newArea.xRange.upperBound
                    nextPos.y = newArea.yRange.lowerBound + dx
                case .down:
                    nextPos.x = newArea.xRange.upperBound - dx
                    nextPos.y = newArea.yRange.upperBound
                case .left:
                    nextPos.x = newArea.xRange.lowerBound
                    nextPos.y = newArea.yRange.lowerBound + dx
                case .up:
                    nextPos.x = newArea.xRange.lowerBound + dx
                    nextPos.y = newArea.yRange.lowerBound
                }
            case .left:
                switch nextArea.1 {
                case .right:
                    nextPos.x = newArea.xRange.upperBound
                    nextPos.y = newArea.yRange.lowerBound + dy
                case .down:
                    nextPos.x = newArea.xRange.upperBound - dy
                    nextPos.y = newArea.yRange.upperBound
                case .left:
                    nextPos.x = newArea.xRange.lowerBound
                    nextPos.y = newArea.yRange.upperBound - dy
                case .up:
                    nextPos.x = newArea.xRange.lowerBound + dy
                    nextPos.y = newArea.yRange.lowerBound
                }
            case .up:
                switch nextArea.1 {
                case .right:
                    nextPos.x = newArea.xRange.upperBound
                    nextPos.y = newArea.yRange.upperBound - dx
                case .down:
                    nextPos.x = newArea.xRange.lowerBound + dx
                    nextPos.y = newArea.yRange.upperBound
                case .left:
                    nextPos.x = newArea.xRange.lowerBound
                    nextPos.y = newArea.yRange.lowerBound + dx
                case .up:
                    nextPos.x = newArea.xRange.upperBound - dx
                    nextPos.y = newArea.yRange.lowerBound
                }
            }

            nextPos.area = nextArea.0
            return nextPos
        }
    }

    static func solvePart1(input: [String]) -> String {
        var map: [[String]] = []
        var commands: [Command] = []

        for line in input {
            if line.isEmpty {
                break
            }
            map.append(Array(line).map{String($0)})
        }
        let maxLineLength = map.map { $0.count }.max()!

        // fill non existing coords with empty strings
        for line in 0..<map.count {
            if map[line].count < maxLineLength {
                let addArray = Array(repeating: " ", count: maxLineLength - map[line].count)
                map[line].append(contentsOf: addArray)
            }
        }

        var str = ""
        for c in Array(input.last!) {
            if Character.completeAlphabetValue.keys.contains(c) {
                commands.append(Command(distance: Int(str)!, turn: c))
                str = ""
            } else {
                str.append(c)
            }
        }
        commands.append(Command(distance: Int(str)!, turn: "-"))

        var currentDirection = Direction.right
        var currentPos = Position(x: Int(map[0].firstIndex(of: ".")!), y: 0, area: 0)
        
        for command in commands {
            for _ in 1...command.distance {
                let nextPos = part1GetNextPos(for: currentPos, with: currentDirection, in: map)

                if map[nextPos.y][nextPos.x] == "#" {
                    break
                }

                switch currentDirection {
                case .right:
                    map[nextPos.y][nextPos.x] = ">"
                case .down:
                    map[nextPos.y][nextPos.x] = "v"
                case .left:
                    map[nextPos.y][nextPos.x] = "<"
                case .up:
                    map[nextPos.y][nextPos.x] = "^"
                }

                currentPos = nextPos
            }

            currentDirection = command.nextDirection(for: currentDirection)
        }

        return "\(1000*(currentPos.y+1)+4*(currentPos.x+1)+currentDirection.rawValue)"
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[String]] = []
        var commands: [Command] = []

        for line in input {
            if line.isEmpty {
                break
            }
            map.append(Array(line).map{String($0)})
        }

        var str = ""
        for c in Array(input.last!) {
            if Character.completeAlphabetValue.keys.contains(c) {
                commands.append(Command(distance: Int(str)!, turn: c))
                str = ""
            } else {
                str.append(c)
            }
        }
        commands.append(Command(distance: Int(str)!, turn: "-"))

        var currentDirection = Direction.right
        var currentPos = Position(x: Int(map[0].firstIndex(of: ".")!), y: 0, area: 0)

        for command in commands {
            for _ in 1...command.distance {
                let result = part2GetNextPos(for: currentPos, with: &currentDirection, in: map)
                let nextPos = result.0

                if map[nextPos.y][nextPos.x] == "#" {
                    break
                }

                if nextPos.area != currentPos.area {
                    currentDirection = currentDirection.changeDirection(for: result.1)
                }

                if map[nextPos.y][nextPos.x] == "#" {
                    break
                }

                switch currentDirection {
                case .right:
                    map[nextPos.y][nextPos.x] = ">"
                case .down:
                    map[nextPos.y][nextPos.x] = "v"
                case .left:
                    map[nextPos.y][nextPos.x] = "<"
                case .up:
                    map[nextPos.y][nextPos.x] = "^"
                }

                currentPos = nextPos
            }
            currentDirection = command.nextDirection(for: currentDirection)
        }

        return "\(1000*(currentPos.y+1)+4*(currentPos.x+1)+currentDirection.rawValue)"
    }

    static func part1GetNextPos(for pos: Position, with currentDirection: Direction, in map: [[String]]) -> Position {
        var nextPos = pos

        nextPos = currentDirection.move(pos: nextPos)

        if nextPos.y >= map.count {
            nextPos.y = 0
        }

        if nextPos.y < 0 {
            nextPos.y = map.count - 1
        }

        if nextPos.x >= map[nextPos.y].count {
            nextPos.x = 0
        }

        if nextPos.x < 0 {
            nextPos.x = map[nextPos.y].count - 1
        }


        var next = map[nextPos.y][nextPos.x]

        if next == " " {
            while true {

                nextPos = currentDirection.move(pos: nextPos)

                if nextPos.y >= map.count {
                    nextPos.y = 0
                }

                if nextPos.y < 0 {
                    nextPos.y = map.count - 1
                }

                if nextPos.x >= map[nextPos.y].count {
                    nextPos.x = 0
                }

                if nextPos.x < 0 {
                    nextPos.x = map[nextPos.y].count - 1
                }

                if map[nextPos.y][nextPos.x] != " " {
                    next = map[nextPos.y][nextPos.x]
                    break
                }
            }
        }

        return nextPos
    }
    // Example cube
//    static let areas = [
//        (xRange: 8...11, yRange: 0...3),
//        (xRange: 0...3, yRange: 4...7),
//        (xRange: 4...7, yRange: 4...7),
//        (xRange: 8...11, yRange: 4...7),
//        (xRange: 8...11, yRange: 8...11),
//        (xRange: 12...15, yRange: 8...11)
//    ]
//
//    // case right = 0, down = 1, left = 2, up = 3
//    static let nextAreas: [[(Int,Direction)]] = [
//        [(5,.left),(3,.up),(2,.up),(1,.up)],
//        [(2,.left),(4,.down),(5,.down),(0,.up)],
//        [(3,.left),(4,.left),(1,.right),(0,.left)],
//        [(5,.up),(4,.up),(2,.right),(0,.down)],
//        [(5,.left),(1,.down),(2,.down),(3,.down)],
//        [(0,.right),(1,.left),(4,.right),(3,.right)]
//    ]

    // Note: This is done visually and will not work with (any) other inputs. If you want to test your input you have to change the static lets `areas` and `nextAreas`
    // Right now I don't have any clue how I will do the cube folding (`nextAreas`) with code
    // If someone can explain me this, feel free to contact me :)
    
    // Real cube
    static let areas = [
        (xRange: 50...99, yRange: 0...49),
        (xRange: 100...149, yRange: 0...49),
        (xRange: 50...99, yRange: 50...99),
        (xRange: 0...49, yRange: 100...149),
        (xRange: 50...99, yRange: 100...149),
        (xRange: 0...49, yRange: 150...199)
    ]

    // case right = 0, down = 1, left = 2, up = 3
    static let nextAreas: [[(Int,Direction)]] = [
        [(1,.left),(2,.up),(3,.left),(5,.left)],
        [(4,.right),(2,.right),(0,.right),(5,.down)],
        [(1,.down),(4,.up),(3,.up),(0,.down)],
        [(4,.left),(5,.up),(0,.left),(2,.left)],
        [(1,.right),(5,.right),(3,.right),(2,.down)],
        [(4,.down),(1,.up),(0,.up),(3,.down)]
    ]

    static func part2GetNextPos(for pos: Position, with currentDirection: inout Direction, in map: [[String]]) -> (Position, Direction) {
        var nextPos = pos
        var nextAreaDirection = currentDirection

        nextPos = currentDirection.move(pos: nextPos)
        let currentArea = areas[pos.area]
        if !currentArea.xRange.contains(nextPos.x) || !currentArea.yRange.contains(nextPos.y) {
            let nextArea = currentDirection.nextArea(for: pos.area)
            nextPos = currentDirection.getPosInNextArea(nextArea, for: pos)
            nextAreaDirection = nextArea.1
        }

        return (nextPos, nextAreaDirection)
    }
}
