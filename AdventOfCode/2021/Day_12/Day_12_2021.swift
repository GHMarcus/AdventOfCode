//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

import Foundation

// https://adventofcode.com/2021/day/12

enum Day_12_2021: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2021

    static var pathsFoundPart1 = 0
    static var pathsFoundPart2 = 0

    struct Cave {
        let name: String
        let isSmall: Bool
        var visited: Int
        var neighbours: Set<String>

        init(name: String, isSmall: Bool, neighbour: String) {
            self.name = name
            self.isSmall = isSmall
            visited = 0
            neighbours = [neighbour]
        }

        mutating func visit() {
            visited += 1
        }
    }

    static func solvePart1(input: [String]) -> String {
        var caves: [Cave] = []

        for line in input {
            let comps = line.components(separatedBy: "-")
            if let index = caves.firstIndex(where: { $0.name == comps[0] }) {
                caves[index].neighbours.insert(comps[1])
            } else {
                let isSmall = comps[0].first! > "a" && comps[0].first! < "z"
                caves.append(Cave(name: comps[0], isSmall: isSmall, neighbour: comps[1]))
            }

            if let index = caves.firstIndex(where: { $0.name == comps[1] }) {
                caves[index].neighbours.insert(comps[0])
            } else {
                let isSmall = comps[1].first! >= "a" && comps[1].first! <= "z"
                caves.append(Cave(name: comps[1], isSmall: isSmall, neighbour: comps[0]))
            }
        }

        let startIndex = caves.firstIndex {$0.name == "start"}!
        caves[startIndex].visit()
        for neighbour in caves[startIndex].neighbours {
            let index = caves.firstIndex{$0.name == neighbour}!
            findPathsPart1(index: index, caves: caves)
        }

        return "\(pathsFoundPart1)"
    }

    static func solvePart2(input: [String]) -> String {
        var caves: [Cave] = []

        for line in input {
            let comps = line.components(separatedBy: "-")
            if let index = caves.firstIndex(where: { $0.name == comps[0] }) {
                caves[index].neighbours.insert(comps[1])
            } else {
                let isSmall = comps[0].first! > "a" && comps[0].first! < "z"
                caves.append(Cave(name: comps[0], isSmall: isSmall, neighbour: comps[1]))
            }

            if let index = caves.firstIndex(where: { $0.name == comps[1] }) {
                caves[index].neighbours.insert(comps[0])
            } else {
                let isSmall = comps[1].first! >= "a" && comps[1].first! <= "z"
                caves.append(Cave(name: comps[1], isSmall: isSmall, neighbour: comps[0]))
            }
        }

        let startIndex = caves.firstIndex {$0.name == "start"}!
        caves[startIndex].visit()
        caves[startIndex].visit()
        for neighbour in caves[startIndex].neighbours {
            let index = caves.firstIndex{$0.name == neighbour}!
            findPathsPart2(index: index, caves: caves, twiceVisitedCave: nil)
        }

        return "\(pathsFoundPart2)"
    }

    static func findPathsPart1(index: Array.Index, caves: [Cave]) {
        var caves = caves
        let currentCave = caves[index]
        if currentCave.name == "end" {
            pathsFoundPart1 += 1
            return
        }
        if currentCave.isSmall && currentCave.visited > 0 {
            return
        }
        caves[index].visit()
        for neighbour in currentCave.neighbours {
            let newIndex = caves.firstIndex{$0.name == neighbour}!
            findPathsPart1(index: newIndex, caves: caves)
        }
    }

    static func findPathsPart2(index: Array.Index, caves: [Cave], twiceVisitedCave: String?) {
        var caves = caves
        var twiceVisitedCave = twiceVisitedCave
        let currentCave = caves[index]
        if currentCave.name == "end" {
            pathsFoundPart2 += 1
            return
        }

        if let cave = twiceVisitedCave {
            if currentCave.name == cave {
                if currentCave.visited > 1 {
                    return
                }
            } else {
                if currentCave.isSmall, currentCave.visited > 0 {
                    return
                }
            }
        } else {
            if currentCave.isSmall, currentCave.visited > 0 {
                twiceVisitedCave = currentCave.name
            }
        }

        if currentCave.name == "start" {
            return
        }

        caves[index].visit()
        for neighbour in currentCave.neighbours {
            let newIndex = caves.firstIndex{$0.name == neighbour}!
            findPathsPart2(index: newIndex, caves: caves, twiceVisitedCave: twiceVisitedCave)
        }
    }
}
