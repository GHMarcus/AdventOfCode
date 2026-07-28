//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/11

// Runs in about: Took 126.24894607067108 seconds

enum Day_11_2025: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [Device]

    struct Device: Hashable {
        let name: String
        let output: [String]
    }

    static func convert(input: [String]) -> ConvertedInput {
        var devices: [Device] = []
        for line in input {
            var cmp = line.components(separatedBy: " ")
            let name = String(cmp.removeFirst().dropLast())
            devices.append(Device(name: name, output: cmp))
        }
        return devices
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let start = input.first(where: { $0.name == "you" })!
        let out = Device(name: "out", output: [])
        let devices = input + [out]

        func neighbors(for current: Device) -> [Device] {
            var neighbors: [Device] = []
            for deviceName in current.output {
                if let device = devices.first(where: { $0.name == deviceName }) {
                    neighbors.append(device)
                }
            }
            return neighbors
        }

        let paths = resolveAllDFS(start: start, goal: { $0 == out }, neighbors: { neighbors(for: $0)}) ?? []

        return "\(paths.count)"
    }

    static func solvePart2(input: ConvertedInput) -> String {

        let out = Device(name: "out", output: [])
        let devices = input + [out]

        // Paths to check:
        //   svr -> fft * fft -> dac * dac -> out
        // + svr -> dac * dac -> fft * fft -> out
        // second can be ignored du to dac -> fft is 0

        let starts = [
            input.first(where: { $0.name == "svr" })!,
            input.first(where: { $0.name == "fft" })!,
            input.first(where: { $0.name == "dac" })!,
//            input.first(where: { $0.name == "svr" })!,
//            input.first(where: { $0.name == "dac" })!,
//            input.first(where: { $0.name == "fft" })!
        ]

        let goals = [
            input.first(where: { $0.name == "fft" })!,
            input.first(where: { $0.name == "dac" })!,
            out,
//            input.first(where: { $0.name == "dac" })!,
//            input.first(where: { $0.name == "fft" })!,
//            out
        ]

        func neighbors(for current: Device) -> [Device] {
            var neighbors: [Device] = []
            for deviceName in current.output {
                if let device = devices.first(where: { $0.name == deviceName }) {
                    neighbors.append(device)
                }
            }
            return neighbors
        }


        var possiblePaths: [Int] = []


        for i in 0..<starts.count {
            print("Testing", starts[i].name, "->", goals[i].name)
            let goal = goals[i]
            let paths = resolveAllDFS(start: starts[i], goal: { $0 == goal }, neighbors: { neighbors(for: $0)}) ?? []
            print("Paths:", paths.count)
            possiblePaths.append(paths.count)
        }

        let combinedPaths = possiblePaths[0] * possiblePaths[1] * possiblePaths[2] //+ possiblePaths[3] * possiblePaths[4] * possiblePaths[5]

        return "\(combinedPaths)"
    }
}
