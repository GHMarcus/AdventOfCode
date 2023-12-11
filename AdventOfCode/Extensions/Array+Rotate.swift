//
//  File.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 11.12.23.
//

func rotateRight<T>(_ map: [[T]]) -> [[T]] {
    guard map.count > 1 else { return map }
    var map = map
    var rotatedMap: [[T]] = []
    let firstLine = map.removeFirst()
    
    for c in firstLine {
        rotatedMap.append([c])
    }
    
    for line in map {
        for (index, c) in line.enumerated() {
            rotatedMap[index].insert(c, at: 0)
        }
    }
    
    return rotatedMap
}

func rotateLeft<T>(_ map: [[T]]) -> [[T]] {
    guard map.count > 1 else { return map }
    var map = map
    var rotatedMap: [[T]] = []
    let firstLine = map.removeFirst()
    
    for c in firstLine {
        rotatedMap.append([c])
    }
    
    for line in map {
        for (index, c) in line.enumerated() {
            rotatedMap[index].append(c)
        }
    }
    
    return rotatedMap.reversed()
}
