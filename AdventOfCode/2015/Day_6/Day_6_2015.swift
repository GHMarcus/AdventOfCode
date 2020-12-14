//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/6

enum Day_6_2015: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2015

    enum Command {
        case toggle, turnOn, turnOff
    }

    struct Pos: Hashable {
        let x: Int
        let y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }

    // toggle 461,550 through 564,900
    // turn off 370,39 through 425,839
    // turn on 370,39 through 425,839


    static func solvePart1(input: [String]) -> String {
        var lights: Dictionary<Pos, Bool> = [:]

        for line in input {
            let command: Command
            var cmp = line.components(separatedBy: " ")
            switch cmp.first {
            case "toggle":
                command = .toggle
                cmp = Array<String>(cmp.dropFirst())
            case "turn":
                if cmp[1] == "on" {
                    command = .turnOn
                } else {
                    command = .turnOff
                }
                cmp = Array<String>(cmp.dropFirst(2))
            default:
                fatalError("No Command found")
            }

            guard let firstPos = cmp.first?.components(separatedBy: ","),
                  let secondPos = cmp.last?.components(separatedBy: ","),
                  let firstX = Int(firstPos.first ?? ""),
                  let firstY = Int(firstPos.last ?? ""),
                  let secondX = Int(secondPos.first ?? ""),
                  let secondY = Int(secondPos.last ?? "")  else {
                fatalError("No Positions found")
            }

            for x in firstX...secondX {
                for y in firstY...secondY {
                    let pos = Pos(x, y)
                    switch command {
                    case .toggle:
                        if let value = lights[pos] {
                            lights[pos] = !value
                        } else {
                            lights[pos] = true
                        }
                    case .turnOn:
                        lights[pos] = true
                    case .turnOff:
                        lights[pos] = false
                    }
                }
            }
        }

        var litLights = 0
        lights.forEach { (_, value) in
            if value {
                litLights += 1
            }
        }
        return "\(litLights)"
    }

    static func solvePart2(input: [String]) -> String {
        var lights: Dictionary<Pos, Int> = [:]

        for line in input {
            let command: Command
            var cmp = line.components(separatedBy: " ")
            switch cmp.first {
            case "toggle":
                command = .toggle
                cmp = Array<String>(cmp.dropFirst())
            case "turn":
                if cmp[1] == "on" {
                    command = .turnOn
                } else {
                    command = .turnOff
                }
                cmp = Array<String>(cmp.dropFirst(2))
            default:
                fatalError("No Command found")
            }

            guard let firstPos = cmp.first?.components(separatedBy: ","),
                  let secondPos = cmp.last?.components(separatedBy: ","),
                  let firstX = Int(firstPos.first ?? ""),
                  let firstY = Int(firstPos.last ?? ""),
                  let secondX = Int(secondPos.first ?? ""),
                  let secondY = Int(secondPos.last ?? "")  else {
                fatalError("No Positions found")
            }

            for x in firstX...secondX {
                for y in firstY...secondY {
                    let pos = Pos(x, y)
                    switch command {
                    case .toggle:
                        if let value = lights[pos] {
                            lights[pos] = value + 2
                        } else {
                            lights[pos] = 2
                        }
                    case .turnOn:
                        if let value = lights[pos] {
                            lights[pos] = value + 1
                        } else {
                            lights[pos] = 1
                        }
                    case .turnOff:
                        if let value = lights[pos] {
                            lights[pos] = value == 0 ? 0 : value - 1
                        } else {
                            lights[pos] = 0
                        }
                    }
                }
            }
        }

        var litLights = 0
        lights.forEach { (_, value) in
            litLights += value
        }
        return "\(litLights)"
    }
}
