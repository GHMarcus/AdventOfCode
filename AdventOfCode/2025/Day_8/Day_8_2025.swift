//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/8

import Foundation

enum Day_8_2025: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [Pos]

    struct Pos: Equatable, Hashable {
        let x, y, z: Int

        func distance(to other: Pos) -> Int {
//            sqrt(powl((x-other.x), 2) + powl((y-other.y), 2) + powl((z-other.z), 2))
            (x-other.x) * (x-other.x) + (y-other.y) * (y-other.y) + (z-other.z) * (z-other.z)
        }
    }

    struct Connection: Hashable {
        let boxes: Set<Pos>
        let distance: Int
    }

    static func convert(input: [String]) -> ConvertedInput {
        var positions: [Pos] = []
        for line in input {
            let cmp = line.components(separatedBy: ",")
            positions.append(Pos(x: Int(cmp[0])!, y: Int(cmp[1])!, z: Int(cmp[2])!))
        }
        return positions
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var connections: Set<Connection> = []
        let connectionsCount = 1000

        for comb in input.uniqueCombinations(ofLength: 2) {
            connections.insert(Connection(boxes: Set(comb), distance: comb[0].distance(to: comb[1])))
        }

        var sortedConnections = connections.sorted{ $0.distance < $1.distance }

        var circuits: [Set<Pos>] = []
        for _ in 0..<connectionsCount {
            let new = sortedConnections.removeFirst()
            if let index = circuits.firstIndex(where: { !$0.intersection(new.boxes).isEmpty }) {
                circuits[index].formUnion(new.boxes)
            } else {
                circuits.append(new.boxes)
            }
            circuits = mergeCircuits(circuits)
        }

        let longestCircuits = circuits.map({ $0.count }).sorted(by: >)[0...2]

        return "\(longestCircuits.reduce(1, *))"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var connections: Set<Connection> = []

        for comb in input.uniqueCombinations(ofLength: 2) {
            connections.insert(Connection(boxes: Set(comb), distance: comb[0].distance(to: comb[1])))
        }

        var sortedConnections = connections.sorted{ $0.distance < $1.distance }

        var circuits: [Set<Pos>] = []
        var productOfTheLastConnection: Int = 0
        while !sortedConnections.isEmpty {
            let new = sortedConnections.removeFirst()
            if let index = circuits.firstIndex(where: { !$0.intersection(new.boxes).isEmpty }) {
                circuits[index].formUnion(new.boxes)
            } else {
                circuits.append(new.boxes)
            }
            circuits = mergeCircuits(circuits)

            if circuits.first!.count == input.count {
                productOfTheLastConnection = new.boxes.reduce(into: 1) {
                    $0 *= $1.x
                }
                break
            }
        }

        return "\(productOfTheLastConnection)"
    }

    static func mergeCircuits(_ circuits: [Set<Pos>]) -> [Set<Pos>] {
        var result: [Set<Pos>] = []

        for current in circuits {
            var mergedSet = current
            var i = 0
            while i < result.count {
                if !result[i].isDisjoint(with: mergedSet) {
                    mergedSet.formUnion(result[i])
                    result.remove(at: i)
                } else {
                    i += 1
                }
            }

            result.append(mergedSet)
        }

        if result.count < circuits.count {
            return mergeCircuits(result)
        }

        return result
    }
}
