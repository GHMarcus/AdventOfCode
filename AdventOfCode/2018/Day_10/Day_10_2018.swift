//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/10

enum Day_10_2018: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2018
    
    static var seconds = 0
    
    class Point {
        var x: Int
        var y: Int
        let vX: Int
        let vY: Int
        
        init(line: String) {
            // position=< 9,  1> velocity=< 0,  2>
            let line = line.replacingOccurrences(of: " ", with: "")
            let openIndices = line.indices(of: "<")
            let closeIndices = line.indices(of: ">")
            let seperatorIndices = line.indices(of: ",")
            x = Int(String(line[openIndices[0]..<seperatorIndices[0]].dropFirst()))!
            y = Int(String(line[seperatorIndices[0]..<closeIndices[0]].dropFirst()))!
            vX = Int(String(line[openIndices[1]..<seperatorIndices[1]].dropFirst()))!
            vY = Int(String(line[seperatorIndices[1]..<closeIndices[1]].dropFirst()))!
        }
        
        func drift() {
            x += vX
            y += vY
        }
    }

    static func solvePart1(input: [String]) -> String {
        
        var points: [Point] = []
        
        for line in input {
            points.append(Point(line: line))
        }
        
        for i in 0...11000 {
            let max = points.max { $0.y > $1.y }!.y
            let min = points.max { $0.y < $1.y }!.y
            
            if abs(max-min) <= 10 {
                seconds = i
                printMap(with: points)
            }
        
            for point in points {
                point.drift()
            }
        }
        
        
        
        return "See output above"
    }

    static func solvePart2(input: [String]) -> String {
        return "\(seconds)"
    }
    
    static func printMap(with points: [Point]) {
        
        let maxX = points.max { $0.x > $1.x }!.x
        let minX = points.max { $0.x < $1.x }!.x
        
        let maxY = points.max { $0.y > $1.y }!.y
        let minY = points.max { $0.y < $1.y }!.y
        
        var map = Array(repeating: Array(repeating: "⬛️", count: abs(maxX-minX)+1), count: abs(maxY-minY)+1)
        
        for point in points {
                let yIndex = abs(point.y - minY)
                let xIndex = abs(point.x - minX)
                map[yIndex][xIndex] = "🟧"
        }
    
        for line in map.reversed() {
            print(line.reversed().joined(separator: ""))
        }
    }
}
