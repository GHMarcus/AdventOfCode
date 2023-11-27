//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/24

enum Day_24_2022: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2022
    
    static var valley: Set<ValleyState> = []

    struct Pos: Equatable, Hashable {
        var x, y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        var neighbours: Set<Pos> {
            [
                Pos(x: x + 1, y: y),
                Pos(x: x - 1, y: y),
                Pos(x: x, y: y + 1),
                Pos(x: x, y: y - 1),
                self
            ]
        }
        
        static func == (lhs: Pos, rhs: Pos) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }
    
    enum Direction: String {
        case left = "<"
        case right = ">"
        case up = "^"
        case down = "v"
    }
    
    struct Blizzard: Equatable, Hashable {
        var pos: Pos
        let direction: Direction
        let max: (x: Int, y: Int)
        
        mutating func move() {
            switch direction {
            case .left:
                let newPos = pos.x - 1
                if newPos == 0 {
                    pos = Pos(x: max.x - 1, y: pos.y)
                } else {
                    pos = Pos(x: newPos, y: pos.y)
                }
            case .right:
                let newPos = pos.x + 1
                if newPos == max.x {
                    pos = Pos(x: 1, y: pos.y)
                } else {
                    pos = Pos(x: newPos, y: pos.y)
                }
            case .up:
                let newPos = pos.y - 1
                if newPos == 0 {
                    pos = Pos(x: pos.x, y: max.y - 1)
                } else {
                    pos = Pos(x: pos.x, y: newPos)
                }
            case .down:
                let newPos = pos.y + 1
                if newPos == max.y {
                    pos = Pos(x: pos.x, y: 1)
                } else {
                    pos = Pos(x: pos.x, y: newPos)
                }
            }
        }
        
        static func == (lhs: Blizzard, rhs: Blizzard) -> Bool {
            lhs.pos == rhs.pos && lhs.direction == rhs.direction
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(pos)
            hasher.combine(direction)
        }
    }
    
    struct ValleyState: Equatable, Hashable {
        let freeSpaces: Set<Pos>
        let time: Int
        
        func filterNeighbours(_ neighbours: Set<Pos>) -> Set<Pos> {
            neighbours.intersection(freeSpaces)
        }
        
        static func == (lhs: ValleyState, rhs: ValleyState) -> Bool {
            lhs.freeSpaces == rhs.freeSpaces
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(freeSpaces)
        }
    }
    
    struct State: Equatable, Hashable {
        let pos: Pos
        let time: Int
        let start: Pos
        let end: Pos
    }
    
    static func solvePart1(input: [String]) -> String {
        let map = input.map { Array($0) }
        
        let maxX = map[0].count - 1
        let maxY = map.count - 1
        
        let startPos = Pos(x: 1, y: 0)
        let endPos = Pos(x: maxX - 1, y: maxY)
        
        var blizzards: [Blizzard] = []
        
        for y in 1 ..< maxY {
            for x in 1 ..< maxX {
                if map[y][x] == "<" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .left, max: (maxX, maxY)))
                } else if map[y][x] == ">" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .right, max: (maxX, maxY)))
                } else if map[y][x] == "^" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .up, max: (maxX, maxY)))
                } else if map[y][x] == "v" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .down, max: (maxX, maxY)))
                }
            }
        }
        
        valley = createPrecompiledValley(for: blizzards, maxX: maxX, maxY: maxY)
        print("Precompiled blizzards ready -> \(valley.count)")
        
        let start = State(pos: startPos, time: 0, start: startPos, end: endPos)
        
        let way = resolveBFS(
            start: start,
            goal: { $0.pos == endPos },
            neighbours: { getNeighbours(state: $0) }
        )

        return "\((way?.count ?? 0) - 1)"
    }

    static func solvePart2(input: [String]) -> String {
        let map = input.map { Array($0) }
        
        let maxX = map[0].count - 1
        let maxY = map.count - 1
        
        let startPos = Pos(x: 1, y: 0)
        let endPos = Pos(x: maxX - 1, y: maxY)
        
        var blizzards: [Blizzard] = []
        
        for y in 1 ..< maxY {
            for x in 1 ..< maxX {
                if map[y][x] == "<" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .left, max: (maxX, maxY)))
                } else if map[y][x] == ">" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .right, max: (maxX, maxY)))
                } else if map[y][x] == "^" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .up, max: (maxX, maxY)))
                } else if map[y][x] == "v" {
                    blizzards.append(.init(pos: .init(x: x, y: y), direction: .down, max: (maxX, maxY)))
                }
            }
        }
        
        valley = createPrecompiledValley(for: blizzards, maxX: maxX, maxY: maxY)
        print("Precompiled blizzards ready -> \(valley.count)")
        
        let way1 = (resolveBFS(
            start: State(pos: startPos, time: 0, start: startPos, end: endPos),
            goal: { $0.pos == endPos },
            neighbours: { getNeighbours(state: $0) }
        )?.count ?? 0) - 1
        
        print("\(way1) -> Reached goal for the first time")
        
        let way2 = (resolveBFS(
            start: State(pos: endPos, time: 18, start: endPos, end: startPos),
            goal: { $0.pos == startPos },
            neighbours: { getNeighbours(state: $0) }
        )?.count ?? 0) - 1
        
        print("\(way2) -> Reached start again")
        
        let way3 = (resolveBFS(
            start: State(pos: startPos, time: (way1 + way2), start: startPos, end: endPos),
            goal: { $0.pos == endPos },
            neighbours: { getNeighbours(state: $0) }
        )?.count ?? 0) - 1
        
        return "\(way1 + way2 + way3)"
    }
    
    static func createPrecompiledValley(for initialBlizzards: [Blizzard], maxX: Int, maxY: Int) -> Set<ValleyState> {
        
        func moveBlizzard(_ blizzards: [Blizzard]) -> [Blizzard] {
            var newBlizzards: [Blizzard] = []
            
            for var blizzard in blizzards {
                blizzard.move()
                newBlizzards.append(blizzard)
            }
            
            return newBlizzards
        }
        
        func getEmptySpaces(for blizzards: Set<Pos>) -> Set<Pos> {
            var map: Set<Pos> = [
                Pos(x: 1, y: 0),
                Pos(x: maxX - 1, y: maxY)
            ]
            
            for x in 1..<maxX {
                for y in 1..<maxY {
                    map.insert(Pos(x: x, y: y))
                }
            }
            
            return map.subtracting(blizzards)
        }
        
        var time = 0
        var valley: Set<ValleyState> = [.init(
            freeSpaces: getEmptySpaces(for: Set(initialBlizzards.map{ $0.pos })), time: time)]
        var blizzards = initialBlizzards
        
        while true {
            time += 1
            blizzards = moveBlizzard(blizzards)
            let newState = ValleyState(freeSpaces: getEmptySpaces(for: Set(blizzards.map{ $0.pos })), time: time)
            
            if !valley.insert(newState).inserted {
                break
            }
        }
        
        return valley
    }
    
    static func getNeighbours (state: State) -> [State] {
        let newTime = (state.time + 1) % valley.count
        
        guard let valleyState = valley.first(where: { $0.time == newTime })
        else { return [] }
        
        let neighbours = state.pos.neighbours

        var filteredNeighbours = valleyState.filterNeighbours(neighbours)
        
        if neighbours.contains(state.start) {
            filteredNeighbours.insert(state.start)
        } else if neighbours.contains(state.end) {
            filteredNeighbours = [state.end]
        }
        
        return filteredNeighbours.map {
            State(pos: $0, time: state.time + 1, start: state.start, end: state.end)
        }
    }
}
