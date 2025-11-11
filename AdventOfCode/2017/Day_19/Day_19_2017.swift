//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/19

enum Day_19_2017: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2017
    
    typealias Map = [[Character]]
    
    struct Pos {
        let x, y: Int
        let dir: Dir
    }
    
    enum Dir {
        case up, down, left, right
        
        func nextPos(for pos: Pos) -> Pos {
            switch self {
            case .up: return Pos(x: pos.x, y: pos.y-1, dir: .up)
            case .down: return Pos(x: pos.x, y: pos.y + 1, dir: .down)
            case .left: return Pos(x: pos.x - 1, y: pos.y, dir: .left)
            case .right: return Pos(x: pos.x + 1, y: pos.y, dir: .right)
            }
        }
    }
    
    static func convert(input: [String]) -> Map {
        let max = input.map { $0.count }.max()!
        var map: Map = []
        for line in input {
            map.append(Array(line) + Array(repeating: " ", count: max - line.count))
        }
        return map
    }

    static func solvePart1(input: Map) -> String {
        let (letters, _) = walk(down: input)
        
        return letters
    }

    static func solvePart2(input: Map) -> String {
        let (_, steps) = walk(down: input)
        
        return "\(steps)"
    }
    
    static func walk(down path: Map) -> (letters: String, steps: Int) {
        let maxY = path.count - 1
        let maxX = path[0].count - 1
        var current = Pos(x: path.first!.firstIndex(of: "|")!, y: 0, dir: .down)
        var letters = ""
        var steps = 0
        
        while current.x >= 0, current.x <= maxX, current.y >= 0, current.y <= maxY {
            let c = path[current.y][current.x]
            steps += 1
            
            if c == "+" {
                if current.dir == .up || current.dir == .down {
                    let next = [Dir.left.nextPos(for: current), Dir.right.nextPos(for: current)].first {
                        path[$0.y][$0.x] != " "
                    }!
                    current = next
                    continue
                } else if current.dir == .left || current.dir == .right {
                    let next = [Dir.up.nextPos(for: current), Dir.down.nextPos(for: current)].first {
                        path[$0.y][$0.x] != " "
                    }!
                    current = next
                    continue
                } else {
                    fatalError()
                }
            } else {
                current = current.dir.nextPos(for: current)
            }
            
            if !["-", "|", "+"].contains(c) {
                letters.append(c)
            }
            
            if path[current.y][current.x] == " " {
                break
            }
        }
        
        return (letters, steps)
    }
}

