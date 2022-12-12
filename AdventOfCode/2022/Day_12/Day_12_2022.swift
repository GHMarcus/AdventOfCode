//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/12

enum Day_12_2022: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2022

    struct Position: Equatable, Hashable {
        let x,y: Int

        func distance(from start: Position, to destination: Position) -> (Int,Int) {
            let destDistance = abs(x-destination.x) + abs(y-destination.y)
            let startDistance = abs(x-start.x) + abs(y-start.y)

            return (destDistance, startDistance)
        }
    }

    class Node: Equatable, Hashable {
        static func == (lhs: Node, rhs: Node) -> Bool {
            lhs.pos == rhs.pos
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(pos)
        }

        init(parent: Node? = nil, pos: Position, g: Int = 0, h: Int = 0, f: Int = 0) {
            self.parent = parent
            self.pos = pos
            self.g = g
            self.h = h
            self.f = f
        }

        var parent: Node? = nil
        var pos: Position
        var g: Int
        var h: Int
        var f: Int
    }

    static func solvePart1(input: [String]) -> String {
        var map: [[Character]] = []

        var start: Position = Position(x: 0, y: 0)
        var destination: Position = Position(x: 0, y: 0)

        for l in 0..<input.count {
            let line = Array(input[l])//.map { String($0) }
            if let startX = line.firstIndex(of: "S") {
                start = Position(x: startX, y: l)
            }
            if let destinationX = line.firstIndex(of: "E") {
                destination = Position(x: destinationX, y: l)
            }
            map.append(line)
        }

        // Replace start and destination with the right elevation
        map[start.y][start.x] = "a"
        map[destination.y][destination.x] = "z"

        let path = aStarPathfinding(startPos: start, destinationPos: destination, field: map)
        return "\(path.count-1)"
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[Character]] = []

        var start: Position = Position(x: 0, y: 0)
        var destination: Position = Position(x: 0, y: 0)

        for l in 0..<input.count {
            let line = Array(input[l])//.map { String($0) }
            if let startX = line.firstIndex(of: "S") {
                start = Position(x: startX, y: l)
            }
            if let destinationX = line.firstIndex(of: "E") {
                destination = Position(x: destinationX, y: l)
            }
            map.append(line)
        }

        // Replace start and destination with the right elevation
        map[start.y][start.x] = "a"
        map[destination.y][destination.x] = "z"

        var starts: [Position] = []
        for y in 0..<map.count {
            for x in 0..<map[0].count {
                if map[y][x] ==  "a" {
                    starts.append(Position(x: x, y: y))
                }
            }
        }

        var pathes: [Int] = []

        for s in starts {
            let path = aStarPathfinding(startPos: s, destinationPos: destination, field: map)
            if path.count > 0 {
                pathes.append(path.count-1)
            }
        }

        return "\(pathes.min()!)"
    }

    static func findNeighbours(for pos: Position, in map: [[Character]]) -> [(Position, Character)] {
        let currentElevation = map[pos.y][pos.x].letterValue!
        let neighboursPos = [
            Position(x: pos.x, y: pos.y-1),
            Position(x: pos.x-1, y: pos.y),
            Position(x: pos.x+1, y: pos.y),
            Position(x: pos.x, y: pos.y+1)
        ]

        var neighbours: [(Position, Character)] = []
        for neighbour in neighboursPos {
            if neighbour.x >= 0 && neighbour.y >= 0 && neighbour.x < map[0].count && neighbour.y < map.count {
                let heightDiff = map[neighbour.y][neighbour.x].letterValue! - currentElevation
                if heightDiff <= 1 {
                    neighbours.append((neighbour, map[neighbour.y][neighbour.x]))
                }
            }
        }

        return neighbours
    }

    static func aStarPathfinding(
        startPos: Position,
        destinationPos: Position,
        field: [[Character]]
    ) -> [Position] {
        let startNode = Node(pos: startPos)
        let destinationNode = Node(pos: destinationPos)

        var openList: Set<Node> = [startNode]
        var closedList: Set<Node> = []

        while !openList.isEmpty {
            // Get current node
            var currentNode = openList.first!

            for node in openList {
                if node.f < currentNode.f {
                    currentNode = node
                }
            }

            // Pop current off open list, add to closed list
            openList.remove(currentNode)
            closedList.insert(currentNode)

            // Found the goal
            if currentNode == destinationNode {
                var current = currentNode
                var path: [Position] = [current.pos]
                while let parent = current.parent {
                    path.append(parent.pos)
                    current = parent
                }
                return path.reversed()
            }

            // Generate children
            var children: [Node] = []

            for neighbour in Day_12_2022.findNeighbours(for: currentNode.pos, in: field) {
                children.append(Node(parent: currentNode, pos: neighbour.0))
            }

            // Loop through children
            for child in children {

                // Child is on the closed list
                if closedList.contains(child) {
                    continue
                }

                // Create f, g, h
                // for coast = 2
                child.g = currentNode.g + 2
                child.h = (abs(destinationNode.pos.x - child.pos.x) + abs(destinationNode.pos.y - child.pos.y))
                child.f = child.g + child.h


                if let index = openList.firstIndex(where: { $0.pos == child.pos }),
                   let existingChild = openList.get(index),
                   child.g > existingChild.g {
                    continue
                }

                // Add the child to the open list
                openList.insert(child)
            }
        }

        return []
    }

}
