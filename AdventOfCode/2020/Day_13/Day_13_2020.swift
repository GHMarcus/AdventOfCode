//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/13

import Foundation

enum Day_13_2020: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        let time = Int(input.first ?? "") ?? 0
        let buses = (input.last ?? "")
            .replacingOccurrences(of: "x,", with: "")
            .components(separatedBy: ",")
            .compactMap({Int($0)})

        let times = buses.map { Double(time) / Double($0) }
        let timesRounded = times.map { $0.rounded(.up) }
        let diffs = zip(times, timesRounded).map(-).map({abs($0)})

        var minIndex = 0
        var minValue = 1.0

        for (index, diff) in diffs.enumerated() {
            if diff < minValue {
                minIndex = index
                minValue = diff
            }
        }

        let bus = buses[minIndex]
        let takeTime = Int(timesRounded[minIndex]) * bus

        return "\((takeTime - time) * bus)"
    }

    static func solvePart2(input: [String]) -> String {
        let allBuses = (input.last ?? "")
            .components(separatedBy: ",")

        var offsets: [UInt64] = []
        for (index, bus) in allBuses.enumerated() {
            if bus != "x" {
                offsets.append(UInt64(index))
            }
        }

        let buses = allBuses.compactMap { UInt64($0) }
        let timeInterval = (buses.max() ?? 1) / (buses.first ?? 1) * (buses.first ?? 1)
        print(timeInterval)
        var timeStamp = timeInterval
        var border = 100000000000
        let borderInterval = 100000000000

        // Took 2.791465997695923 seconds -> 100000000000 => 40 min
        while true {
            if timeStamp > border {
                print(timeStamp)
                border += borderInterval
                print("Took \(CFAbsoluteTimeGetCurrent() - startTime) seconds")
            }
            var allSame = true
            for (index, offset) in offsets.enumerated() {
                let offsetTime = timeStamp + offset
                if offsetTime % buses[index] != 0 {
                    allSame = false
                    break
                }
            }
            if allSame {
                return "\(timeStamp)"
            }
            timeStamp += timeInterval
        }

    }

}
