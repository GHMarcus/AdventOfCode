//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/11

enum Day_11_2020: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        var map: [[String.Element]] = []
        input.forEach { line in
            map.append(Array(line))
        }

//        map.forEach { print(String($0)) }
//        print()
        var moveOn = true
        while moveOn {
            let result = nextGenerationPart1(for: map)
            moveOn = result.0
            map = result.1
//            map.forEach { print(String($0)) }
//            print()
//            print(moveOn)

        }
        return countOccupiedSeats(for: map)
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[String.Element]] = []
        input.forEach { line in
            map.append(Array(line))
        }

//        map.forEach { print(String($0)) }
//        print()
        var moveOn = true
        while moveOn {
            let result = nextGenerationPart2(for: map)
            moveOn = result.0
            map = result.1
//            map.forEach { print(String($0)) }
//            print()
//            print(moveOn)

        }
        return countOccupiedSeats(for: map)
    }

    private static func countOccupiedSeats(for map: [[String.Element]]) -> String {
        var occupiedSeats = 0
        map.forEach { line in
            occupiedSeats += line.reduce(0, { result, next -> Int in
                if next == "#" {
                    return result + 1
                } else {
                    return result
                }
            })
        }
        return "\(occupiedSeats)"
    }

    private static func nextGenerationPart1(for map: [[String.Element]]) -> (Bool, [[String.Element]]) {
        var somethingChanged = false
        var newMap: [[String.Element]] = map

        for line in 0..<map.count {
            for seat in 0..<map[line].count {
                guard map[line][seat] != "." else { continue }
                switch countOccupiedNeighboursPart1(for: map, line: line, seat: seat) {
                case 0:
                    newMap[line][seat] = "#"
                case let x where x > 3:
                    newMap[line][seat] = "L"
                default:
                    continue
                }
            }
        }

        somethingChanged = newMap != map

        return (somethingChanged, newMap)
    }

    private static func nextGenerationPart2(for map: [[String.Element]]) -> (Bool, [[String.Element]]) {
        var somethingChanged = false
        var newMap: [[String.Element]] = map

        for line in 0..<map.count {
            for seat in 0..<map[line].count {
                guard map[line][seat] != "." else { continue }
                switch countOccupiedNeighboursPart2(for: map, line: line, seat: seat) {
                case 0:
                    newMap[line][seat] = "#"
                case let x where x > 4:
                    newMap[line][seat] = "L"
                default:
                    continue
                }
            }
        }

        somethingChanged = newMap != map

        return (somethingChanged, newMap)
    }

    private static func countOccupiedNeighboursPart2(for map: [[String.Element]], line: Int, seat: Int) -> Int {
        var occupiedNeighbours = 0
        var neighbours: [(Int, Int)] = [
//            (line - 1, seat - 1), (line - 1, seat), (line - 1, seat + 1),
//            (line    , seat - 1),                   (line    , seat + 1),
//            (line + 1, seat - 1), (line + 1, seat), (line + 1, seat + 1)
        ]

        // Links oben
        var newLine = line - 1
        var newSeat = seat - 1
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newLine -= 1
            newSeat -= 1
        }

        // Mitte oben
        newLine = line - 1
        newSeat = seat
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newLine -= 1
        }

        // Rechts oben
        newLine = line - 1
        newSeat = seat + 1
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newLine -= 1
            newSeat += 1
        }

        // Links
        newLine = line
        newSeat = seat - 1
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newSeat -= 1
        }

        // Rechts
        newLine = line
        newSeat = seat + 1
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newSeat += 1
        }

        // Links unten
        newLine = line + 1
        newSeat = seat - 1
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newLine += 1
            newSeat -= 1
        }

        // Mitte unten
        newLine = line + 1
        newSeat = seat
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newLine += 1
        }

        // Rechts unten
        newLine = line + 1
        newSeat = seat + 1
        while newLine >= 0, newSeat >= 0, newLine < map.count, newSeat < map[0].count {
            if map[newLine][newSeat] != "." {
                neighbours.append((newLine, newSeat))
                break
            }
            newLine += 1
            newSeat += 1
        }



        for n in neighbours {
            guard  n.0 >= 0, n.1 >= 0, n.0 < map.count, n.1 < map[0].count else {
                continue
            }
            if map[n.0][n.1] == "#" {
                occupiedNeighbours += 1
            }
        }
        return occupiedNeighbours
    }

    private static func countOccupiedNeighboursPart1(for map: [[String.Element]], line: Int, seat: Int) -> Int {
        var occupiedNeighbours = 0
        let neighbours = [
            (line - 1, seat - 1), (line - 1, seat), (line - 1, seat + 1),
            (line    , seat - 1),                   (line    , seat + 1),
            (line + 1, seat - 1), (line + 1, seat), (line + 1, seat + 1)
        ]
        for n in neighbours {
            guard  n.0 >= 0, n.1 >= 0, n.0 < map.count, n.1 < map[0].count else {
                continue
            }
            if map[n.0][n.1] == "#" {
                occupiedNeighbours += 1
            }
        }
        return occupiedNeighbours
    }
}
