//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/11

enum Day_11_2023: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2023
    
    struct Pos: Equatable, Hashable {
        var x, y: Int
    }
    
    static func convert(input: [String]) -> (part1: [Pos], part2: [Pos]) {
        let map: [[Character]] = input.map { Array($0) }
        
        var galaxiesPart1 = findGalaxies(in: map)
        var galaxiesPart2 = galaxiesPart1
        
        let factorPart1 = 1
        let factorPart2 = 999999
        var adds = 0
        
        for (index, line) in input.enumerated() {
            if !line.contains("#") {
                galaxiesPart1 = galaxiesPart1.map {
                    if $0.y - adds * factorPart1 > index {
                        return Pos(x: $0.x, y: ($0.y + factorPart1))
                    } else {
                        return $0
                    }
                }
                galaxiesPart2 = galaxiesPart2.map {
                    if $0.y - adds * factorPart2 > index {
                        return Pos(x: $0.x, y: ($0.y + factorPart2))
                    } else {
                        return $0
                    }
                }
                adds += 1
            }
        }
        
        adds = 0
        for (index, line) in rotateRight(map).enumerated() {
            if !line.contains("#") {
                galaxiesPart1 = galaxiesPart1.map {
                    if $0.x - adds * factorPart1 > index {
                        return Pos(x: ($0.x + factorPart1), y: $0.y)
                    } else {
                        return $0
                    }
                }
                galaxiesPart2 = galaxiesPart2.map {
                    if $0.x - adds * factorPart2 > index {
                        return Pos(x: ($0.x + factorPart2), y: $0.y)
                    } else {
                        return $0
                    }
                }
                adds += 1
            }
        }
        
        return (galaxiesPart1, galaxiesPart2)
    }

    static func solvePart1(input: (part1: [Pos], part2: [Pos])) -> String {
        var pairs: Set<Set<Pos>> = []
        
        for galaxy in input.part1 {
            for galaxy2 in input.part1 {
                if galaxy == galaxy2 {
                    continue
                }
                pairs.insert(Set([galaxy, galaxy2]))
            }
        }
        
        let sum = pairs.reduce(0) { $0 + manhattanDistance(pair: $1) }
        
        return "\(sum)"
    }

    static func solvePart2(input: (part1: [Pos], part2: [Pos])) -> String {
        var pairs: Set<Set<Pos>> = []
        
        for galaxy in input.part2 {
            for galaxy2 in input.part2 {
                if galaxy == galaxy2 {
                    continue
                }
                pairs.insert(Set([galaxy, galaxy2]))
            }
        }
        
        let sum = pairs.reduce(0) { $0 + manhattanDistance(pair: $1) }
        
        return "\(sum)"
    }
    
    static func findGalaxies(in map: [[Character]]) -> [Pos] {
        
        var positions: [Pos] = []
        
        for (y, line) in map.enumerated() {
            for (x, c) in line.enumerated() {
                if c == "#" {
                    positions.append(Pos(x: x, y: y))
                }
            }
        }
        
        return positions
    }
    
    static func manhattanDistance(pair: Set<Pos>) -> Int {
        var pair = pair
        let left = pair.removeFirst()
        let right = pair.removeFirst()
        
        return abs(left.x - right.x) + abs(left.y - right.y)
    }
}
