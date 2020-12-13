//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/12

enum Day_12_2020: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        var computer = FlightComputer(code: input, wayPoint: .no)
        return "\(computer.run())"
    }

    static func solvePart2(input: [String]) -> String {
        var computer = FlightComputer(code: input, wayPoint: .yes)
        return "\(computer.run())"
    }

    enum Direction {
        case east, south, west, north

        mutating func turnLeft(x: Int, y: Int) -> (x: Int, y: Int) {
            let newX = -1 * y
            let newY = x
            switch self {
            case .east:
                self = .north
            case .south:
                self = .east
            case .west:
                self = .south
            case .north:
                self = .west
            }
            return (newX, newY)
        }

        mutating func turnRight(x: Int, y: Int) -> (x: Int, y: Int) {
            let newX = y
            let newY = -1 * x
            switch self {
            case .east:
                self = .south
            case .south:
                self = .west
            case .west:
                self = .north
            case .north:
                self = .east
            }
            return (newX, newY)
        }
    }

    enum WayPoint {
        case no, yes
    }

    struct FlightComputer {
        let code: [String]
        let wayPoint: WayPoint
        var x = 0
        var y = 0
        var direction = Direction.east
        var w_x = 10
        var w_y = 1

        mutating func run() -> Int {
            for instruction in code {
                //print(code[pos])
                let cmp = Array(instruction)
                let command = cmp[0]
                let value = Int(String(cmp.dropFirst())) ?? -1

                guard value != -1 else { fatalError("No Value Found") }
                switch command {
                case "N":
                    switch wayPoint {
                    case .no:
                        y += value
                    case .yes:
                        w_y += value
                    }
                case "S":
                    switch wayPoint {
                    case .no:
                        y -= value
                    case .yes:
                        w_y -= value
                    }
                case "E":
                    switch wayPoint {
                    case .no:
                        x += value
                    case .yes:
                        w_x += value
                    }
                case "W":
                    switch wayPoint {
                    case .no:
                        x -= value
                    case .yes:
                        w_x -= value
                    }
                case "L":
                    let turns: Int = value / 90
                    for _ in 0..<turns {
                        let newWaypoint = direction.turnLeft(x: w_x, y: w_y)
                        w_x = newWaypoint.x
                        w_y = newWaypoint.y
                    }
                case "R":
                    let turns: Int = value / 90
                    for _ in 0..<turns {
                        let newWaypoint = direction.turnRight(x: w_x, y: w_y)
                        w_x = newWaypoint.x
                        w_y = newWaypoint.y
                    }
                case "F":
                    switch wayPoint {
                    case .no:
                        switch direction {
                        case .east:
                            x += value
                        case .south:
                            y -= value
                        case .west:
                            x -= value
                        case .north:
                            y += value
                        }
                    case .yes:
                        x += value * w_x
                        y += value * w_y
                    }


                default:
                    fatalError("Instruction not found")
                }
            }
            return abs(x) + abs(y)
        }
    }
}
