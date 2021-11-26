//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/8

enum Day_8_2016: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2016

    static func solvePart1(input: [String]) -> String {
        let maxColumns = 50
        let maxRows = 6
        let character: Character = "."
        var display = Array(repeating: Array(repeating: character, count: maxColumns), count: maxRows)
        
        for line in input {
            let comp = line.components(separatedBy: " ")
            
            switch comp[0] {
            case "rect":
                display = drawRect(
                    size: comp[1],
                    in: display
                )
            case "rotate":
                switch comp[1] {
                case "column":
                    display = rotateColumn(
                        column: Int(comp[2].components(separatedBy: "=")[1])!,
                        by: Int(comp[4])!,
                        in: display
                    )
                case "row":
                    display = rotateRow(
                        row: Int(comp[2].components(separatedBy: "=")[1])!,
                        by: Int(comp[4])!,
                        in: display
                    )
                default:
                    fatalError()
                }
            default:
                fatalError()
            }
        }
        
        var numberOfLitPixles = 0
        
        for row in display {
            for c in row {
                if c == "#" {
                    numberOfLitPixles += 1
                }
            }
        }
        
        return "\(numberOfLitPixles)"
    }

    static func solvePart2(input: [String]) -> String {
        // For the solution you have to read the console log
        let maxColumns = 50
        let maxRows = 6
        let character: Character = "."
        var display = Array(repeating: Array(repeating: character, count: maxColumns), count: maxRows)
        
        for line in input {
            let comp = line.components(separatedBy: " ")
            
            switch comp[0] {
            case "rect":
                display = drawRect(
                    size: comp[1],
                    in: display
                )
            case "rotate":
                switch comp[1] {
                case "column":
                    display = rotateColumn(
                        column: Int(comp[2].components(separatedBy: "=")[1])!,
                        by: Int(comp[4])!,
                        in: display
                    )
                case "row":
                    display = rotateRow(
                        row: Int(comp[2].components(separatedBy: "=")[1])!,
                        by: Int(comp[4])!,
                        in: display
                    )
                default:
                    fatalError()
                }
            default:
                fatalError()
            }
        }
        
        display.forEach {
            print(
                String($0)
                    .replacingOccurrences(of: ".", with: "⬛️")
                    .replacingOccurrences(of: "#", with: "⚪️")
            )
        }
        
        return "Read console log above"
    }
}

extension Day_8_2016 {
    static func drawRect(size: String, in display: [[Character]]) -> [[Character]] {
        var display = display
        let sizeComps = size.components(separatedBy: "x").compactMap { Int($0) }
        
        for row in 0..<sizeComps[1] {
            for column in 0..<sizeComps[0] {
                display[row][column] = "#"
            }
        }
        
        return display
    }
    
    static func rotateColumn(column: Int, by: Int, in display: [[Character]]) -> [[Character]] {
        var display = display
        var newDisplay = display
        
        for _ in 0..<by {
            for i in 0..<display.count {
                if i == 0 {
                    newDisplay[i][column] = display[display.count-1][column]
                } else {
                    newDisplay[i][column] = display[i-1][column]
                }
            }
            display = newDisplay
        }
        
        return newDisplay
    }
    
    static func rotateRow(row: Int, by: Int, in display: [[Character]]) -> [[Character]] {
        var display = display
        
        for _ in 0..<by {
            let last = display[row].removeLast()
            display[row].insert(last, at: 0)
        }
        
        return display
    }
}

/*
 112 low
 */
