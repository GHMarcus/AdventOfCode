//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/18

enum Day_18_2023: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2023
    
    struct Command {
        enum Direction: String {
            case right = "R"
            case down = "D"
            case left = "L"
            case up = "U"
        }
        
        let direction: Direction
        let count: Int
    }
    
    struct ColorCommand {
        enum Direction: Character {
            case right = "0"
            case down = "1"
            case left = "2"
            case up = "3"
        }
        
        let direction: Direction
        let count: Int
    }
    
    struct Pos: Hashable {
        let x,y: Int
    }
    
    static func convert(input: [String]) -> (part1Commands: [Command], part2Commands: [ColorCommand]) {
        var commands: [Command] = []
        var colorCommands: [ColorCommand] = []
        
        for line in input {
            let cmp = line.components(separatedBy: " ")
            commands.append(Command(direction: Command.Direction(rawValue: cmp[0])!, count: Int(cmp[1])!))
            var colorCode = cmp[2].dropFirst(2).dropLast()
            let colorDirection = colorCode.removeLast()
            colorCommands.append(ColorCommand(direction: ColorCommand.Direction(rawValue: colorDirection)!, count: Int(colorCode, radix: 16)!))
        }
        
        return (commands, colorCommands)
    }

    static func solvePart1(input: (part1Commands: [Command], part2Commands: [ColorCommand])) -> String {
        
        var current = Pos(x: 0, y: 0)
        var borderHoles: [Pos] = []
        var completeBorderHolesCount = 0
        
        for command in input.part1Commands {
            let newHole: Pos
            
            switch command.direction {
            case .left:
                newHole = Pos(x: current.x - command.count, y: current.y)
            case .right:
                newHole = Pos(x: current.x + command.count, y: current.y)
            case .up:
                newHole = Pos(x: current.x, y: current.y - command.count)
            case .down:
                newHole = Pos(x: current.x, y: current.y + command.count)
            }
            
            borderHoles.append(newHole)
            current = newHole
            completeBorderHolesCount += command.count
        }
        
        let area = polygonArea(vertices: borderHoles.map { ($0.x, $0.y) }, borderElements: completeBorderHolesCount )
        
        return "\(area)"
    }

    static func solvePart2(input: (part1Commands: [Command], part2Commands: [ColorCommand])) -> String {
        var current = Pos(x: 0, y: 0)
        var borderHoles: [Pos] = []
        var completeBorderHolesCount = 0
        
        for command in input.part2Commands {
            let newHole: Pos
            
            switch command.direction {
            case .left:
                newHole = Pos(x: current.x - command.count, y: current.y)
            case .right:
                newHole = Pos(x: current.x + command.count, y: current.y)
            case .up:
                newHole = Pos(x: current.x, y: current.y - command.count)
            case .down:
                newHole = Pos(x: current.x, y: current.y + command.count)
            }
            
            borderHoles.append(newHole)
            current = newHole
            completeBorderHolesCount += command.count
        }
        
        let area = polygonArea(vertices: borderHoles.map { ($0.x, $0.y) }, borderElements: completeBorderHolesCount )
        
        return "\(area)"
    }
}

