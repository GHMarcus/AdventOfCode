//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/13

enum Day_13_2021: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var points: [(x:Int, y: Int)] = []
        var instructions: [(axis: String, number: Int)] = []
        var isInstruction = false
        var maxX = 0
        var maxY = 0
        for line in input {
            if line.isEmpty {
                isInstruction = true
                continue
            }
            if isInstruction{
                let comps = line.components(separatedBy: " ")[2].components(separatedBy: "=")
                instructions.append((comps[0],Int(comps[1])!))
            } else {
                let comps = line.components(separatedBy: ",")
                let x = Int(comps[0])!
                let y = Int(comps[1])!
                maxX = max(x,maxX)
                maxY = max(y,maxY)
                points.append((x,y))
            }
        }

        var map = Array(repeating: Array(repeating: ".", count: maxX+1), count: maxY+1)

        for point in points {
            map[point.y][point.x] = "#"
        }

        map = fold(map, instruction: instructions[0])
        
        var numberOfPoints = 0
        map.forEach {
            $0.forEach {
                if $0 == "#" {
                    numberOfPoints += 1
                }
            }
        }


        return "\(numberOfPoints)"
    }

    static func solvePart2(input: [String]) -> String {
        var points: [(x:Int, y: Int)] = []
        var instructions: [(axis: String, number: Int)] = []
        var isInstruction = false
        var maxX = 0
        var maxY = 0
        for line in input {
            if line.isEmpty {
                isInstruction = true
                continue
            }
            if isInstruction{
                let comps = line.components(separatedBy: " ")[2].components(separatedBy: "=")
                instructions.append((comps[0],Int(comps[1])!))
            } else {
                let comps = line.components(separatedBy: ",")
                let x = Int(comps[0])!
                let y = Int(comps[1])!
                maxX = max(x,maxX)
                maxY = max(y,maxY)
                points.append((x,y))
            }
        }

        var map = Array(repeating: Array(repeating: ".", count: maxX+1), count: maxY+1)

        for point in points {
            map[point.y][point.x] = "#"
        }

        for instruction in instructions {
            map = fold(map, instruction: instruction)
        }

        map.forEach {
            print(
                $0.joined()
                    .replacingOccurrences(of: ".", with: "⬛️")
                    .replacingOccurrences(of: "#", with: "⚪️")
            )
        }

        return "See console log above"
    }

    static func fold(_ map: [[String]], instruction: (axis: String, number: Int)) -> [[String]] {
        if instruction.axis == "y" {
            var newMap = Array(repeating: Array(repeating: ".", count: map[0].count), count: instruction.number)
            for y in 1...instruction.number {
                for x in 0..<newMap[0].count {
                    if instruction.number-y >= 0, map[instruction.number-y][x] == "#" {
                        newMap[instruction.number-y][x] = "#"
                        continue
                    } else if instruction.number+y < map.count, map[instruction.number+y][x] == "#" {
                        newMap[instruction.number-y][x] = "#"
                    }
                }
            }
            return newMap
        } else {
            var newMap = Array(repeating: Array(repeating: ".", count: instruction.number), count: map.count)
            for x in 1...instruction.number {
                for y in 0..<newMap.count {
//                    guard instruction.number-x >= 0, instruction.number+x < newMap[0].count else { continue }

                    if instruction.number-x >= 0, map[y][instruction.number-x] == "#" {
                        newMap[y][instruction.number-x] = "#"
                        continue
                    } else if instruction.number+x < map[0].count, map[y][instruction.number+x] == "#" {
                        newMap[y][instruction.number-x] = "#"
                    }
                }
            }
            return newMap
        }
    }
}
