//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/18

enum Day_18_2024: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Pos]

    struct Pos: Equatable, Hashable {
        var x, y: Int
        
        var next: Set<Pos> {
            [
                Pos(x: x-1, y: y),
                Pos(x: x+1, y: y),
                Pos(x: x, y: y-1),
                Pos(x: x, y: y+1)
            ]
        }
        
        func distance(to other: Pos) -> Int {
            abs(x - other.x) + abs(y - other.y)
        }
        
        var desc: String {
            "\(x),\(y)"
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        input.map{$0.components(separatedBy: ",")}.map { Pos(x: Int($0[0])!, y: Int($0[1])!)}
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let max = 70
        let firstCount = 1024
        let firstBytes = Set(input[0...firstCount-1])
        let start = Pos(x: 0, y: 0)
        let end = Pos(x: max, y: max)
        
        let path = aStar(
            start: start,
            goal: end,
            heuristic: { $0.distance(to: end) },
            neighbors: { getNeighbors(for: $0, with: firstBytes, gridMax: max) }
        )
        
        return "\((path?.count ?? 0) - 1)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        let max = 70
        let firstCount = 1024
        var firstBytes = Set(input[0...firstCount-1])
        var lastBytes = Array(input[firstCount...input.count-1])
        let start = Pos(x: 0, y: 0)
        let end = Pos(x: max, y: max)
        
        while true {
            let count = lastBytes.count
            let firstHalf = Array(lastBytes[0...count/2-1])
            let secondHalf = Array(lastBytes[count/2...count-1])
    
            let path = aStar(
                start: start,
                goal: end,
                heuristic: { $0.distance(to: end) },
                neighbors: { getNeighbors(for: $0, with: firstBytes.union(Set(firstHalf)), gridMax: max) }
            )
            
            if path == nil {
                lastBytes = firstHalf
            } else {
                firstBytes = firstBytes.union(Set(firstHalf))
                lastBytes = secondHalf
            }
            
            if lastBytes.count == 1 {
                break
            }
        }
        
        return "\(lastBytes.first!.desc)"
    }
    
    static func getNeighbors(for pos: Pos, with bytes: Set<Pos>, gridMax: Int) -> Set<Pos> {
        pos.next
            .filter { !bytes.contains($0) }
            .filter { $0.x >= 0 && $0.y >= 0 && $0.x <= gridMax && $0.y <= gridMax }
    }
}
