//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/16

enum Day_16_2023: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2023
    
    static var maxX = 0
    static var maxY = 0
    
    struct Pos: Hashable {
        let x,y: Int
        
        func getNextPos(for direction: Direction) -> Pos? {
            switch direction {
            case .left:
                let newX = x - 1
                if newX >= 0 {
                    return Pos(x: newX, y: y)
                } else {
                    return nil
                }
            case .right:
                let newX = x + 1
                if newX < maxX {
                    return Pos(x: newX, y: y)
                } else {
                    return nil
                }
            case .up:
                let newY = y - 1
                if newY >= 0 {
                    return Pos(x: x, y: newY)
                } else {
                    return nil
                }
            case .down:
                let newY = y + 1
                if newY < maxY {
                    return Pos(x: x, y: newY)
                } else {
                    return nil
                }
            }
        }
    }
    
    static func convert(input: [String]) -> [Pos: Character] {
        var changers: [Pos: Character] = [:]
        
        for (y, line) in input.enumerated() {
            for (x, c) in Array(line).enumerated() {
                if c != "." {
                    changers[Pos(x: x, y: y)] = c
                }
            }
        }
        
        maxX = input[0].count
        maxY = input.count
        
        return changers
    }
    
    enum Direction {
        case left, right, up, down
        
        func getNextDirections(for changer: Character) -> [Direction] {
            switch self {
            case .left:
                switch changer {
                case "/":
                    return [.down]
                case "\\":
                    return [.up]
                case "|":
                    return [.up, .down]
                case "-":
                    return [.left]
                default:
                    return []
                }
            case .right:
                switch changer {
                case "/":
                    return [.up]
                case "\\":
                    return [.down]
                case "|":
                    return [.up, .down]
                case "-":
                    return [.right]
                default:
                    return []
                }
            case .up:
                switch changer {
                case "/":
                    return [.right]
                case "\\":
                    return [.left]
                case "|":
                    return [.up]
                case "-":
                    return [.left, .right]
                default:
                    return []
                }
            case .down:
                switch changer {
                case "/":
                    return [.left]
                case "\\":
                    return [.right]
                case "|":
                    return [.down]
                case "-":
                    return [.left, .right]
                default:
                    return []
                }
            }
        }
    }
    
    struct Beam: Hashable {
        let pos: Pos
        let direction: Direction
    }
    
    static func fireBeam(from pos: Pos, in direction: Direction, with changers: [Pos: Character]) -> Int {
        var currentBeams: [(pos: Pos, direction: Direction)] = [(pos, direction)]
        var beams: Set<Beam> =  []
        
        while true {
            if currentBeams.isEmpty {
                break
            }
            let currentBeam = currentBeams.removeFirst()
            guard let nextPos = currentBeam.pos.getNextPos(for: currentBeam.direction)
            else { continue }
            
            if let changer = changers[nextPos] {
                for nextDirection in currentBeam.direction.getNextDirections(for: changer) {
                    if beams.insert(Beam(pos: nextPos, direction: nextDirection)).inserted {
                        currentBeams.append((nextPos, nextDirection))
                    }
                }
            } else {
                if beams.insert(Beam(pos: nextPos, direction: currentBeam.direction)).inserted {
                    currentBeams.append((nextPos, currentBeam.direction))
                }
            }
        }
        
        var uniqueBeamPos: Set<Pos> = []
        beams.forEach { uniqueBeamPos.insert($0.pos) }
        
        return uniqueBeamPos.count
    }

    static func solvePart1(input: [Pos: Character]) -> String {
        
        let energizedTiles = fireBeam(from: Pos(x: -1, y: 0), in: .right, with: input)
        
        return "\(energizedTiles)"
    }

    static func solvePart2(input: [Pos: Character]) -> String {
        
        var beamStarts: [(pos: Pos, direction: Direction)] = []
        
        for x in 0..<maxX {
            beamStarts.append((Pos(x: x, y: -1), .down))
            beamStarts.append((Pos(x: x, y: maxY), .up))
        }
        
        for y in 0..<maxY {
            beamStarts.append((Pos(x: -1, y: y), .right))
            beamStarts.append((Pos(x: maxX, y: y), .left))
        }
        
        var maxEnergizedTiles = 0
        
        // TODO: Make this faster then ca. 2.5 sec
        
        for (index, start) in beamStarts.enumerated() {
            print("\(index) / \(beamStarts.count)")
            maxEnergizedTiles = max(maxEnergizedTiles, fireBeam(from: start.pos, in: start.direction, with: input))
        }
        
        
        return "\(maxEnergizedTiles)"
    }
}
