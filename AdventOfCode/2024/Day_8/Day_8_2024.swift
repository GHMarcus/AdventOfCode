//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/8

enum Day_8_2024: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (antennas: [Character: [Pos]], maxX: Int, maxY: Int)

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    
    enum Direction {
        case plus, minus
    }
    
    static func convert(input: [String]) -> ConvertedInput {
        var antennas: [Character: [Pos]] = [:]
        let map = input.map { Array($0) }
        for y in 0..<map.count {
            for x in 0..<map[0].count {
                if map[y][x] == "." { continue }
                if var existingAntenna = antennas[map[y][x]] {
                    existingAntenna.append(Pos(x: x, y: y))
                    antennas[map[y][x]] = existingAntenna
                } else {
                    antennas[map[y][x]] = [Pos(x: x, y: y)]
                }
            }
        }
        
        return (antennas, map[0].count, map.count)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var antinodes: Set<Pos> = []
        
        for antennas in input.antennas {
            for antennaPair in antennas.value.uniqueCombinations(ofLength: 2) {
                let diffX = antennaPair[0].x - antennaPair[1].x
                let diffY = antennaPair[0].y - antennaPair[1].y
                
                if let node = createAntiNode(for: (diffX, diffY), from: antennaPair[0], in: .plus, maxX: input.maxX, maxY: input.maxY) {
                    antinodes.insert(node)
                }
                
                if let node = createAntiNode(for: (diffX, diffY), from: antennaPair[1], in: .minus, maxX: input.maxX, maxY: input.maxY) {
                    antinodes.insert(node)
                }
            }
        }
        
        return "\(antinodes.count)"
    }
    
    static func solvePart2(input: ConvertedInput) -> String {
        var antinodes: Set<Pos> = []
        
        for antennas in input.antennas {
            for antennaPair in antennas.value.uniqueCombinations(ofLength: 2) {
                let diffX = antennaPair[0].x - antennaPair[1].x
                let diffY = antennaPair[0].y - antennaPair[1].y
                
                
                antinodes = antinodes.union(createAntiNodes(
                    for: (diffX, diffY),
                    from: antennaPair[0],
                    in: .minus,
                    maxX: input.maxX,
                    maxY: input.maxY
                ))
                
                antinodes = antinodes.union(createAntiNodes(
                    for: (diffX, diffY),
                    from: antennaPair[1],
                    in: .plus,
                    maxX: input.maxX,
                    maxY: input.maxY
                ))
            }
        }
        
        return "\(antinodes.count)"
    }
    
    static func createAntiNode(for diff: (x: Int, y: Int), from antenna: Pos, in direction: Direction, maxX: Int, maxY: Int) -> Pos? {
        
        let antinode: Pos
        switch direction {
        case .plus:
            antinode = Pos(x: antenna.x + diff.x, y: antenna.y + diff.y)
        case .minus:
            antinode = Pos(x: antenna.x - diff.x, y: antenna.y - diff.y)
        }
        
        if antinode.x < 0 || antinode.y < 0 || antinode.x >= maxX || antinode.y >= maxY {
            return nil
        } else {
            return antinode
        }
    }
    
    static func createAntiNodes(for diff: (x: Int, y: Int), from antenna: Pos, in direction: Direction, maxX: Int, maxY: Int) -> Set<Pos> {
        var antinodes: Set<Pos> = []
        
        var count = 1
        while true {
            let antinode: Pos
            switch direction {
            case .plus:
                antinode = Pos(x: antenna.x + count * diff.x, y: antenna.y + count * diff.y)
            case .minus:
                antinode = Pos(x: antenna.x - count * diff.x, y: antenna.y - count * diff.y)
            }
            
            if antinode.x < 0 || antinode.y < 0 || antinode.x >= maxX || antinode.y >= maxY {
                break
            } else {
                count += 1
                antinodes.insert(antinode)
            }
        }
        
        return antinodes
    }
}
