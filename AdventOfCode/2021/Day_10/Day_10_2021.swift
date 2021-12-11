//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/10

enum Day_10_2021: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2021

    static var incompleteLines: [String] = []

    static func solvePart1(input: [String]) -> String {

        var sum = 0
    line: for line in input {
        var open = ""
        for c in Array(line) {
            switch c {
            case "(", "[", "{", "<":
                open.append(c)
            case ")":
                let last = open.removeLast()
                if last != "(" {
                    sum += 3
                    continue line
                }
            case "]":
                let last = open.removeLast()
                if last != "[" {
                    sum +=  57
                    continue line
                }
            case "}":
                let last = open.removeLast()
                if last != "{" {
                    sum +=  1197
                    continue line
                }
            case ">":
                let last = open.removeLast()
                if last != "<" {
                    sum +=  25137
                    continue line
                }
            default:
                fatalError()
            }
        }
        incompleteLines.append(line)
    }

        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        let allowedChunks = ["()", "[]", "{}", "<>"]
        var sums: [Int] = []

        for var line in incompleteLines {
            var newLine = line
            while true {
                for chunk in allowedChunks {
                    newLine = newLine.replacingOccurrences(of: chunk, with: "")
                }
                if newLine.count == line.count {
                    break
                } else {
                    line = newLine
                }
            }
            var sum = 0
            for c in Array(line).reversed() {
                sum *= 5
                if c == "(" {
                    sum += 1
                } else  if c == "[" {
                    sum += 2
                } else  if c == "{" {
                    sum += 3
                } else  if c == "<" {
                    sum += 4
                }
            }
            sums.append(sum)
        }
        sums.sort()
        let middle = Int(sums.count / 2)

        return "\(sums[middle])"
    }
}
