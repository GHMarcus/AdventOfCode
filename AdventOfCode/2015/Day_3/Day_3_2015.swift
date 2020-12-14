//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/3

enum Day_3_2015: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2015

    struct Pos: Hashable {
        let x: Int
        let y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }

    static func solvePart1(input: [String]) -> String {
        var x = 0
        var y = 0
        var visitedHouses: Set<Pos> = [Pos(x, y)]
        let instructions = Array(input[0])
        for instruction in instructions {
            switch instruction {
            case "^":
                y += 1
            case "v":
                y -= 1
            case ">":
                x += 1
            case "<":
                x -= 1
            default:
                break
            }
            visitedHouses.insert(Pos(x, y))
        }
        return "\(visitedHouses.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var x_Santa = 0
        var y_Santa = 0
        var x_Robo = 0
        var y_Robo = 0
        var visitedHouses: Set<Pos> = [Pos(x_Santa, y_Santa)]
        let instructions = Array(input[0])
        var isSanta = true
        for instruction in instructions {
            switch instruction {
            case "^":
                isSanta ? (y_Santa += 1) : (y_Robo += 1)
            case "v":
                isSanta ? (y_Santa -= 1) : (y_Robo -= 1)
            case ">":
                isSanta ? (x_Santa += 1) : (x_Robo += 1)
            case "<":
                isSanta ? (x_Santa -= 1) : (x_Robo -= 1)
            default:
                break
            }
            let pos = isSanta ? Pos(x_Santa, y_Santa) : Pos(x_Robo, y_Robo)
            visitedHouses.insert(pos)
            isSanta.toggle()
        }
        return "\(visitedHouses.count)"
    }
}
