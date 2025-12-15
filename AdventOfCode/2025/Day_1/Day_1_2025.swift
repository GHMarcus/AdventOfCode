//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/1

enum Day_1_2025: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [Rotation]
    
    enum Dir {
        case left, right
    }
    
    struct Rotation {
        let dir: Dir
        let num: Int
    }

    static func convert(input: [String]) -> ConvertedInput {
        var rotations: [Rotation] = []
        for var line in input {
            let dir = line.removeFirst() == "R" ? Dir.right : Dir.left
            let num = Int(line)!
            rotations.append(.init(dir: dir, num: num))
        }
        return rotations
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var dialPos = 50
        var zeroCount = 0
        for rotation in input {
            let actualRotation = rotation.num % 100
            switch rotation.dir {
            case .left:
                let new = dialPos - actualRotation
                if new < 0 {
                    dialPos = 100 - (abs(new % 100))
                } else {
                    dialPos = new
                }
            case .right:
                let new = dialPos + actualRotation
                if new > 99 {
                    dialPos = (new % 100)
                } else {
                    dialPos = new
                }
            }
            if dialPos == 0 {
                zeroCount += 1
            }
        }
        return "\(zeroCount)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var dialPos = 50
        var zeroCount = 0
        for rotation in input {
            let startDialPos = dialPos
            let actualRotation = rotation.num % 100
            zeroCount += rotation.num / 100
            switch rotation.dir {
            case .left:
                let new = dialPos - actualRotation
                if new < 0 {
                    dialPos = 100 - (abs(new % 100))
                    if startDialPos != 0 && dialPos != 0 {
                        zeroCount += 1
                    }
                } else {
                    dialPos = new
                }
            case .right:
                let new = dialPos + actualRotation
                if new > 99 {
                    dialPos = (new % 100)
                    if startDialPos != 0 && dialPos != 0 {
                        zeroCount += 1
                    }
                } else {
                    dialPos = new
                }
            }
            if dialPos == 0 {
                zeroCount += 1
            }
        }
        return "\(zeroCount)"

    }
}
