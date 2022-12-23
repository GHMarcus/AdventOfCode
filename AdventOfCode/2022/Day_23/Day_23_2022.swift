//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/23

import Foundation

enum Day_23_2022: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2022

    enum Direction {
        case north, south, west, east
    }

    struct Position: Hashable {
        var x, y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }

    class Elf: Equatable, Hashable {
        static func == (lhs: Day_23_2022.Elf, rhs: Day_23_2022.Elf) -> Bool {
            lhs.number == rhs.number
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(number)
        }

        let number: Int
        var pos: Position

        init(number: Int, pos: Position) {
            self.number = number
            self.pos = pos
        }
    }

    static func solvePart1(input: [String]) -> String {
        var proposedDirections: [Direction] = [.north, .south, .west, .east]
        var elves: Set<Elf> = []
        var number = 0
        for y in 0..<input.count {
            let arr = Array(input[y])
            for x in 0..<arr.count {
                if arr[x] == "#" {
                    elves.insert(Elf(number: number, pos: Position(x, y)))
                    number += 1
                }
            }
        }

        var round = 0

        while true {
            round += 1
            if round > 10 {
                break
            }
            print("Round: \(round)")
            elves = calculateRound(for: elves, with: &proposedDirections)!
        }

        let xs = elves.map { $0.pos }.map { $0.x }
        let ys = elves.map { $0.pos }.map { $0.y }

        let minX = xs.min()!
        let maxX = xs.max()!
        let minY = ys.min()!
        let maxY = ys.max()!

        let allGroundTiles = (abs(minX) + abs(maxX) + 1) * (abs(minY) + abs(maxY) + 1)

        return "\(allGroundTiles-elves.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var proposedDirections: [Direction] = [.north, .south, .west, .east]
        var elves: Set<Elf> = []
        var number = 0
        for y in 0..<input.count {
            let arr = Array(input[y])
            for x in 0..<arr.count {
                if arr[x] == "#" {
                    elves.insert(Elf(number: number, pos: Position(x, y)))
                    number += 1
                }
            }
        }

        var round = 0

        while true {
            if let newElves = calculateRound(for: elves, with: &proposedDirections) {
                elves = newElves
            } else {
                round += 1
                break
            }
            round += 1
            print("Round: \(round)")
        }

        return "\(round)"
    }

    static func calculateRound(for elves: Set<Elf>, with proposedDirections: inout [Direction]) -> Set<Elf>? {
        var elvesWhichWillMove: [Position: [Int]] = [:]
        let elvesPos: Set<Position> = elves.reduce(into: []) { partialResult, elf in
            partialResult.insert(elf.pos)
        }

        for elf in elves {
            var isElfAround = false
            for pos in (getNeighbours(for: nil, from: elf.pos)) {
                if elvesPos.contains(pos) {
                    isElfAround = true
                    break
                }
            }

            if !isElfAround {
                continue
            }

            for direction in proposedDirections {
                var isElfAround = false

                let neighbours = getNeighbours(for: direction, from: elf.pos)
                for pos in neighbours {
                    if elvesPos.contains(pos) {
                        isElfAround = true
                        break
                    }
                }
                if !isElfAround {
                    if var movingElves = elvesWhichWillMove[neighbours.first!] {
                        movingElves.append(elf.number)
                        elvesWhichWillMove[neighbours.first!] = movingElves
                    } else {
                        elvesWhichWillMove[neighbours.first!] = [elf.number]
                    }
                    break
                }
            }
        }

        elvesWhichWillMove = elvesWhichWillMove.filter({ $0.value.count == 1 })

        if elvesWhichWillMove.isEmpty {
            return nil
        }

        var newElves: Set<Elf> = []

        for elf in elvesWhichWillMove {
            let elfNumber = elf.value.first!
            newElves.insert(Elf(number: elfNumber, pos: elf.key))
        }

        for elf in elves {
            newElves.insert(elf)
        }

        let direction = proposedDirections.removeFirst()
        proposedDirections.append(direction)

        return newElves
    }

    static func printMap(with elves: Set<Elf>) {
        let offset = 10
        var map = Array(repeating: Array(repeating: ".", count: offset*2), count: offset*2)
        for elf in elves {
            map[elf.pos.y + offset][elf.pos.x + offset] = "#"
        }

        map.forEach {
            print($0.joined())
        }
        print("-------------------")
    }

    static func getNeighbours(for direction: Direction?, from pos: Position) -> [Position] {
        if let direction = direction {
            switch direction {
            case .north:
                return [
                    Position(pos.x, pos.y-1),
                    Position(pos.x+1, pos.y-1),
                    Position(pos.x-1, pos.y-1)
                ]
            case .south:
                return [
                    Position(pos.x, pos.y+1),
                    Position(pos.x+1, pos.y+1),
                    Position(pos.x-1, pos.y+1)
                ]
            case .west:
                return [
                    Position(pos.x-1, pos.y),
                    Position(pos.x-1, pos.y+1),
                    Position(pos.x-1, pos.y-1)
                ]
            case .east:
                return [
                    Position(pos.x+1, pos.y),
                    Position(pos.x+1, pos.y+1),
                    Position(pos.x+1, pos.y-1)
                ]
            }
        } else {
            return [
                Position(pos.x, pos.y-1),
                Position(pos.x+1, pos.y-1),
                Position(pos.x-1, pos.y-1),
                Position(pos.x, pos.y+1),
                Position(pos.x+1, pos.y+1),
                Position(pos.x-1, pos.y+1),
                Position(pos.x-1, pos.y),
                Position(pos.x+1, pos.y),
            ]
        }
    }
}


// 923 -> high
// 922 -> high
