//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/17

enum Day_17_2023: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2023
    
    static func convert(input: [[Character]]) -> [[Int]] {
        var map: [[Int]] = []
        for line in input {
            map.append(line.map({ Int(String($0))! }))
        }
        return map
    }
    
    enum Direction: String {
        case up = "^", down = "v", left = "<", right = ">"
    }
    
    struct Pos: Hashable {
        let x: Int
        let y: Int
        let dir: Direction
        let movedInSameDir: Int
        
        func distance(to other: Pos) -> Int {
            abs(x - other.x) + abs(y - other.y)
        }
        
        var otherDirectionsPart1: [Direction] {
            switch dir {
            case .up:
                if movedInSameDir >= 3 {
                    return [.left, .right]
                } else {
                    return [.up, .left, .right]
                }
            case .down:
                if movedInSameDir >= 3 {
                    return [.left, .right]
                } else {
                    return [.down, .left, .right]
                }
            case .left:
                if movedInSameDir >= 3 {
                    return [.up, .down]
                } else {
                    return [.left, .up, .down]
                }
            case .right:
                if movedInSameDir >= 3 {
                    return [.up, .down]
                } else {
                    return [.right, .up, .down]
                }
            }
        }
        
        var otherDirectionsPart2: [Direction] {
            
            if movedInSameDir < 4 {
                return [dir]
            }
            
            switch dir {
            case .up:
                if movedInSameDir >= 10 {
                    return [.left, .right]
                } else {
                    return [.up, .left, .right]
                }
            case .down:
                if movedInSameDir >= 10 {
                    return [.left, .right]
                } else {
                    return [.down, .left, .right]
                }
            case .left:
                if movedInSameDir >= 10 {
                    return [.up, .down]
                } else {
                    return [.left, .up, .down]
                }
            case .right:
                if movedInSameDir >= 10 {
                    return [.up, .down]
                } else {
                    return [.right, .up, .down]
                }
            }
        }
    }

    static func solvePart1(input: [[Int]]) -> String {
        let starts = [Pos(x: 0, y: 0, dir: .right, movedInSameDir: 0), Pos(x: 0, y: 0, dir: .down, movedInSameDir: 0)]
        let goal = Pos(x: input[0].count - 1, y: input.count - 1, dir: .right, movedInSameDir: 0)
        var sums: [Int] = []
        
        for start in starts {
            let path = aStar(
                start: start,
                goal: { $0.x == goal.x && $0.y == goal.y },
                cost: { input[$1.y][$1.x] },
                heuristic: { goal.distance(to: $0) },
                neighbors: { getNeighborsPart1(pos: $0, in: input) }
            ) ?? []
            
            sums.append(path.dropFirst().reduce(0) { $0 + input[$1.y][$1.x] })
        }
        
        print(sums)
        
        return "\(sums.min()!)"
    }

    static func solvePart2(input: [[Int]]) -> String {
        let starts = [Pos(x: 0, y: 0, dir: .right, movedInSameDir: 0), Pos(x: 0, y: 0, dir: .down, movedInSameDir: 0)]
        let goal = Pos(x: input[0].count - 1, y: input.count - 1, dir: .right, movedInSameDir: 4)
        var sums: [Int] = []
        
        for start in starts {
            let path = aStar(
                start: start,
                goal: { $0.x == goal.x && $0.y == goal.y && $0.movedInSameDir >= goal.movedInSameDir },
                cost: { input[$1.y][$1.x] },
                heuristic: { goal.distance(to: $0) },
                neighbors: { getNeighborsPart2(pos: $0, in: input) }
            ) ?? []
            
            sums.append(path.dropFirst().reduce(0) { $0 + input[$1.y][$1.x] })
        }
        
        print(sums)
        
        return "\(sums.min()!)"
    }
    
    static func getNeighborsPart1(pos: Pos, in map: [[Int]]) -> [Pos] {
        var result: [Pos] = []
        
        for dir in pos.otherDirectionsPart1 {
            let nextX: Int
            let nextY: Int
            
            switch dir {
            case .up:
                nextX = pos.x
                nextY = pos.y - 1
            case .down:
                nextX = pos.x
                nextY = pos.y + 1
            case .left:
                nextX = pos.x - 1
                nextY = pos.y
            case .right:
                nextX = pos.x + 1
                nextY = pos.y
            }
            
            guard nextX >= 0, nextX < map[0].count, nextY >= 0, nextY < map.count else {
                continue
            }
            
            if dir == pos.dir, pos.movedInSameDir < 3 {
                result.append(Pos(x: nextX, y: nextY, dir: dir, movedInSameDir: pos.movedInSameDir + 1))
            } else {
                result.append(Pos(x: nextX, y: nextY, dir: dir, movedInSameDir: 1))
            }
        }
        
        return result
    }
    
    static func getNeighborsPart2(pos: Pos, in map: [[Int]]) -> [Pos] {
        var result: [Pos] = []
        
        for dir in pos.otherDirectionsPart2 {
            let nextX: Int
            let nextY: Int
            
            switch dir {
            case .up:
                nextX = pos.x
                nextY = pos.y - 1
            case .down:
                nextX = pos.x
                nextY = pos.y + 1
            case .left:
                nextX = pos.x - 1
                nextY = pos.y
            case .right:
                nextX = pos.x + 1
                nextY = pos.y
            }
            
            guard nextX >= 0, nextX < map[0].count, nextY >= 0, nextY < map.count else {
                continue
            }
            
            if dir == pos.dir, pos.movedInSameDir < 10 {
                result.append(Pos(x: nextX, y: nextY, dir: dir, movedInSameDir: pos.movedInSameDir + 1))
            } else {
                result.append(Pos(x: nextX, y: nextY, dir: dir, movedInSameDir: 1))
            }
        }
        
        return result
    }
}

/*
 
 919 -> high
 910 -> high
 
 2>>34^>>>1323
 32v>>>35v5623
 32552456v>>54
 3446585845v52
 4546657867v>6
 14385987984v4
 44578769877v6
 36378779796v>
 465496798688v
 456467998645v
 12246868655<v
 25465488877v5
 43226746555v>
 */


