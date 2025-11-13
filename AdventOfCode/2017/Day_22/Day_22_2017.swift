//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/22

enum Day_22_2017: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2017
    
    struct Pos: Hashable {
        var x,y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
//        static func == (lhs: Day_22_2017.Pos, rhs: Day_22_2017.Pos) -> Bool {
//            lhs.x == rhs.x && lhs.y == rhs.y
//        }
//        
//        func hash(into hasher: inout Hasher) {
//            hasher.
//            hasher.combine(y)
//        }
    }
    
    enum Direction {
        case up, down, left, right
    }
    
    class Virus {
        var pos: Pos
        var dir: Direction
        
        init(pos: Pos) {
            self.pos = pos
            dir = .up
        }
        
        func turnLeft() {
            switch dir {
            case .up: dir = .left
            case .down: dir = .right
            case .left: dir = .down
            case .right: dir = .up
            }
        }
        
        func turnRight() {
            switch dir {
            case .up: dir = .right
            case .down: dir = .left
            case .left: dir = .up
            case .right: dir = .down
            }
        }
        
        func turnAround() {
            switch dir {
            case .up: dir = .down
            case .down: dir = .up
            case .left: dir = .right
            case .right: dir = .left
            }
        }
        
        func move() {
            switch dir {
            case .up: pos.y -= 1
            case .down: pos.y += 1
            case .left: pos.x -= 1
            case .right: pos.x += 1
            }
        }
    }
    
    static func convert(input: [String]) -> (infectedNodes: Set<Pos>, middlePos: Pos) {
        var infectedNodes: Set<Pos> = []
        let map = input.map { Array($0) }
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == "#" {
                    infectedNodes.insert(Pos(x: x, y: y))
                }
            }
        }
        return (infectedNodes, Pos(x: input[0].count/2, y: input.count/2))
    }

    static func solvePart1(input: (infectedNodes: Set<Pos>, middlePos: Pos)) -> String {
        var infectedNodes = input.infectedNodes
        var infectionCounter = 0
        
        let virus = Virus(pos: Pos(x: input.middlePos.x, y: input.middlePos.y))
        
        for _ in 0..<10000 {
            let currentIsInfected = infectedNodes.contains(virus.pos)
            if currentIsInfected {
                virus.turnRight()
                infectedNodes.remove(virus.pos)
            } else {
                virus.turnLeft()
                infectedNodes.insert(virus.pos)
                infectionCounter += 1
            }
            virus.move()
        }
        
        return "\(infectionCounter)"
    }

    static func solvePart2(input: (infectedNodes: Set<Pos>, middlePos: Pos)) -> String {
        var infectedNodes = input.infectedNodes
        var weakenedNodes: Set<Pos> = []
        var flaggedNodes: Set<Pos> = []
        var infectionCounter = 0
        
        let virus = Virus(pos: Pos(x: input.middlePos.x, y: input.middlePos.y))
        
        for _ in 0..<10000000 {
            if let _ = infectedNodes.remove(virus.pos) {
                virus.turnRight()
                flaggedNodes.insert(virus.pos)
            } else if let _ = weakenedNodes.remove(virus.pos) {
                infectedNodes.insert(virus.pos)
                infectionCounter += 1
            } else if let _ = flaggedNodes.remove(virus.pos) {
                virus.turnAround()
            } else {
                virus.turnLeft()
                weakenedNodes.insert(virus.pos)
            }
            virus.move()
        }
        
        return "\(infectionCounter)"
    }
}
