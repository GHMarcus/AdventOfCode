//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/1

enum Day_1_2016: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2016
    
    enum Direction {
        case east, south, west, north
        
        mutating func turnLeft(){
            switch self {
            case .east:
                self = .north
            case .south:
                self = .east
            case .west:
                self = .south
            case .north:
                self = .west
            }
        }
        
        mutating func turnRight() {
            switch self {
            case .east:
                self = .south
            case .south:
                self = .west
            case .west:
                self = .north
            case .north:
                self = .east
            }
        }
        
        
    }
    
    static func solvePart1(input: [String]) -> String {
        var x = 0
        var y = 0
        var direction = Direction.north
        let commands = input[0].replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        
        for command in commands {
            var components = Array(command)
            let turn = components.removeFirst()
            if turn == "R" {
                direction.turnRight()
            } else if turn == "L" {
                direction.turnLeft()
            } else {
                fatalError("No Direction found: \(command)")
            }
            
            let distance = Int(String(components))!
            switch direction {
            case .east:
                x += distance
            case .south:
                y -= distance
            case .west:
                x -= distance
            case .north:
                y += distance
            }
        }
        
        return "\(abs(x)+abs(y))"
    }
    
    static func solvePart2(input: [String]) -> String {
        var x = 0
        var y = 0
        var direction = Direction.north
        let commands = input[0].replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        
        var visitedLocations: [(Int,Int)] = [(x,y)]
    outerLoop: for command in commands {
        var components = Array(command)
        let turn = components.removeFirst()
        if turn == "R" {
            direction.turnRight()
        } else if turn == "L" {
            direction.turnLeft()
        } else {
            fatalError("No Direction found: \(command)")
        }
        
        let distance = Int(String(components))!
        for _ in 1...distance {
            switch direction {
            case .east:
                x += 1
            case .south:
                y -= 1
            case .west:
                x -= 1
            case .north:
                y += 1
            }
            if visitedLocations.contains(where: { $0 == (x,y) }) {
                break outerLoop
            } else {
                visitedLocations.append((x,y))
            }
        }
    }
        return "\(abs(x)+abs(y))"
    }
}
