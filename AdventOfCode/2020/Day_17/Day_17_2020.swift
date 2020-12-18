//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/17

enum Day_17_2020: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2020

    struct CoordinatePart1: Hashable {
        let x: Int
        let y: Int
        let z: Int
    }

    struct CoordinatePart2: Hashable {
        let x: Int
        let y: Int
        let z: Int
        let w: Int
    }

    static func solvePart1(input: [String]) -> String {
        var coords: Dictionary<CoordinatePart1, String> = [:]
        for (y, line) in input.enumerated() {
            for (x, c) in Array(line).enumerated() {
                coords[CoordinatePart1(x: x, y: y, z: 0)] = String(c)
            }
        }

        var count = 0
        while count < 6 {
            var newCoords: Dictionary<CoordinatePart1, String> = [:]
            var resultingCoords: Dictionary<CoordinatePart1, String> = [:]
            for coord in coords {
                let neighbours = getAllNeighboursPart1(for: coord.key)
                for neighbour in neighbours {
                    if let state = coords[neighbour] {
                        if state == "#" {
                            newCoords[neighbour] = "#"
                        } else {
                            newCoords[neighbour] = "."
                        }
                    } else {
                        newCoords[neighbour] = "."
                    }
                }
            }

            for coord in newCoords {
                let neighbours = getAllNeighboursPart1(for: coord.key)
                var activeNeighbours = 0
                for neighbour in neighbours {
                    if let state = newCoords[neighbour] {
                        if state == "#" {
                            activeNeighbours += 1
                        }
                    }
                }

                if coord.value == "#" {
                    if activeNeighbours == 2 || activeNeighbours == 3 {
                        resultingCoords[coord.key] = "#"
                    } else {
                        resultingCoords[coord.key] = "."
                    }
                } else {
                    if activeNeighbours == 3 {
                        resultingCoords[coord.key] = "#"
                    } else {
                        resultingCoords[coord.key] = "."
                    }
                }
            }
            coords = resultingCoords

//            for c in resultingCoords {
//                if c.value == "#" {
//                    print("x:\(c.key.x) y:\(c.key.y) z:\(c.key.z) state: \(c.value)")
//                }
//            }

            count += 1
        }

        let activeCoords = coords.filter { $0.value == "#" }

        return "\(activeCoords.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var coords: Dictionary<CoordinatePart2, String> = [:]
        for (y, line) in input.enumerated() {
            for (x, c) in Array(line).enumerated() {
                coords[CoordinatePart2(x: x, y: y, z: 0, w: 0)] = String(c)
            }
        }

        var count = 0
        while count < 6 {
            var newCoords: Dictionary<CoordinatePart2, String> = [:]
            var resultingCoords: Dictionary<CoordinatePart2, String> = [:]
            for coord in coords {
                let neighbours = getAllNeighboursPart2(for: coord.key)
                for neighbour in neighbours {
                    if let state = coords[neighbour] {
                        if state == "#" {
                            newCoords[neighbour] = "#"
                        } else {
                            newCoords[neighbour] = "."
                        }
                    } else {
                        newCoords[neighbour] = "."
                    }
                }
            }

            for coord in newCoords {
                let neighbours = getAllNeighboursPart2(for: coord.key)
                var activeNeighbours = 0
                for neighbour in neighbours {
                    if let state = newCoords[neighbour] {
                        if state == "#" {
                            activeNeighbours += 1
                        }
                    }
                }

                if coord.value == "#" {
                    if activeNeighbours == 2 || activeNeighbours == 3 {
                        resultingCoords[coord.key] = "#"
                    } else {
                        resultingCoords[coord.key] = "."
                    }
                } else {
                    if activeNeighbours == 3 {
                        resultingCoords[coord.key] = "#"
                    } else {
                        resultingCoords[coord.key] = "."
                    }
                }
            }
            coords = resultingCoords

//            for c in resultingCoords {
//                if c.value == "#" {
//                    print("x:\(c.key.x) y:\(c.key.y) z:\(c.key.z) state: \(c.value)")
//                }
//            }

            count += 1
        }

        let activeCoords = coords.filter { $0.value == "#" }

        return "\(activeCoords.count)"
    }

    static func getAllNeighboursPart1(for coord: CoordinatePart1) -> [CoordinatePart1] {
        var neighbours: [CoordinatePart1] = []
        for x in coord.x-1...coord.x+1 {
            for y in coord.y-1...coord.y+1 {
                for z in coord.z-1...coord.z+1 {
                    if coord.x == x && coord.y == y && coord.z == z {
                        continue
                    }
                    neighbours.append(CoordinatePart1(x: x, y: y, z: z))
                }
            }
        }

        return neighbours
    }

    static func getAllNeighboursPart2(for coord: CoordinatePart2) -> [CoordinatePart2] {
        var neighbours: [CoordinatePart2] = []
        for x in coord.x-1...coord.x+1 {
            for y in coord.y-1...coord.y+1 {
                for z in coord.z-1...coord.z+1 {
                    for w in coord.w-1...coord.w+1 {
                        if coord.x == x && coord.y == y && coord.z == z && coord.w == w {
                            continue
                        }
                        neighbours.append(CoordinatePart2(x: x, y: y, z: z, w: w))
                    }
                }
            }
        }

        return neighbours
    }
}
