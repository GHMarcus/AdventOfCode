//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/22

enum Day_22_2016: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2016
    
    struct Pos: Equatable, Hashable {
        let x: Int
        let y: Int
    }
    
    struct Node: Equatable {
        let pos: Pos
        let size: Int
        let used: Int
        let available: Int
    }
    
    struct State: Hashable {
        let dataPos: Pos
        let emptyPos: Pos
        let bigPos: Set<Pos>
        let maxX: Int
        let maxY: Int
        
        func print() {
            var storage = Array(repeating: Array(repeating: ".", count: maxX + 1), count: maxY + 1)
            for pos in bigPos {
                storage[pos.y][pos.x] = "#"
            }
            storage[emptyPos.y][emptyPos.x] = "_"
            storage[dataPos.y][dataPos.x] = "G"
            storage.forEach {
                Swift.print($0.joined())
            }
            Swift.print()
        }
    }
    
    static func convert(input: [String]) -> [Node] {
        var nodes: [Node] = []
        for line in input[2...] {
            let cmp = line.components(separatedBy: "  ").filter { !$0.isEmpty }
            let pos = cmp[0].components(separatedBy: "-").dropFirst().map { Int($0.dropFirst())! }
            let size = Int(cmp[1].replacingOccurrences(of: " ", with: "").dropLast())!
            let used = Int(cmp[2].replacingOccurrences(of: " ", with: "").dropLast())!
            let available = Int(cmp[3].replacingOccurrences(of: " ", with: "").dropLast())!
            
            nodes.append(Node(pos: Pos(x: pos[0], y: pos[1]), size: size, used: used, available: available))
        }
        return nodes
    }

    static func solvePart1(input: [Node]) -> String {
        var viablePairCount = 0
        for a in input {
            if a.used == 0 { continue }
            for b in input {
                if a == b { continue }
                if b.available >= a.used {
                    viablePairCount += 1
                }
            }
        }
        return "\(viablePairCount)"
    }

    static func solvePart2(input: [Node]) -> String {
        let maxX = input.last!.pos.x
        let maxY = input.last!.pos.y
        var storage: [[Character]] = Array(repeating: Array(repeating: " ", count: maxX+1), count: maxY+1)
        
        let averageSize = input.map(\.size).reduce(0, +) / input.count
        var emptyPos = Pos(x: 0, y: 0)
        var bigPos: Set<Pos> = []
        for node in input {
            let type: Character
            if node.used == 0 {
                type = "-"
                emptyPos = node.pos
            } else if node.used >= 2*averageSize {
                type = "#"
                bigPos.insert(node.pos)
            } else {
                type = "."
            }
            storage[node.pos.y][node.pos.x] = type
        }
        
        let start = State(dataPos: Pos(x: maxX, y: 0), emptyPos: emptyPos, bigPos: bigPos, maxX: maxX, maxY: maxY)
        let goalPos = Pos(x: 0, y: 0)
        
        let path = aStar(
            start: start,
            goal: { $0.dataPos == goalPos },
            neighbors: { getNextState(for: $0) }
        ) ?? []
        
        return "\(path.count - 1)"
    }
    
    static func getNextState(for state: State) -> [State] {
        var newStates: [State] = []
        let newDataPositions: [Pos] = [
            Pos(x: state.dataPos.x, y: state.dataPos.y + 1),
            Pos(x: state.dataPos.x, y: state.dataPos.y - 1),
            Pos(x: state.dataPos.x + 1, y: state.dataPos.y),
            Pos(x: state.dataPos.x - 1, y: state.dataPos.y)
        ].filter {
            $0.x >= 0 && $0.y >= 0 && $0.x <= state.maxX && $0.y <= state.maxY
        }
        let newEmptyPositions: [Pos] = [
            Pos(x: state.emptyPos.x, y: state.emptyPos.y + 1),
            Pos(x: state.emptyPos.x, y: state.emptyPos.y - 1),
            Pos(x: state.emptyPos.x + 1, y: state.emptyPos.y),
            Pos(x: state.emptyPos.x - 1, y: state.emptyPos.y)
        ].filter {
            $0.x >= 0 && $0.y >= 0 && $0.x <= state.maxX && $0.y <= state.maxY
        }
        
        for newDataPosition in newDataPositions {
            if newDataPosition == state.emptyPos {
                newStates.append(State(dataPos: newDataPosition, emptyPos: state.dataPos, bigPos: state.bigPos, maxX: state.maxX, maxY: state.maxY))
            }
        }
        
        for newEmptyPosition in newEmptyPositions {
            if !state.bigPos.contains(newEmptyPosition), newEmptyPosition != state.dataPos {
                newStates.append(State(dataPos: state.dataPos, emptyPos: newEmptyPosition, bigPos: state.bigPos, maxX: state.maxX, maxY: state.maxY))
            }
        }
        
        return newStates
    }
}
