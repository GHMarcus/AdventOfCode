//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/23

import Foundation

enum Day_23_2020: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        let line: Array<String.Element> = Array(input[0])
        var cups = line.compactMap({ Int(String($0)) })
        let highestCup = cups.max()!
        let lowestCup = cups.min()!

        var round = 1
        let maxRounds = 100

        var currentCup = 0
        var pickups: ArraySlice<Int> = []
        var destination = 0
        var destinationIndex = 0

        while round <= maxRounds {
            currentCup = cups.removeFirst()
            pickups = cups[0...2]
            cups.removeFirst(3)

            destination = currentCup - 1
            if destination < lowestCup {
                destination = highestCup
            }
            while pickups.contains(destination) {
                destination -= 1
                if destination < lowestCup {
                    destination = highestCup
                }
            }
            destinationIndex = 0
            for i in cups {
                destinationIndex += 1
                if i == destination {
                    break
                }
            }

            cups.insert(contentsOf: pickups, at: destinationIndex)
            cups.append(currentCup)

            round += 1
        }
        
        let oneIndex = cups.firstIndex(of: 1)!
        
        var cupsAfterOne = cups.dropFirst(oneIndex + 1)
        if oneIndex != 0 {
            cupsAfterOne += cups.dropLast(oneIndex + 1)
        }

        print(cups)
        return cupsAfterOne.map({String($0)}).joined()
    }

    static func solvePart2(input: [String]) -> String {
        let line: Array<String.Element> = Array(input[0])
        var cups = line.compactMap({ Int(String($0)) })

        for i in 10...1000000 {
            cups.append(i)
        }

        let highestCup = cups.max()!
        let lowestCup = cups.min()!


        var round = 1
        let maxRounds = 10000000

        var currentCup = 0
        var pickups: ArraySlice<Int> = []
        var destination = 0
        var destinationIndex = 0

        while round <= maxRounds {
            if round % 10000 == 0 {
                print("\(Double(round) / Double(maxRounds) * 100) %")
            }
            currentCup = cups.removeFirst()
            pickups = cups[0...2]
            cups.removeFirst(3)

            destination = currentCup - 1
            if destination < lowestCup {
                destination = highestCup
            }
            while pickups.contains(destination) {
                destination -= 1
                if destination < lowestCup {
                    destination = highestCup
                }
            }
            destinationIndex = 0
            for i in cups {
                destinationIndex += 1
                if i == destination {
                    break
                }
            }

            cups.insert(contentsOf: pickups, at: destinationIndex)
            cups.append(currentCup)

            round += 1
        }

        let oneIndex = cups.firstIndex(of: 1)!

        return "\((cups[oneIndex+1]) * (cups[oneIndex+2]))"
    }
}
