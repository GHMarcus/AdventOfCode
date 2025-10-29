//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/24

enum Day_24_2016: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2016
    
    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    
    struct State: Hashable {
        let pos: Pos
        let visited: Set<Pos>
    }
    
    struct Map {
        let start: Pos
        let goals: Set<Pos>
        let walls: Set<Pos>
        let maxX: Int
        let maxY: Int
    }
    
    static func convert(input: [String]) -> Map {
        var start = Pos(x: 0, y: 0)
        var goals: Set<Pos> = []
        var walls: Set<Pos> = []
        
        for (y, line) in input.enumerated() {
            for (x, c) in Array(line).enumerated() {
                if c == "0" {
                    start = Pos(x: x, y: y)
                } else if Int(String(c)) != nil {
                    goals.insert(Pos(x: x, y: y))
                } else  if c == "#" {
                    walls.insert(Pos(x: x, y: y))
                }
            }
        }
        
        return Map(
            start: start,
            goals: goals,
            walls: walls,
            maxX: input[0].count-1,
            maxY: input.count-1
        )
    }

    static func solvePart1(input: Map) -> String {
        let path = aStar(
            start: State(pos: input.start, visited: []),
            goal: { $0.visited == input.goals },
            neighbors: { getNeighbors(state: $0, in: input) }
        ) ?? []
        return "\(path.count - 1)"
    }

    static func solvePart2(input: Map) -> String {
        let path = aStar(
            start: State(pos: input.start, visited: []),
            goal: { $0.visited == input.goals && $0.pos == input.start },
            neighbors: { getNeighbors(state: $0, in: input) }
        ) ?? []
        
        return "\(path.count - 1)"
    }
    
    static func getNeighbors(state: State, in map: Map) -> [State] {
        var newStates: [State] = []
        let nextPositions = [
            Pos(x: state.pos.x, y: state.pos.y - 1),
            Pos(x: state.pos.x, y: state.pos.y + 1),
            Pos(x: state.pos.x - 1, y: state.pos.y),
            Pos(x: state.pos.x + 1, y: state.pos.y)
        ].filter {
            $0.x >= 0 && $0.x <= map.maxX && $0.y >= 0 && $0.y <= map.maxY && !map.walls.contains($0)
        }
        
        for newPos in nextPositions {
            let newState: State
            if map.goals.contains(newPos) {
                var newVisited = state.visited
                newVisited.insert(newPos)
                newState = State(pos: newPos, visited: newVisited)
            } else {
                newState = State(pos: newPos, visited: state.visited)
            }
            newStates.append(newState)
        }
        return newStates
    }
}
