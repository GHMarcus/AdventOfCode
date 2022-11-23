//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/6

enum Day_6_2018: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2018
    
//    static var finitePositions: [Position] = []
    
    struct Position: Hashable {
        let x: Int
        let y: Int
        
        init(posStr: String) {
            let components = posStr.components(separatedBy: ", ")
            x = Int(components[0])!
            y = Int(components[1])!
        }
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }

    static func solvePart1(input: [String]) -> String {
        let coordinates = input.map { Position(posStr: $0) }
        
        let maxX = coordinates.max{ $0.x < $1.x }!.x
        let maxY = coordinates.max{ $0.y < $1.y }!.y
        
        var closestPointsByPosition: [Position: [(Int, Int)]] = coordinates.reduce([:]) { partialResult, pos in
            var newResult = partialResult
            newResult.updateValue([], forKey: pos)
            return newResult
        }
        
        for x in 0...maxX {
            for y in 0...maxY {
                var closestPoints: [Position] = []
                for pos in coordinates {
                    let distanceToCurrentPoint = abs(x-pos.x) + abs(y-pos.y)
                    if let closestPointUnwraped = closestPoints.first {
                        let distanceToClosestPoint = abs(x-closestPointUnwraped.x) + abs(y-closestPointUnwraped.y)
                        if distanceToClosestPoint == distanceToCurrentPoint {
                            closestPoints.append(pos)
                        } else if distanceToClosestPoint > distanceToCurrentPoint {
                            closestPoints = [pos]
                        }
                    } else {
                        closestPoints = [pos]
                    }
                }
                if closestPoints.count == 1 {
                    closestPointsByPosition[closestPoints[0]]?.append((x,y))
                }
            }
        }
        
        closestPointsByPosition = closestPointsByPosition.reduce([:]) {
            if $1.value.contains(where: { $0.0 == maxX }) || $1.value.contains(where: { $0.1 == maxY }) || $1.value.contains(where: { $0.0 == 0 }) || $1.value.contains(where: { $0.1 == 0 }) {
                return $0
            } else {
                var newResult = $0
                newResult.updateValue($1.value, forKey: $1.key)
                return newResult
            }
        }
        
        var largestFiniteArea = 0
        
        for entry in closestPointsByPosition {
            if entry.value.count > largestFiniteArea {
                largestFiniteArea = entry.value.count
            }
        }
        
        return "\(largestFiniteArea)"
    }

    static func solvePart2(input: [String]) -> String {
        let coordinates = input.map { Position(posStr: $0) }
        
        let maxX = coordinates.max{ $0.x < $1.x }!.x
        let maxY = coordinates.max{ $0.y < $1.y }!.y
        
        let sumMax = 10000

        var points: [Position] = []
        
        for x in 0...maxX {
            for y in 0...maxY {
                var distanceSum = 0
                var foundPoint = true
                for pos in coordinates {
                    distanceSum += abs(x-pos.x) + abs(y-pos.y)
                    if distanceSum >= sumMax {
                        foundPoint = false
                        break
                    }
                }
                if foundPoint {
                    points.append(Position(x: x, y: y))
                }
            }
        }

        return "\(points.count)"
    }
}
