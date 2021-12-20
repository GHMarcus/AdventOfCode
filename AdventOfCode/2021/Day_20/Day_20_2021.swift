//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/20

enum Day_20_2021: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        let algorithm = Array(input[0].replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1"))

        var map = Array(input.dropFirst(2)).map { $0.replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1") }

        let maxCount = 2

        var newMap: [String] = []

        var count = 0
        var isEven = true
        while count < maxCount {
            count += 1
            if isEven {
                isEven.toggle()

                newMap = []
                let newColumns = String(repeating: "0", count: 2)
                for line in map {
                    newMap.append(newColumns + line + newColumns)
                }

                let newLines = Array(repeating: String(repeating: "0", count: newMap[0].count), count: 2)
                newMap = newLines + newMap + newLines
                map = newMap
            } else {
                isEven.toggle()

                newMap = []
                let newColumns = String(repeating: "1", count: 2)
                for line in map {
                    newMap.append(newColumns + line + newColumns)
                }

                let newLines = Array(repeating: String(repeating: "1", count: newMap[0].count), count: 2)
                newMap = newLines + newMap + newLines
                map = newMap
            }

            for row in 1..<(map.count-1){
                for col in 1..<(map[0].count-1){
                    let neighbours = [(col-1,row-1), (col,row-1), (col+1,row-1),
                                      (col-1,row  ), (col,row  ), (col+1,row  ),
                                      (col-1,row+1), (col,row+1), (col+1,row+1)]
                    var value = ""
                    for neighbour in neighbours {
                        value.append(Array(map[neighbour.1])[neighbour.0])
                    }

                    var newRow = Array(newMap[row])
                    newRow[col] = algorithm[Int(value, radix: 2)!]// == "#" ? "1" : "0"
                    newMap[row] = String(newRow)
                }
            }

            map = newMap.dropFirst().dropLast().map({ String($0.dropFirst().dropLast()) })
        }

        map.printLines()

        var litPixels = 0

        for line in map {
            for c in Array(line) {
                if c == "1" {
                    litPixels += 1
                }
            }
        }

        return "\(litPixels)"
    }

    // Took 68.87068200111389 seconds
    static func solvePart2(input: [String]) -> String {
        let algorithm = Array(input[0].replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1"))

        var map = Array(input.dropFirst(2)).map { $0.replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1") }

        let maxCount = 50

        var newMap: [String] = []

        var count = 0
        var isEven = true
        while count < maxCount {
            count += 1
            print(count)
            if isEven {
                isEven.toggle()

                newMap = []
                let newColumns = String(repeating: "0", count: 2)
                for line in map {
                    newMap.append(newColumns + line + newColumns)
                }

                let newLines = Array(repeating: String(repeating: "0", count: newMap[0].count), count: 2)
                newMap = newLines + newMap + newLines
                map = newMap
            } else {
                isEven.toggle()

                newMap = []
                let newColumns = String(repeating: "1", count: 2)
                for line in map {
                    newMap.append(newColumns + line + newColumns)
                }

                let newLines = Array(repeating: String(repeating: "1", count: newMap[0].count), count: 2)
                newMap = newLines + newMap + newLines
                map = newMap
            }

            for row in 1..<(map.count-1){
                for col in 1..<(map[0].count-1){
                    let neighbours = [(col-1,row-1), (col,row-1), (col+1,row-1),
                                      (col-1,row  ), (col,row  ), (col+1,row  ),
                                      (col-1,row+1), (col,row+1), (col+1,row+1)]
                    var value = ""
                    for neighbour in neighbours {
                        value.append(Array(map[neighbour.1])[neighbour.0])
                    }

                    var newRow = Array(newMap[row])
                    newRow[col] = algorithm[Int(value, radix: 2)!]
                    newMap[row] = String(newRow)
                }
            }

            map = newMap.dropFirst().dropLast().map({ String($0.dropFirst().dropLast()) })
        }

        map.printLines()

        var litPixels = 0

        for line in map {
            for c in Array(line) {
                if c == "1" {
                    litPixels += 1
                }
            }
        }

        return "\(litPixels)"
    }
}
