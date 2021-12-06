//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/6

enum Day_6_2021: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        let fishes = input[0].components(separatedBy: ",").compactMap { Int($0) }

        // Days to reproduce from 0 - 8
        var swarm = Array(repeating: 0, count: 9)
        for  fish in fishes {
            swarm[fish] += 1
        }

        for _ in 1...80 {
            let reproducingFishes = swarm[0]
            swarm[0] = 0
            var newSwarm = Array(repeating: 0, count: 9)
            for i in 1..<swarm.count {
                newSwarm[i-1] = swarm[i]
            }
            swarm = newSwarm
            swarm[6] += reproducingFishes
            swarm[8] += reproducingFishes
        }

        return  "\(swarm.reduce(0, +))"
    }

    static func solvePart2(input: [String]) -> String {
        let fishes = input[0].components(separatedBy: ",").compactMap { Int($0) }

        // Days to reproduce from 0 - 8
        var swarm = Array(repeating: 0, count: 9)
        for  fish in fishes {
            swarm[fish] += 1
        }

        for _ in 1...256 {
            let reproducingFishes = swarm[0]
            swarm[0] = 0
            var newSwarm = Array(repeating: 0, count: 9)
            for i in 1..<swarm.count {
                newSwarm[i-1] = swarm[i]
            }
            swarm = newSwarm
            swarm[6] += reproducingFishes
            swarm[8] += reproducingFishes
        }

        return  "\(swarm.reduce(0, +))"
    }
}
