//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/7

enum Day_7_2025: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = (beam: Pos, splitters: Set<Pos>, maxY: Int, xCount: Int)

    struct Pos: Hashable {
        let x, y: Int
    }

    static func convert(input: [String]) -> ConvertedInput {
        var start: Pos!
        var splitters: Set<Pos> = []
        
        for (y, line) in input.enumerated() {
            for (x, c) in line.enumerated() {
                if c == "S" {
                    start = Pos(x: x, y: y)
                } else if c == "^" {
                    splitters.insert(Pos(x: x, y: y))
                }
            }
        }

        return (start, splitters, input.count - 1, input[0].count)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var beams: Set<Pos> = [input.beam]
        var splits = 0
        while !beams.isEmpty {
            var newBeams: Set<Pos> = []
            beams.forEach {
                let newPos = Pos(x: $0.x, y: $0.y + 1)
                if newPos.y <= input.maxY {
                    newBeams.insert(newPos)
                }
            }
            var resultingBeams: Set<Pos> = []
            for beam in newBeams {
                if input.splitters.contains(beam) {
                    splits += 1
                    resultingBeams.insert(Pos(x: beam.x - 1, y: beam.y))
                    resultingBeams.insert(Pos(x: beam.x + 1, y: beam.y))
                } else {
                    resultingBeams.insert(beam)
                }
            }
            beams = resultingBeams
        }
        return "\(splits)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var prevBeams = Array(repeating: 0, count: input.xCount)
        prevBeams[input.beam.x] = 1

        for y in 1..<input.maxY {
            var newBeams = Array(repeating: 0, count: input.xCount)
            for x in 0..<input.xCount {
                if input.splitters.contains(Pos(x: x, y: y)) {
                    if prevBeams[x] > 0 {
                        newBeams[x - 1] += prevBeams[x]
                        newBeams[x + 1] += prevBeams[x]
                    }
                } else {
                    newBeams[x] += prevBeams[x]
                }
            }
            prevBeams = newBeams
        }

        let timelines = prevBeams.reduce(0, +)
        return "\(timelines)"
    }
}
