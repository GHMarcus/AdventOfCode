//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/20

// Took 617.3711260557175 seconds (even with task group)
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

        func getCheats(for track: [Pos], duration: Int, maxX: Int, maxY: Int) -> Set<Cheat> {
            var cheats: Set<Cheat> = []
            for y in -duration...duration {
                let xMax = duration - abs(y)
                for x in -xMax...xMax {
                    let newX = x + self.x
                    let newY = y + self.y

                    guard newX > 0 && newY > 0 && newX < maxX && newY < maxY else { continue }

                    if x != 0 || y != 0 {
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
        Task {
            let cheatsByTime = await calculateCheatsByTime(
                for: input.track,
                duration: 2,
                maxX: input.maxX,
                maxY: input.maxX
            )
            
            var bestCheats = 0
            cheatsByTime.forEach {
                if $0.key >= 100 {
                    bestCheats += $0.value
                }
            }
            
            print(bestCheats)
        }

        return "Wait for async print of the best cheats"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        Task { @MainActor in
            let cheatsByTime = await calculateCheatsByTime(
                for: input.track,
                duration: 20,
                maxX: input.maxX,
                maxY: input.maxX
            )
            
            var bestCheats = 0
            cheatsByTime.forEach {
                if $0.key >= 100 {
                    bestCheats += $0.value
                }
            }
            
            print(bestCheats)
        }

        return "Wait for async print of the best cheats"
    }
    
    static func calculateCheatsByTime(for track: [Pos], duration: Int, maxX: Int, maxY: Int) async -> [Int: Int] {
        var cheatsByTime: [Int: Int] = [:]
        await withTaskGroup(of: [Int: Int].self) { group in
            for (index, position) in track.enumerated() {
                group.addTask {
                    var cheatsByTime: [Int: Int] = [:]
                    for cheat in position.getCheats(for: track, duration: duration, maxX: maxX, maxY: maxY) {
                        let secondIndex = track.firstIndex(of: cheat.pos)!
                        if secondIndex < index + 2 { continue }
                        let time = secondIndex - index - cheat.duration
                        if time <= 0 { continue }
                        if let existing = cheatsByTime[time] {
                            cheatsByTime[time] = existing + 1
                        } else {
                            cheatsByTime[time] = 1
                        }
                    }
                    return cheatsByTime
                }
            }
            
            for await taskCheatsByTime in group {
                for (time, value) in taskCheatsByTime {
                    let existingValue = cheatsByTime[time] ?? 0
                    cheatsByTime[time] = existingValue + value
                }
            }
        }
        return cheatsByTime
    }
}
