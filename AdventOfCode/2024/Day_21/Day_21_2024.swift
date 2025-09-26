//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/21

import Foundation

enum Day_21_2024: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Path]
    typealias Path = [Character]
    
    static var memo: [String: Int] = [:]
    
    static func convert(input: [String]) -> ConvertedInput {
        input.map({Array($0)})
    }
    
    enum Direction: Character {
        case left = "<"
        case right = ">"
        case up = "^"
        case down = "v"
    }
    
    struct PathKey: Hashable {
        let start, end: Character
        
        init(_ start: Character, _ end: Character) {
            self.start = start
            self.end = end
        }
    }
    
    static func solvePart1(input: ConvertedInput) -> String {
        var sum = 0
        for sequence in input.map({Array($0)}) {
            let length = calculateNumPathsLength(
                path: sequence,
                depth: 2,
                preComputedNumPaths: preComputeNumPadPaths(),
                preComputedDirPaths: preComputeDirPadPaths()
            )
            sum += length * Int(String(sequence.dropLast()))!
            
        }
        return "\(sum)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var sum = 0
        for sequence in input.map({Array($0)}) {
            let length = calculateNumPathsLength(
                path: sequence,
                depth: 25,
                preComputedNumPaths: preComputeNumPadPaths(),
                preComputedDirPaths: preComputeDirPadPaths()
            )
            sum += length * Int(String(sequence.dropLast()))!
            
        }
        return "\(sum)"
    }
    
    // Find all shortest dir command paths for the num pad
    static func preComputeNumPadPaths() -> [PathKey: [Path]] {
        var paths: [PathKey: [Path]] = [:]
        let numPad: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A"]
        
        for start in numPad {
            for end in numPad {
                let key = PathKey(start, end)
                if start == end {
                    paths[key] = [["A"]]
                } else {
                    paths[key] = findNumPadCommands(end, start: start)
                }
            }
        }
        
        return paths
    }
    
    static func findNumPadCommands(_ command: Character, start: Character) -> [[Character]] {
        let paths = aStarAll(
            start: start,
            goal: command,
            neighbors: { getNumPadNeighbor(for: $0) }
        ) ?? []
        
        return paths.map {
            convertNumPathToCommands($0)
        }
    }
    
    static func getNumPadNeighbor(for pos: Character) -> [Character] {
        /*
         +---+---+---+
         | 7 | 8 | 9 |
         +---+---+---+
         | 4 | 5 | 6 |
         +---+---+---+
         | 1 | 2 | 3 |
         +---+---+---+
             | 0 | A |
             +---+---+
         */
        switch pos {
        case "A": return ["0", "3"]
        case "1": return ["2", "4"]
        case "2": return ["0", "1", "3", "5"]
        case "3": return ["A", "2", "6"]
        case "4": return ["1", "5", "7"]
        case "5": return ["2", "4", "6", "8"]
        case "6": return ["3", "5", "9"]
        case "7": return ["4", "8"]
        case "8": return ["5", "7", "9"]
        case "9": return ["6", "8"]
        case "0": return ["A", "2"]
        default:
            return []
        }
    }
    
    static func convertNumPathToCommands(_ path: [Character]?) -> [Character] {
        guard let path = path, !path.isEmpty else { return [] }
        if path.count == 1 { return ["A"] }
        var commands: [Character] = []
        for i in 1..<path.count {
            commands.append(getNumPadMove(start: path[i-1], end: path[i]).rawValue)
        }
        commands.append("A")
        return commands
    }
    
    static func getNumPadMove(start: Character, end: Character) -> Direction {
        switch (start, end) {
        case ("0", "2"), ("A", "3"), ("1", "4"), ("2", "5"), ("3", "6"), ("4", "7"), ("5", "8"), ("6", "9"): return .up
        case ("7", "4"), ("8", "5"), ("9", "6"), ("4", "1"), ("5", "2"), ("6", "3"), ("3", "A"), ("2", "0"): return .down
        case ("2", "1"), ("5", "4"), ("8", "7"), ("A", "0"), ("9", "8"), ("6", "5"), ("3", "2"): return .left
        case ("1", "2"), ("4", "5"), ("7", "8"), ("0", "A"), ("8", "9"), ("5", "6"), ("2", "3"): return .right
        default: fatalError()
        }
    }
    
    // Find all shortest dir command paths for the num pad
    static func preComputeDirPadPaths() -> [PathKey: [Path]] {
        var paths: [PathKey: [Path]] = [:]
        let dirPad: [Character] = ["<", "^", ">", "v", "A"]
        
        for start in dirPad {
            for end in dirPad {
                let key = PathKey(start, end)
                if start == end {
                    paths[key] = [["A"]]
                } else {
                    paths[key] = findDirPadCommands(end, start: start)
                }
            }
        }
        
        return paths
    }
    
    static func findDirPadCommands(_ command: Character, start: Character) -> [[Character]] {
        let paths = aStarAll(
            start: start,
            goal: command,
            neighbors: { getDirPadNeighbor(for: $0) }
        ) ?? []
        
        return paths.map {
            convertDirPathToCommands($0)
        }
    }
    
    static func getDirPadNeighbor(for pos: Character) -> [Character] {
        /*
             +---+---+
             | ^ | A |
         +---+---+---+
         | < | v | > |
         +---+---+---+
         */
        switch pos {
        case "A": return ["^", ">"]
        case "^": return ["v", "A"]
        case "v": return ["<", "^", ">"]
        case "<": return ["v"]
        case ">": return ["v", "A"]
        default:
            return []
        }
    }
    
    static func convertDirPathToCommands(_ path: [Character]?) -> [Character] {
        guard let path = path, !path.isEmpty else { return [] }
        if path.count == 1 { return ["A"] }
        var commands: [Character] = []
        for i in 1..<path.count {
            commands.append(getDirPadMove(start: path[i-1], end: path[i]).rawValue)
        }
        commands.append("A")
        return commands
    }
    
    static func getDirPadMove(start: Character, end: Character) -> Direction {
        switch (start, end) {
        case ("v", "^"), (">", "A"): return .up
        case ("^", "v"), ("A", ">"): return .down
        case ("A", "^"), ("v", "<"), (">", "v"): return .left
        case ("^", "A"), ("<", "v"), ("v", ">"): return .right
        default: fatalError()
        }
    }
    
    
    // Actual search functions
    static func calculateNumPathsLength(path: Path, depth: Int, preComputedNumPaths: [PathKey: [Path]], preComputedDirPaths: [PathKey: [Path]]) -> Int {
        var start: Character = "A"
        var length = 0
        for c in path {
            let key = PathKey(start, c)
            let newPaths = preComputedNumPaths[key]!
            let newLength = newPaths.map { calculateDirPathsLength(path: $0, depth: depth, preComputedPaths: preComputedDirPaths) }.min()!
            length += newLength
            start = c
        }
        
        return length
    }
    
    static func calculateDirPathsLength(path: Path, depth: Int, preComputedPaths: [PathKey: [Path]]) -> Int {
        var start: Character = "A"
        var length = 0
        let memoKey = String(path)+"\(depth)"
        if depth == 0 {
            return path.count
        }
        if let memoValue = memo[memoKey] {
            length += memoValue
        } else {
            for c in path {
                let key = PathKey(start, c)
                let newPaths = preComputedPaths[key]!
                length += newPaths.map{ calculateDirPathsLength(path: $0, depth: depth - 1, preComputedPaths: preComputedPaths) }.min()!
                start = c
            }
            
            memo[memoKey] = length
        }
        
        return length
    }
}
