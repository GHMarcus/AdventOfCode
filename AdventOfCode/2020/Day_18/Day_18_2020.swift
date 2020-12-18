//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/18

enum Day_18_2020: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        var values: [Int] = []
        for line in input {
            let value = Int(solveLinePart1(line))
            values.append(value ?? 0)
        }
        return "\(values.reduce(0, +))"
    }

    static func solvePart2(input: [String]) -> String {
        var values: [Int] = []
        for line in input {
            let value = Int(solveLinePart2(line))
            values.append(value ?? 0)
        }
        return "\(values.reduce(0, +))"
    }

    enum Part {
        case first, middle, last
    }

    static func solveLinePart1(_ line: String) -> String {
        if line.contains("(") {
            var part = Part.first
            let array = Array(line)
            var firstString = ""
            var newString = ""
            var lastString = ""
            var found = 0

            for c in array {
                if c == "(" && part != .last {
                    if found == 0 {
                        part = .middle
                        found += 1
                        continue
                    } else if found > 0 {
                        found += 1
                        part = .middle
                    }
                }

                if c == ")" && part == .middle {
                    if found == 1 {
                        found -= 1
                        part = .last
                        continue
                    } else if found > 1 {
                        found -= 1
                        part = .middle
                    }
                }

                switch part {
                case .first:
                    firstString.append(c)
                case .middle:
                    newString.append(c)
                case .last:
                    lastString.append(c)
                }
            }

            return solveLinePart1(firstString + solveLinePart1(newString) + lastString)
        } else {
            let line = line.components(separatedBy: " ")
            var value = Int(line.first ?? "") ?? 0
            for var i in 1..<line.count{
                let operant = line[i]
                if operant == "+" {
                    value += Int(line[i+1]) ?? 0
                } else if operant == "*" {
                    value *= Int(line[i+1]) ?? 1
                }
                i += 2
            }
            return "\(value)"
        }
    }

    static func solveLinePart2(_ line: String) -> String {
        if line.contains("(") {
            var part = Part.first
            let array = Array(line)
            var firstString = ""
            var newString = ""
            var lastString = ""
            var found = 0

            for c in array {
                if c == "(" && part != .last {
                    if found == 0 {
                        part = .middle
                        found += 1
                        continue
                    } else if found > 0 {
                        found += 1
                        part = .middle
                    }
                }

                if c == ")" && part == .middle {
                    if found == 1 {
                        found -= 1
                        part = .last
                        continue
                    } else if found > 1 {
                        found -= 1
                        part = .middle
                    }
                }

                switch part {
                case .first:
                    firstString.append(c)
                case .middle:
                    newString.append(c)
                case .last:
                    lastString.append(c)
                }
            }

            return solveLinePart2(firstString + solveLinePart2(newString) + lastString)
        } else {
            var newLine = line.components(separatedBy: " ")

            while newLine.contains("+") {
                var counter = 0
                for i in 0..<line.count {
                    if i != counter {
                        continue
                    }
                    guard i+2 < newLine.count else {
                        continue
                    }
                    let c = newLine[i+1]
                    if c == "+" {
                        guard let first = Int(newLine[i]), let second = Int(newLine[i+2]) else {
                            counter += 1
                            continue
                        }
                        let newValue = first + second
                        newLine[i] = "\(newValue)"
                        newLine.remove(at: i+2)
                        newLine.remove(at: i+1)
                        counter += 2
                    } else {
                        counter += 1
                    }
                }
            }

            var value = Int(newLine.first ?? "") ?? 1

            var counter = 1

            for n in 1..<newLine.count{
                if n != counter {
                    continue
                }
                guard n+1 < newLine.count else {
                    break
                }
                value *= Int(newLine[n+1]) ?? 1
                counter += 2
            }

            return "\(value)"
        }
    }
}
