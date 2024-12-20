//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/15

enum Day_15_2024: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2024
    static var isPart2: Bool = false
    typealias ConvertedInput = (walls: Set<Wall>, boxes: Set<Box>, largeBoxes: Set<LargeBox>, robot: Robot, commands: [Character], maxX: Int, maxY: Int)
    typealias LargeCoordinate = (left: Int, right: Int)
    
    class Robot {
        var x, y: Int
        
        var desc: String {
            "\(x),\(y)"
        }
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func getNewPosition(_ command: Character) -> (Int, Int) {
            switch command {
            case "^": return (x, y - 1)
            case "v": return (x, y + 1)
            case "<": return (x - 1, y)
            case">": return (x + 1, y)
            default:
                assertionFailure("Unknown command \(command)")
                return (x, y)
            }
        }
        
        func move(_ command: Character, boxes: Set<Box>, walls: Set<Wall>, maxX: Int, maxY: Int) {
            let next = getNewPosition(command)
            if walls.contains(where: { $0.x == next.0 && $0.y == next.1 }) {
                return
            }
            
            if let box = boxes.first(where: { $0.x == next.0 && $0.y == next.1 }) {
                let moved = box.move(command, boxes: boxes, walls: walls, maxX: maxX, maxY: maxY)
                if !moved {
                    return
                }
            }
            
            x = next.0
            y = next.1
        }
        
        func move(_ command: Character, boxes: Set<LargeBox>, walls: Set<Wall>, maxX: Int, maxY: Int) {
            let next = getNewPosition(command)
            if walls.contains(where: { $0.x == next.0 && $0.y == next.1 }) {
                return
            }
            
            if let box = boxes.first(where: { ($0.x.left == next.0 || $0.x.right == next.0) && $0.y == next.1 }) {
                let attachedBoxes = box.canMove(command, boxes: boxes, walls: walls, maxX: maxX, maxY: maxY)
                if attachedBoxes.allSatisfy({ $0.canMove }) {
                    Set(attachedBoxes.map({ $0.box })).forEach {
                        $0.move(command)
                    }
                }  else {
                    return
                }
            }
            
            x = next.0
            y = next.1
        }
    }
    
    class Box: Hashable, Equatable {
        static func == (lhs: Day_15_2024.Box, rhs: Day_15_2024.Box) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        var x, y: Int
        
        var gps: Int {
            y * 100 + x
        }
        
        var desc: String {
            "\(x),\(y)"
        }
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
        
        func getNewPosition(_ command: Character) -> (Int, Int) {
            switch command {
            case "^": return (x, y - 1)
            case "v": return (x, y + 1)
            case "<": return (x - 1, y)
            case">": return (x + 1, y)
            default:
                assertionFailure("Unknown command \(command)")
                return (x, y)
            }
        }
        
        func move(_ command: Character, boxes: Set<Box>, walls: Set<Wall>, maxX: Int, maxY: Int) -> Bool {
            let next = getNewPosition(command)
            if walls.contains(where: { $0.x == next.0 && $0.y == next.1 }) {
                return false
            }
            if let box = boxes.first(where: { $0.x == next.0 && $0.y == next.1 }) {
                let moved = box.move(command, boxes: boxes, walls: walls, maxX: maxX, maxY: maxY)
                if !moved {
                    return false
                }
            }
            
            x = next.0
            y = next.1
            return true
        }
    }
    
    class LargeBox: Hashable, Equatable {
        static func == (lhs: Day_15_2024.LargeBox, rhs: Day_15_2024.LargeBox) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        var x: LargeCoordinate
        var y: Int
        
        var gps: Int {
            y * 100 + x.left
        }
        
        var desc: String {
            "\(x),\(y)"
        }
        
        init(x: LargeCoordinate, y: Int) {
            self.x = x
            self.y = y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x.left)
            hasher.combine(x.right)
            hasher.combine(y)
        }
        
        func getNewPosition(_ command: Character) -> (LargeCoordinate, Int) {
            switch command {
            case "^": return (x, y - 1)
            case "v": return (x, y + 1)
            case "<": return ((x.0 - 1, x.1 - 1), y)
            case">": return ((x.0 + 1, x.1 + 1), y)
            default:
                assertionFailure("Unknown command \(command)")
                return (x, y)
            }
        }
        
        struct CanMoveResult: Hashable, Equatable {
            var box: LargeBox
            var canMove: Bool
        }
        
        func canMove(_ command: Character, boxes: Set<LargeBox>, walls: Set<Wall>, maxX: Int, maxY: Int) -> Set<CanMoveResult> {
            let next = getNewPosition(command)
            if walls.contains(where: {
                ($0.x == next.0.left || $0.x == next.0.right) && $0.y == next.1
            }) {
                return [.init(box: self, canMove: false)]
            }
            
            var filteredBoxes = boxes
            filteredBoxes.remove(at: filteredBoxes.firstIndex(where: { $0 == self })!)
            
            var attachedBoxes: Set<CanMoveResult> = [.init(box: self, canMove: true)]
            
            while let box = filteredBoxes.first(where: {
                (next.0.right == $0.x.right || next.0.left == $0.x.left || next.0.right == $0.x.left || next.0.left == $0.x.right)
                && next.1 == $0.y
            }) {
                let results = box.canMove(command, boxes: boxes, walls: walls, maxX: maxX, maxY: maxY)
                attachedBoxes = attachedBoxes.union(results)
                results.forEach { result in
                    if let index = filteredBoxes.firstIndex(where: { $0 == result.box }) {
                        filteredBoxes.remove(at: index)
                    }
                }
            }
            
            return attachedBoxes
        }
        
        func move(_ command: Character) {
            let next = getNewPosition(command)
            x = next.0
            y = next.1
        }
    }
    
    class Wall: Hashable, Equatable {
        static func == (lhs: Day_15_2024.Wall, rhs: Day_15_2024.Wall) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        let x, y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
    }
    
    static func getMap(input: Array<String>.SubSequence) -> [[Character]] {
        let map = input.map { Array($0) }
        if isPart2 {
            var largeMap: [[Character]] = []
            for line in map {
                var newLine: [Character] = []
                for char in line {
                     if char == "@" {
                        newLine.append(char)
                        newLine.append(".")
                    } else if char == "O" {
                        newLine.append("[")
                        newLine.append("]")
                    } else {
                        newLine.append(char)
                        newLine.append(char)
                    }
                }
                largeMap.append(newLine)
            }
            return largeMap
        } else {
            return map
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        let cmp = input.split(separator: "")
        let map = getMap(input: cmp[0])
        var walls: Set<Wall> = []
        var boxes: Set<Box> = []
        var largeBoxes: Set<LargeBox> = []
        var robot: Robot = Robot(x: 0, y: 0)
        let commands: [Character] = cmp[1].map { Array($0) }.reduce(into: []) { $0 += $1 }
        
        for y in 0..<map.count {
            for var x in 0..<map[y].count {
                if isPart2 {
                    if map[y][x] == "@" {
                        robot = Robot(x: x, y: y)
                    } else if map[y][x] == "[" {
                        largeBoxes.insert(LargeBox(x: (x,x+1), y: y))
                        x += 1
                    } else if map[y][x] == "#" {
                        walls.insert(Wall(x: x, y: y))
                    }
                } else {
                    if map[y][x] == "@" {
                        robot = Robot(x: x, y: y)
                    } else if map[y][x] == "O" {
                        boxes.insert(Box(x: x, y: y))
                    } else if map[y][x] == "#" {
                        walls.insert(Wall(x: x, y: y))
                    }
                }
            }
        }
        
        isPart2 = true
        return (walls, boxes, largeBoxes, robot, commands, map[0].count-1, map.count-1)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        for command in input.commands {
            input.robot.move(command, boxes: input.boxes, walls: input.walls, maxX: input.maxX, maxY: input.maxY)
        }
        
        return "\(input.boxes.reduce(0) {$0 + $1.gps})"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        for command in input.commands {
            input.robot.move(command, boxes: input.largeBoxes, walls: input.walls, maxX: input.maxX, maxY: input.maxY)
        }

        return "\(input.largeBoxes.reduce(0) {$0 + $1.gps})"
    }
}
