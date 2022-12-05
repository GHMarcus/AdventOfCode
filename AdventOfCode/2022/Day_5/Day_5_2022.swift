//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/5

enum Day_5_2022: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2022

    struct Command {
        let start, destination, number: Int

        init(description: String) {
            let cmp = description.components(separatedBy: " ")
            // Minus 1 to get the array positions
            start = Int(cmp[3])! - 1
            destination = Int(cmp[5])! - 1
            number = Int(cmp[1])!
        }
    }

    static func solvePart1(input: [String]) -> String {
        let result = getInitialStacks(for: input)
        var stacks = result.stacks
        let commands = result.remainingInput.compactMap { Command(description: $0) }

        for command in commands {
            for _ in 0..<command.number {
                let crate = stacks[command.start].removeLast()
                stacks[command.destination].append(crate)
            }
        }

        var topCrates: [Character] = []

        for stack in stacks {
            topCrates.append(stack.last!)
        }

        return String(topCrates)
    }

    static func solvePart2(input: [String]) -> String {
        let result = getInitialStacks(for: input)
        var stacks = result.stacks
        let commands = result.remainingInput.compactMap { Command(description: $0) }

        for command in commands {
            let crates: [Character] = stacks[command.start].suffix(command.number)
            stacks[command.start].removeLast(command.number)

            stacks[command.destination].append(contentsOf: crates)
        }

        var topCrates: [Character] = []

        for stack in stacks {
            topCrates.append(stack.last!)
        }

        return String(topCrates)
    }

    private static func getInitialStacks(for input: [String]) -> (stacks: [[Character]], remainingInput: [String]) {
        var input = input
        var stackDescriptions: [[Character]] = []

        while true {
            let line = Array(input.removeFirst())
            if line.count == 0 {
                break
            } else {
                stackDescriptions.append(line)
            }
        }

        let stackNumbers = stackDescriptions.removeLast()
            .filter { $0 != " "}
            .compactMap { Int(String($0)) }

        var stacks: [[Character]] = Array(repeating: [], count: stackNumbers.count)

        for line in stackDescriptions {
            let offset = 1

            for c in 0..<stackNumbers.count {
                if let crate = line.get(offset+c*4), crate != " " {
                    stacks[c].append(crate)
                }
            }
        }

        stacks = stacks.map { $0.reversed() }
        return (stacks, input)
    }
}
