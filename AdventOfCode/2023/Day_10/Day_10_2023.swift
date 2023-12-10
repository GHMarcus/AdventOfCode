//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/10

enum Day_10_2023: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2023
    
    struct Pos: Hashable {
        let x,y: Int
        
        var neighboursWithKind: [Pos: [Pipe.Kind]] {
            [
                Pos(x: x + 1, y: y): [.westToEast, .southToWest, .northToWest],
                Pos(x: x - 1, y: y): [.westToEast, .southToEast, .northToEast],
                Pos(x: x, y: y + 1): [.northToSouth, .northToWest, .northToEast],
                Pos(x: x, y: y - 1): [.northToSouth, .southToEast, .southToWest]
            ]
        }
        
        var allNeighboursToLeftEdge: Set<Pos> {
            Set((0..<x).map { Pos(x: $0, y: y)})
        }
    }
    
    struct Pipe: Hashable {
        enum Kind: Character, Hashable {
            case northToSouth = "|"
            case westToEast = "-"
            case northToWest = "J"
            case northToEast = "L"
            case southToWest = "7"
            case southToEast = "F"
        }
        
        let pos: Pos
        let kind: Kind
        
        func nextPos(previous: Pos) -> Pos {
            switch kind {
            case .northToSouth:
                if previous.y < pos.y {
                    return Pos(x: pos.x, y: pos.y+1)
                } else {
                    return Pos(x: pos.x, y: pos.y-1)
                }
            case .westToEast:
                if previous.x < pos.x {
                    return Pos(x: pos.x+1, y: pos.y)
                } else {
                    return Pos(x: pos.x-1, y: pos.y)
                }
            case .northToWest:
                if previous.x == pos.x {
                    return Pos(x: pos.x-1, y: pos.y)
                } else {
                    return Pos(x: pos.x, y: pos.y-1)
                }
            case .northToEast:
                if previous.x == pos.x {
                    return Pos(x: pos.x+1, y: pos.y)
                } else {
                    return Pos(x: pos.x, y: pos.y-1)
                }
            case .southToWest:
                if previous.x == pos.x {
                    return Pos(x: pos.x-1, y: pos.y)
                } else {
                    return Pos(x: pos.x, y: pos.y+1)
                }
            case .southToEast:
                if previous.x == pos.x {
                    return Pos(x: pos.x+1, y: pos.y)
                } else {
                    return Pos(x: pos.x, y: pos.y+1)
                }
            }
        }
    }
    
    static func convert(input: [String]) -> (start: Pos, pipes: Set<Pipe>, columns: Int, rows: Int) {
        var start = Pos(x: 0, y: 0)
        var pipes: Set<Pipe> = []
        for (y, line) in input.enumerated() {
            for (x, character) in Array(line).enumerated() {
                if character == "." {
                    continue
                } else if character == "S" {
                    start = Pos(x: x, y: y)
                } else {
                    pipes.insert(Pipe(pos: Pos(x: x, y: y), kind: Pipe.Kind(rawValue: character)!))
                }
            }
        }
        
        return (start, pipes, input[0].count, input.count)
    }

    static func solvePart1(input: (start: Pos, pipes: Set<Pipe>, columns: Int, rows: Int)) -> String {
        var paths = input.start.neighboursWithKind.filter { neighbour in
            let pipe = input.pipes.first { $0.pos == neighbour.key }
            guard let pipe = pipe else { return false }
            return neighbour.value.contains(pipe.kind)
        }.compactMap { neighbour in input.pipes.first { $0.pos == neighbour.key } }
        
        var maxDistance = 1
        var previousPos = [input.start, input.start]
        
        while true {
            let first = paths[0].nextPos(previous: previousPos[0])
            let nextFirstPipe = input.pipes.first { $0.pos == first }!
            
            let second = paths[1].nextPos(previous: previousPos[1])
            let nextSecondPipe = input.pipes.first { $0.pos == second }!
            
            maxDistance += 1
            
            if first == second {
                break
            }
            
            previousPos = [paths[0].pos, paths[1].pos]
            paths = [nextFirstPipe, nextSecondPipe]
        }
        
        return "\(maxDistance)"
    }

    static func solvePart2(input: (start: Pos, pipes: Set<Pipe>, columns: Int, rows: Int)) -> String {
        var paths = input.start.neighboursWithKind.filter { neighbour in
            let pipe = input.pipes.first { $0.pos == neighbour.key }
            guard let pipe = pipe else { return false }
            return neighbour.value.contains(pipe.kind)
        }.compactMap { neighbour in input.pipes.first { $0.pos == neighbour.key } }
        
        var allPipes: Set<Pipe> = [Pipe(pos: input.start, kind: .northToSouth), paths[0], paths[1]]
        
        var previousPos = [input.start, input.start]
        
        while true {
            let first = paths[0].nextPos(previous: previousPos[0])
            let nextFirstPipe = input.pipes.first { $0.pos == first }!
            
            let second = paths[1].nextPos(previous: previousPos[1])
            let nextSecondPipe = input.pipes.first { $0.pos == second }!
            
            if first == second {
                allPipes.insert(nextFirstPipe)
                allPipes.insert(nextSecondPipe)
                break
            }
                        
            previousPos = [paths[0].pos, paths[1].pos]
            paths = [nextFirstPipe, nextSecondPipe]
            allPipes.insert(nextFirstPipe)
            allPipes.insert(nextSecondPipe)
        }
        
        var enclosedTiles: Set<Pos> = []
        
        let path = Set(allPipes.map { $0.pos })
        let enclosingPaths = Set(allPipes.filter { [.northToSouth, .northToWest, .northToEast].contains($0.kind) }.map { $0.pos })
        
        for x in 0..<input.columns {
            for y in 0..<input.rows {
                let pos = Pos(x: x, y: y)
                
                if path.contains(pos) { continue }
                
                let intersections = pos.allNeighboursToLeftEdge.intersection(enclosingPaths)
                
                if intersections.count.isOdd {
                    enclosedTiles.insert(pos)
                }
            }
        }
        
        return "\(enclosedTiles.count)"
    }
}
