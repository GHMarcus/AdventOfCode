//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/2

enum Day_2_2022: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2022

    enum Kind: Int {
        case rock = 1
        case paper = 2
        case scissor = 3

        init(instruction: String) {
            switch instruction {
            case "A", "X":
                self = .rock
            case "B", "Y":
                self = .paper
            case "C", "Z":
                self = .scissor
            default:
                fatalError()
            }
        }

        init(instruction: String, other: Kind) {
            switch instruction {
            case "X":
                switch other {
                case .rock:
                    self = .scissor
                case .paper:
                    self = .rock
                case .scissor:
                    self = .paper
                }
            case "Y":
                self = other
            case "Z":
                switch other {
                case .rock:
                    self = .paper
                case .paper:
                    self = .scissor
                case .scissor:
                    self = .rock
                }
            default:
                fatalError()
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        let instructions = input.map { $0.components(separatedBy: " ") }
        var score = 0

        for line in instructions {
            let p1 = Kind(instruction: line.first!)
            let p2 = Kind(instruction: line.last!)

            score += playRound(p1, p2)
        }

        return "\(score)"
    }

    static func solvePart2(input: [String]) -> String {
        let instructions = input.map { $0.components(separatedBy: " ") }
        var score = 0

        for line in instructions {

            let p1 = Kind(instruction: line.first!)
            let p2 = Kind(instruction: line.last!, other: p1)

            score += playRound(p1, p2)
        }

        return "\(score)"
    }

    private static func playRound(_ p1: Kind, _ p2: Kind) -> Int {
        var score = 0

        if p1 == p2 {
            score += 3 + p2.rawValue
        } else {
            switch (p1, p2) {
            case (.rock, .paper):
                score += 6
            case (.rock, .scissor):
                score += 0
            case (.paper, .rock):
                score += 0
            case (.paper, .scissor):
                score += 6
            case (.scissor, .rock):
                score += 6
            case (.scissor, .paper):
                score += 0
            default:
                fatalError()
            }
            score += p2.rawValue
        }

        return score
    }
}
