//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/18

enum Day_18_2018: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2018
    
    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    
    enum Acre: String, Hashable {
        case open = "."
        case tree = "|"
        case lumberyard = "#"
    }
    
    static func convert(input: [String]) -> [Pos: Acre] {
        var acres: [Pos: Acre] = [:]
        for (y, line) in input.enumerated() {
            for (x, char) in line.enumerated() {
                let pos = Pos(x: x, y: y)
                let acre = Acre(rawValue: String(char))!
                acres[pos] = acre
            }
        }
        
        return acres
    }

    static func solvePart1(input: [Pos: Acre]) -> String {
        var minutes = 0
        var currentAcres = input
        while minutes < 10 {
            currentAcres = run(currentAcres)
            minutes += 1
        }
        let trees = currentAcres.values.filter { $0 == .tree }
        let lumberyards = currentAcres.values.filter { $0 == .lumberyard }
        let resourceValue = trees.count * lumberyards.count
        return "\(resourceValue)"
    }

    static func solvePart2(input: [Pos: Acre]) -> String {
        var minutes = 0
        var mem: Set<[Pos: Acre]> = [input]
        var cache: [Int: [Acre]] = [:]
        var currentAcres = input
        while true {
            cache[minutes] = Array(currentAcres.values)
            currentAcres = run(currentAcres)
            if !mem.insert(currentAcres).inserted {
                print("Loop Found after \(minutes)")
                break
            }
            minutes += 1
        }
        
        let finalMinutes = 1000000000 % minutes
        let finalAcres = cache[finalMinutes]!
        
        let trees = finalAcres.filter { $0 == .tree }
        let lumberyards = finalAcres.filter { $0 == .lumberyard }
        let resourceValue = trees.count * lumberyards.count
        return "\(resourceValue)"
    }
    
    static func getNeighbors(pos: Pos, in grid: [Pos: Acre]) -> [Acre] {
        [
            grid[Pos(x: pos.x, y: pos.y+1)],
            grid[Pos(x: pos.x, y: pos.y-1)],
            grid[Pos(x: pos.x+1, y: pos.y)],
            grid[Pos(x: pos.x-1, y: pos.y)],
            grid[Pos(x: pos.x-1, y: pos.y-1)],
            grid[Pos(x: pos.x+1, y: pos.y+1)],
            grid[Pos(x: pos.x-1, y: pos.y+1)],
            grid[Pos(x: pos.x+1, y: pos.y-1)]
        ].compactMap {$0}
    }
    
    static func run(_ acres: [Pos: Acre]) -> [Pos: Acre] {
        var newAcres: [Pos: Acre] = [:]
        for (pos, acre) in acres {
            let neighbors = getNeighbors(pos: pos, in: acres)
            let trees = neighbors.filter { $0 == .tree }
            let lumberyards = neighbors.filter { $0 == .lumberyard }
            switch acre {
            case .open:
                if trees.count >= 3 {
                    newAcres[pos] = .tree
                } else {
                    newAcres[pos] = .open
                }
            case .tree:
                if lumberyards.count >= 3 {
                    newAcres[pos] = .lumberyard
                } else {
                    newAcres[pos] = .tree
                }
            case .lumberyard:
                if !lumberyards.isEmpty && !trees.isEmpty {
                    newAcres[pos] = .lumberyard
                } else {
                    newAcres[pos] = .open
                }
            }
        }
        
        return newAcres
    }
    
    static func printArces(_ arces: [Pos: Acre]) {
        var map = Array(repeating: Array(repeating: "", count: 10), count: 10)
        for (pos, acre) in arces {
            map[Int(pos.y)][Int(pos.x)] = acre.rawValue
        }
        map.forEach {
            print($0.joined())
        }
        print()
    }
}
