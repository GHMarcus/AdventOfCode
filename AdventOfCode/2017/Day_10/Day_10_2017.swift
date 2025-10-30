//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/10

enum Day_10_2017: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2017
    
    static func solvePart1(input: [String]) -> String {
        let lengths = input.first!.components(separatedBy: ",").map { Int($0)! }
        let list = Array(0..<256)
        let hash = knotHashing(list, currentPos: 0, skip: 0, lengths: lengths)
        return "\(hash.list[0] * hash.list[1])"
    }

    static func solvePart2(input: [String]) -> String {
        let lengths = input.first!.asciiValues + [17, 31, 73, 47, 23]
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
}
