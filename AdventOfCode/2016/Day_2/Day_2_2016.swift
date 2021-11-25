//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/2

enum Day_2_2016: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2016
    
    enum Direction {
        case up, down, left, right
        
        func nextPosition(row: Int, column: Int, max: Int) -> (row: Int, column: Int) {
            let newRow: Int
            let newColumn: Int
            
            switch self {
            case .up:
                newRow = row - 1 < 0 ? row : row - 1
                newColumn = column
            case .down:
                newRow = row + 1 > max ? row : row + 1
                newColumn = column
            case .left:
                newRow = row
                newColumn = column - 1 < 0 ? column : column - 1
            case .right:
                newRow = row
                newColumn = column + 1 > max ? column : column + 1
            }
            
            return (newRow, newColumn)
        }
    }

    static func solvePart1(input: [String]) -> String {
        let keyPad = [[1,2,3],
                      [4,5,6],
                      [7,8,9]]
        let max = keyPad.count - 1
        var row = 1
        var column = 1
        
        
        var code: [Int] = []
        
        for line in input {
            let directions = Array(line)
            for direction in directions {
                let newPosition: (row: Int, column: Int)
                switch direction {
                case "U":
                    newPosition = Direction.up.nextPosition(row: row, column: column, max: max)
                case "D":
                    newPosition = Direction.down.nextPosition(row: row, column: column, max: max)
                case "L":
                    newPosition = Direction.left.nextPosition(row: row, column: column, max: max)
                case "R":
                    newPosition = Direction.right.nextPosition(row: row, column: column, max: max)
                default:
                    fatalError("No valid direction: \(direction)")
                }
                row = newPosition.row
                column = newPosition.column
            }
            code.append(keyPad[row][column])
        }
        
        return "\(code.compactMap({ String($0) }).joined(separator: ""))"
    }

    static func solvePart2(input: [String]) -> String {
        let keyPad = [[nil,nil,"1",nil,nil],
                      [nil,"2","3","4",nil],
                      ["5","6","7","8","9"],
                      [nil,"A","B","C",nil],
                      [nil,nil,"D",nil,nil]]
        let max = keyPad.count - 1
        var row = 2
        var column = 0
        
        var code: [String] = []
        
        for line in input {
            let directions = Array(line)
            for direction in directions {
                let newPosition: (row: Int, column: Int)
                switch direction {
                case "U":
                    newPosition = Direction.up.nextPosition(row: row, column: column, max: max)
                case "D":
                    newPosition = Direction.down.nextPosition(row: row, column: column, max: max)
                case "L":
                    newPosition = Direction.left.nextPosition(row: row, column: column, max: max)
                case "R":
                    newPosition = Direction.right.nextPosition(row: row, column: column, max: max)
                default:
                    fatalError("No valid direction: \(direction)")
                }
                if keyPad[newPosition.row][newPosition.column] != nil {
                    row = newPosition.row
                    column = newPosition.column
                }
            }
            code.append(keyPad[row][column] ?? "nil")
        }
        
        return "\(code.joined(separator: ""))"
    }
}
