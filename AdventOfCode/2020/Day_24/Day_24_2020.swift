//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/24

import Foundation

enum Day_24_2020: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2020

    struct Pos: Hashable {
        let x: Decimal
        let y: Decimal
    }

    static var tiles: Dictionary<Pos, Bool> = [:]
    static var newTiles: Dictionary<Pos, Bool> = [:]

    static func solvePart1(input: [String]) -> String {
        let start = Pos(x: 0.0,y: 0.0)
        tiles[start] = false
        var current = start
        for line in input {
            current = start
            var directions = Array(line)
//            var dStr = ""
            while !directions.isEmpty {
                var direction = String(directions.removeFirst())
                if direction == "s" || direction == "n" {
                    direction += String(directions.removeFirst())
                }
//                dStr += " " + direction
                switch direction {
                case "e":
                    current = Pos(x: current.x+1.0, y: current.y)
                case "w":
                    current = Pos(x: current.x-1.0, y: current.y)
                case "se":
                    let yShift = current.y + 1.0
                    let xShift = current.x + 0.5
                    current = Pos(x: xShift, y: yShift)
                case "sw":
                    let yShift = current.y + 1.0
                    let xShift = current.x - 0.5
                    current = Pos(x: xShift, y: yShift)
                case "ne":
                    let yShift = current.y - 1.0
                    let xShift = current.x + 0.5
                    current = Pos(x: xShift, y: yShift)
                case "nw":
                    let yShift = current.y - 1.0
                    let xShift = current.x - 0.5
                    current = Pos(x: xShift, y: yShift)
                default:
                    fatalError("Should never be executed")
                }
            }
//            print("\(current): \(dStr)")
            if var tile = tiles[current] {
                tile.toggle()
                tiles[current] = tile
            } else {
                tiles[current] = true
            }
        }
//        print(tiles.count)
//        print(tiles.filter({ $0.value }).count)
        return "\(tiles.filter({ $0.value }).count)"
    }

    static func solvePart2(input: [String]) -> String {
        var day = 0
        let maxDay = 100

        while day < maxDay {
            newTiles = [:]

            for tile in tiles {
                addAllNewNeighbours(for: tile.key)
            }

            for tile in tiles {
                let neighbours = getNeighbours(for: tile.key).filter{$0}
                if tile.value && neighbours.count == 0 {
                    newTiles[tile.key] = false
                } else if tile.value && neighbours.count > 2 {
                    newTiles[tile.key] = false
                }else if !tile.value && neighbours.count == 2 {
                    newTiles[tile.key] = true
                } else {
                    newTiles[tile.key] = tile.value
                }
            }
            tiles = newTiles
            day += 1
            //print("Day \(day): \(tiles.filter({ $0.value }).count)")
        }

        return "\(tiles.filter({ $0.value }).count)"
    }

    static func getNeighbours(for tilePos: Pos) -> [Bool] {
        var neighbours: [Bool] = []
        let positions = [
            Pos(x: tilePos.x-1, y: tilePos.y),
            Pos(x: tilePos.x-0.5, y: tilePos.y-1),
            Pos(x: tilePos.x+0.5, y: tilePos.y-1),
            Pos(x: tilePos.x+1, y: tilePos.y),
            Pos(x: tilePos.x+0.5, y: tilePos.y+1),
            Pos(x: tilePos.x-0.5, y: tilePos.y+1)
        ]

        for pos in positions {
            if let value = tiles[pos] {
                neighbours.append(value)
            } else {
                neighbours.append(false)
            }
        }

        return neighbours
    }

    static func addAllNewNeighbours(for tilePos: Pos) {
        let positions = [
            Pos(x: tilePos.x-1, y: tilePos.y),
            Pos(x: tilePos.x-0.5, y: tilePos.y-1),
            Pos(x: tilePos.x+0.5, y: tilePos.y-1),
            Pos(x: tilePos.x+1, y: tilePos.y),
            Pos(x: tilePos.x+0.5, y: tilePos.y+1),
            Pos(x: tilePos.x-0.5, y: tilePos.y+1)
        ]

        for pos in positions {
            if tiles[pos] == nil {
                tiles[pos] = false
            }
        }
    }
}
