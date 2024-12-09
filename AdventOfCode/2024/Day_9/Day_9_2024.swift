//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/9

// Took 12.378360986709595 seconds
enum Day_9_2024: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2024
    typealias InputReturnType = [Int?]
    
    static func convert(input: [String]) -> InputReturnType {
        var isSpace = false
        var id = 0
        var diskMap: InputReturnType = []
        for c in Array(input[0]) {
            if isSpace {
                diskMap.append(contentsOf: Array(repeating: nil, count: Int(String(c))!))
                isSpace = false
            } else {
                diskMap.append(contentsOf: Array(repeating: id, count: Int(String(c))!))
                id += 1
                isSpace = true
            }
        }
        
        return diskMap
    }

    static func solvePart1(input: InputReturnType) -> String {
        var diskMap = input
        
        var lastBlockIndex: Int = diskMap.lastIndex { $0 != nil }!
        for i in 0..<diskMap.count {
            guard i < lastBlockIndex else { break }
            guard diskMap[i] == nil else { continue }
            
            diskMap[i] = diskMap[lastBlockIndex]
            diskMap[lastBlockIndex] = nil
            
            while diskMap[lastBlockIndex] == nil {
                lastBlockIndex -= 1
            }
        }
        
        var checkSum = 0
        
        for (index, id) in diskMap.enumerated() {
            guard let id = id else { break }
            checkSum += index * id
        }
        
        return "\(checkSum)"
    }

    static func solvePart2(input: InputReturnType) -> String {
        var diskMap = input
        
        var spacesLength = getSpaceLengths(for: diskMap, to: diskMap.count-1)
        
        var lastBlockIndex: Int = diskMap.lastIndex { $0 != nil }!
        while true {
            let startIndex = lastBlockIndex
            lastBlockIndex -= 1
            var length = 1
            guard lastBlockIndex > 0 else { break }
            
            while lastBlockIndex > 0 && diskMap[lastBlockIndex] != nil && diskMap[lastBlockIndex] == diskMap[lastBlockIndex+1] {
                length += 1
                lastBlockIndex -= 1
            }
            
            while diskMap[lastBlockIndex] == nil {
                lastBlockIndex -= 1
            }
            
            guard let space = spacesLength.first(where: { $0.length >= length }) else { continue }
            let id = diskMap[startIndex]!
            for l in 0..<length {
                diskMap[space.start + l] = id
                diskMap[startIndex - l] = nil
            }
            
            spacesLength = getSpaceLengths(for: diskMap, to: lastBlockIndex)
        }
        
        var checkSum = 0
        
        for (index, id) in diskMap.enumerated() {
            guard let id = id else { continue }
            checkSum += index * id
        }
        
        return "\(checkSum)"
    }
    
    static func getSpaceLengths(for diskMap: [Int?], to maxIndex: Int) -> [(length: Int, start: Int)] {
        var spacesLength: [(length: Int, start: Int)] = []
        
        var index: Int = diskMap.firstIndex(of: nil)!
        while true {
            guard index < maxIndex else { break }
            let startIndex = index
            index += 1
            var length = 1
            guard index < diskMap.count else { break }
            
            while index < diskMap.count && diskMap[index] == nil {
                length += 1
                index += 1
            }
            
            while index < diskMap.count && diskMap[index] != nil {
                index += 1
            }
            
            spacesLength.append((length, startIndex))
        }
        
        return spacesLength
    }
    
    static func description(for diskMap: [Int?]) -> String {
        diskMap.map({
            if let id = $0 {
                return "\(id)"
            } else {
                return "."
            }
        }).joined()
    }
}
