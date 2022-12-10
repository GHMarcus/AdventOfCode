//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/10

enum Day_10_2022: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2022



    static func solvePart1(input: [String]) -> String {
        var register = 1
        var cycle = 0
        var sum = 0

        func checkSignal() {
            if cycle == 20 {
                sum += (register * cycle)
            } else if (cycle-20) % 40 == 0 {
                sum += (register * cycle)
            }
        }

        for line in input {
            let cmp = line.components(separatedBy: " ")
            switch cmp[0] {
            case "noop":
                cycle += 1
                checkSignal()
            case "addx":
                let value = Int(cmp[1])!
                cycle += 1
                checkSignal()
                cycle += 1
                checkSignal()
                register += value
            default:
                fatalError()
            }
        }


        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        var register = 1
        var cycle = 0
        var pos = 0

        var crt = Array(repeating: Array(repeating: ".", count: 40), count: 6)
        var row = 0

        func checkSignal() {
            if pos >= 40 {
                pos = 0
                row += 1
            }
//            if (cycle % 40) == 0 {
//                row += 1
//            }

            let sprite = [register-1, register, register+1]

            if sprite.contains(pos) {
                crt[row][pos] = "#"
            }
            pos += 1
        }

        for line in input {
            let cmp = line.components(separatedBy: " ")
            switch cmp[0] {
            case "noop":
                cycle += 1
                checkSignal()
            case "addx":
                let value = Int(cmp[1])!
                cycle += 1
                checkSignal()
                cycle += 1
                checkSignal()
                register += value
            default:
                fatalError()
            }
        }

        crt.forEach {
            print(
                $0.joined()
                    .replacingOccurrences(of: ".", with: "⬛️")
                    .replacingOccurrences(of: "#", with: "🟠")
            )
        }

        return "Read console log above"
    }
}

// PCPBKAPJ
