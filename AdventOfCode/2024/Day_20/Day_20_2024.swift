//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/20

enum Day_20_2024: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (track: [Pos], walls: Set<Pos>, maxX: Int, maxY: Int)
    
    struct Cheat: Hashable {
        let pos: Pos
        let duration: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(pos.x)
            hasher.combine(pos.y)
        }
    }
    
    class Pos: Hashable, Equatable {
        static func == (lhs: Day_20_2024.Pos, rhs: Day_20_2024.Pos) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        let x, y: Int
        
        var neighbors: Set<Pos> {
            [
                Pos(x: x - 1, y: y),
                Pos(x: x + 1, y: y),
                Pos(x: x, y: y - 1),
                Pos(x: x, y: y + 1)
            ]
        }
        
        var desc: String {
            "(\(x),\(y))"
        }
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
        
        func getTrackNeighbors(for track: [Pos], maxX: Int, maxY: Int) -> [Pos] {
            neighbors
                .filter{ $0.x >= 0 && $0.x <= maxX && $0.y >= 0 && $0.y <= maxY }
                .filter{ n in track.contains { n.x == $0.x && n.y == $0.y}}
        }
        
        func getCheats(for track: [Pos], duration: Int) -> Set<Cheat> {
            var cheats: Set<Cheat> = []
            for y in -duration...duration {
                for x in -duration...duration {
                    //if x <= 0 && y <= 0 { continue }
                    if abs(x) + abs(y) <= duration {
                        let newX = x + self.x
                        let newY = y + self.y
                        if newX <= 0 && newY <= 0 { continue }
                        if track.contains(where: { newX == $0.x && newY == $0.y} ) {
                            cheats.insert(Cheat(pos: Pos(x: newX, y: newY), duration: abs(x) + abs(y)))
                        }
                    }
                }
            }
            return cheats
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        let map = input.map { Array($0) }
        var walls: Set<Pos> = []
        var track: Set<Pos> = []
        var start = Pos(x: 0, y: 0)
        var end = Pos(x: 0, y: 0)
        
        for y in 0..<map.count {
            for x in 0..<map[0].count {
                if map[y][x] == "#" {
                    walls.insert(Pos(x: x, y: y))
                } else if map[y][x] == "S" {
                    start = Pos(x: x, y: y)
                    track.insert(Pos(x: x, y: y))
                } else if map[y][x] == "E" {
                    end = Pos(x: x, y: y)
                    track.insert(Pos(x: x, y: y))
                } else {
                    track.insert(Pos(x: x, y: y))
                }
            }
        }
        
        let finalTrack = aStar(
            start: start,
            goal: end,
            neighbors: { $0.neighbors.intersection(track) }
        )
        
        return (finalTrack ?? [], walls, map[0].count, map.count)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var cheatsByTime: [Int: Int] = [:]
        
        for (index, position) in input.track.enumerated() {
            print(index, " / ", input.track.count)
            
            for cheat in position.getCheats(for: input.track, duration: 2) {
                let secondIndex = input.track.firstIndex(of: cheat.pos)!
                if secondIndex < index + 2 { continue }
                let time = secondIndex - index - cheat.duration
                if time <= 0 { continue }
                if let existing = cheatsByTime[time] {
                    cheatsByTime[time] = existing + 1
                } else {
                    cheatsByTime[time] = 1
                }
            }
        }
        
        var bestCheats = 0
        cheatsByTime.forEach {
            if $0.key >= 100 {
                bestCheats += $0.value
            }
        }
        
        return "\(bestCheats)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        return ""
        var cheatsByTime: [Int: Int] = [:]
        
        for (index, position) in input.track.enumerated() {
            for cheat in position.getCheats(for: input.track, duration: 20) {
                let secondIndex = input.track.firstIndex(of: cheat.pos)!
                if secondIndex < index + 2 { continue }
                let time = secondIndex - index - cheat.duration
                if time <= 0 { continue }
                if let existing = cheatsByTime[time] {
                    cheatsByTime[time] = existing + 1
                } else {
                    cheatsByTime[time] = 1
                }
            }
        }
        
        var bestCheats = 0
        cheatsByTime.forEach {
            if $0.key >= 100 {
                bestCheats += $0.value
            }
        }
        
        return "\(bestCheats)"
    }
}
