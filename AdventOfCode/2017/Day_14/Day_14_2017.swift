//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/14

// Note: Took 40.393413066864014 seconds

enum Day_14_2017: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2017
    
    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    
    static func convert(input: [String]) -> String {
        input.first!
    }

    static func solvePart1(input: String) -> String {
        var used = 0
        for i in 0..<128 {
            let hash = getHash(for: input + "-\(i)")
            let binaryHash = hash
                .map { Int(String($0), radix: 16)! }
                .map {
                    let str = String($0, radix: 2)
                    return repeatElement("0", count: 4 - str.count) + str
                }
                .joined()
            binaryHash.forEach {
                if $0 == "1" {
                    used += 1
                }
            }
        }
        
        return "\(used)"
    }

    static func solvePart2(input: String) -> String {
        var hash: [[Character]] = []
        for i in 0..<128 {
            let inputHash = getHash(for: input + "-\(i)")
            let binaryHash = inputHash
                .map { Int(String($0), radix: 16)! }
                .map {
                    let str = String($0, radix: 2)
                    return repeatElement("0", count: 4 - str.count) + str
                }
                .joined()
            hash.append(Array(binaryHash))
        }
        
        var groups: [Set<Pos>] = []
        
        for y in 0..<128 {
            for x in 0..<128 {
                let pos = Pos(x: x, y: y)
                if let index = isInGroup(of: pos, in: groups, of: hash) {
                    groups[index] = groups[index].union([pos])
                } else if hash[y][x] == "1" {
                    groups.append([pos])
                }
            }
        }
        
        while true {
            let newGroups = combineGroups(groups)
            if newGroups.count == groups.count {
                break
            }
            groups = newGroups
        }
        
        return "\(groups.count)"
    }
    
    static func getHash(for input: String) -> String {
        let lengths = input.asciiValues + [17, 31, 73, 47, 23]
        var list = Array(0..<256)
        var currentPos = 0
        var skip = 0
        for _ in 0..<64 {
            (list, currentPos, skip) = knotHashing(list, currentPos: currentPos, skip: skip, lengths: lengths)
        }
        
        let sparseHash = list.chunked(into: 16)
        
        let denseHash = sparseHash.map{ list in
            list.reduce(into: 0) { $0 ^= $1 }
        }
        
        let knotHash = denseHash.map { String($0, radix: 16)}.map {
            if $0.count < 2{
                return "0"+$0
            } else {
                return $0
            }
        }
        
        return knotHash.joined()
    }
    
    static func knotHashing(_ list: [Int], currentPos: Int, skip: Int, lengths: [Int]) -> (list: [Int], currentPos: Int, skip: Int) {
        var currentPos = currentPos
        var skip = skip
        var list = list
        for length in lengths {
            if length > list.count {
               continue
            }
            var leftList = list[0..<currentPos]
            var rightList = list[currentPos...]
            var twisted: [Int] = []
            var overLength: Int? = nil
            
            if length > rightList.count {
                overLength = length - rightList.count
                for _ in 0..<overLength! {
                    rightList.append(leftList.removeFirst())
                }
            }
            
            for _ in 0..<length {
                twisted.append(rightList.removeFirst())
            }
            
            twisted.reverse()
            
            if let overLength = overLength {
                for _ in 0..<overLength {
                    leftList = [twisted.removeLast()] + leftList
                }
            }
            
            list = leftList + twisted + rightList
            
            currentPos = (currentPos + length + skip) % list.count
            skip += 1
        }
        
        return (list, currentPos, skip)
    }
    
    static func isInGroup(of pos: Pos, in groups: [Set<Pos>], of hash: [[Character]]) -> Int? {
        if pos.x < 0 || pos.x >= 127 || pos.y < 0 || pos.y >= 127 { return nil }
        if hash[pos.y][pos.x] == "1" {
        outerLoop:
            for neighbor in [Pos(x: pos.x-1, y: pos.y), Pos(x: pos.x+1, y: pos.y), Pos(x: pos.x, y: pos.y-1), Pos(x: pos.x, y: pos.y+1)] {
                for (index, group) in groups.enumerated() {
                    if group.contains(neighbor) {
                        return index
                    }
                }
            }
        }
        
        return nil
    }
    
    static func combineGroups(_ groups: [Set<Pos>]) -> [Set<Pos>] {
        var groups = groups
        var newGroups: [Set<Pos>] = []
        
    memberLoop:
        while let group = groups.popLast() {
            for member in group {
                for (otherIndex, otherGroup) in groups.enumerated() {
                    let neighbors: Set<Pos> = [Pos(x: member.x-1, y: member.y), Pos(x: member.x+1, y: member.y), Pos(x: member.x, y: member.y-1), Pos(x: member.x, y: member.y+1)]
                    if !otherGroup.intersection(neighbors).isEmpty {
                        newGroups.append(group.union(otherGroup))
                        groups.remove(at: otherIndex)
                        continue memberLoop
                    }
                }
            }
            newGroups.append(group)
        }
        
        return newGroups
    }
}
