//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/10

import Foundation

enum Day_10_2025: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [Machine]

    class Machine {
        var currentLights: [Bool]
        let requiredLights: [Bool]
        var currentJoltage: [Int]
        var requiredJoltage: [Int]
        let buttons: [[Int]]

        init(currentLights: [Bool], requiredLights: [Bool], currentJoltage: [Int], requiredJoltage: [Int], buttons: [[Int]]) {
            self.currentLights = currentLights
            self.requiredLights = requiredLights
            self.currentJoltage = currentJoltage
            self.requiredJoltage = requiredJoltage
            self.buttons = buttons
        }

        var desc: String {
            "\(currentLights) -> \(requiredLights), \(buttons)"
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        var machines: [Machine] = []
        for line in input {
            var cmp = line.components(separatedBy: " ")
            let requiredLights: [Bool] = cmp.removeFirst().dropFirst().dropLast().map { $0 == "#" }
            let initialLights = Array(repeating: false, count: requiredLights.count)
            var buttons: [[Int]] = []

            while cmp.count > 1 {
                let buttonLine = cmp.removeFirst().dropFirst().dropLast()
                let button = buttonLine.components(separatedBy: ",").map { Int($0)! }
                buttons.append(button)
            }

            let requiredJoltage = cmp.first!.dropFirst().dropLast().components(separatedBy: ",").map { Int($0)! }
            let initialJoltage = Array(repeating: 0, count: requiredJoltage.count)

            machines.append(Machine(
                currentLights: initialLights,
                requiredLights: requiredLights,
                currentJoltage: initialJoltage,
                requiredJoltage: requiredJoltage,
                buttons: buttons
            ))

        }
        return machines
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var totalButtonPressed = 0
        for machine in input {

            var combinations: Set<[Int]> = []

            for b in 1..<Int(powl(2.0, Double(machine.buttons.count))) {
                let binary = Array(String(b, radix: 2))
                let indexes = binary.reversed().enumerated().compactMap { element in
                    element.element == "1" ? element.offset : nil
                }
                combinations.insert(indexes)
            }

            for combination in combinations.sorted(by: { $0.count < $1.count }) {
                var newLights = machine.currentLights
                for button in combination.map({ machine.buttons[$0] }) {
                    for b in button {
                        newLights[b].toggle()
                    }
                }

                if newLights == machine.requiredLights {
                    totalButtonPressed += combination.count
                    break
                }
            }
        }
        return "\(totalButtonPressed)"
    }

    static func solvePart2(input: ConvertedInput) -> String {

        var totalButtonPressed = 0

        for machine in input {

            let matrix = IntegerLinearSolver.buildMatrix(from: machine.buttons, rowCount: machine.requiredJoltage.count)

            guard let solution = IntegerLinearSolver.solve(matrix: matrix, rhs: machine.requiredJoltage) else {
                fatalError("Keine Lösung gefunden")
            }

            totalButtonPressed += solution.totalSum
        }

        return "\(totalButtonPressed)"
    }
}

//18681
