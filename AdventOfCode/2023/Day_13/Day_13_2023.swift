//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/13

enum Day_13_2023: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2023
    
    enum MirrorDirection {
        case horizontal, vertical
    }
    
    static func convert(input: [String]) -> [[String]] {
        var maps: [[String]] = []
        
        var current: [String] = []
        
        for line in input {
            if line.isEmpty {
                maps.append(current)
                current = []
                continue
            }
            
            current.append(line)
        }
        
        maps.append(current)
        
        return maps
    }
    
    static func isMirrored(map: [String], index: [Int]) -> Bool {
        let startToMirror = 0...index[0]
        let mirrorToEnd = index[1]...map.count-1
        
        var isMirrored = true
        
        if startToMirror.count < mirrorToEnd.count {
            let offset = index[0] + startToMirror.count
            for i in startToMirror {
                if map[i] != map[offset - i] {
                    return false
                }
            }
        } else {
            for (offset, i) in mirrorToEnd.enumerated() {
                if map[i] != map[i-1-(offset*2)] {
                    return false
                }
            }
        }
        
        return true
    }
    
    static func findMirror(in map: [String], with original: (index: Int, direction: MirrorDirection)? = nil) -> (index: Int, direction: MirrorDirection)? {
        for i in 0..<map.count-1 {
            if map[i] == map[i+1], isMirrored(map: map, index: [i, i+1]) {
                let mirror = (i+1, MirrorDirection.horizontal)
                if let original = original {
                    if mirror != original {
                        return mirror
                    }
                } else {
                    return mirror
                }
            }
        }
        
        let rotatedMap = rotateLeft(map.map { Array($0) }).map { String($0) }
        
        for i in 0..<rotatedMap.count-1 {
            if rotatedMap[i] == rotatedMap[i+1], isMirrored(map: rotatedMap, index: [i, i+1]) {
                let mirror = (rotatedMap.count - i - 1, MirrorDirection.vertical)
                if let original = original {
                    if mirror != original {
                        return mirror
                    }
                } else {
                    return mirror
                }
            }
        }
        
        return nil
    }

    static func solvePart1(input: [[String]]) -> String {
       
        var mirrorIndex: [(index: Int, direction: MirrorDirection)] = []
        
        for map in input {
            if let mirror = findMirror(in: map) {
                mirrorIndex.append(mirror)
            }
        }
        
        let sum = mirrorIndex.reduce(0) { $0 + $1.index * ($1.direction == .horizontal ? 100 : 1)}
        return "\(sum)"
    }

    static func solvePart2(input: [[String]]) -> String {
        var originalMirrorIndex: [(index: Int, direction: MirrorDirection)] = []
        var newMirrorIndex: [(index: Int, direction: MirrorDirection)] = []
        
        for map in input {
            if let mirror = findMirror(in: map) {
                originalMirrorIndex.append(mirror)
            }
        }
        
    mirrorLoop:
        for (i, map) in input.enumerated() {
            for y in 0..<map.count {
                for x in 0..<map[0].count {
                    var newMap = map.map { Array($0) }
                    newMap[y][x] = newMap[y][x] == "#" ? "." : "#"
                    
                    if let mirror = findMirror(in: newMap.map({ String($0) }), with: originalMirrorIndex[i]) {
                        newMirrorIndex.append(mirror)
                        continue mirrorLoop
                    }
                }
            }
        }
        
        let sum = newMirrorIndex.reduce(0) { $0 + $1.index * ($1.direction == .horizontal ? 100 : 1)}
        return "\(sum)"
    }
}
