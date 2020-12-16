//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/15

enum Day_15_2020: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [Int]) -> String {
        var currentNumber = input.last ?? 0
        var previousTurnSpoken: [Int: Int] = [:]
        var lastTurnSpoken: [Int: Int] = [:]
        var timesSpoken: [Int: Int] = [:]

        var counter = 1
        var lastNumber = 0
        for (index,number) in input.enumerated() {
            if index == 1 {
                lastTurnSpoken[number] = counter
            } else {
                previousTurnSpoken[number] = (lastTurnSpoken[number] ?? 0)
                lastTurnSpoken[number] = counter
            }
            timesSpoken[number] = 1
            lastNumber = number
//            print("Turn \(counter): \(number)")
            counter += 1
        }


        while counter <= 2020 {

            if let times = timesSpoken[lastNumber] {
                if times == 1 {
                    currentNumber = 0
                    previousTurnSpoken[currentNumber] = (lastTurnSpoken[currentNumber] ?? 0)
                    lastTurnSpoken[currentNumber] = counter
                    timesSpoken[currentNumber] = (timesSpoken[currentNumber] ?? 0) + 1
                } else {
                    currentNumber = (lastTurnSpoken[currentNumber] ?? 0) - (previousTurnSpoken[currentNumber] ?? 0)
                    previousTurnSpoken[currentNumber] = (lastTurnSpoken[currentNumber] ?? 0)
                    lastTurnSpoken[currentNumber] = counter
                    timesSpoken[currentNumber] = (timesSpoken[currentNumber] ?? 0) + 1
                }
            } else {
                currentNumber = 0
                previousTurnSpoken[currentNumber] = (lastTurnSpoken[currentNumber] ?? 0)
                lastTurnSpoken[currentNumber] = counter
                timesSpoken[currentNumber] = 1
            }


//            print("Turn \(counter): \(currentNumber)")
            counter += 1
            lastNumber = currentNumber
        }

        return "\(lastNumber)"
    }

    static func solvePart2(input: [Int]) -> String {
        var currentNumber = input.last ?? 0
        var previousTurnSpoken: [Int: Int] = [:]
        var lastTurnSpoken: [Int: Int] = [:]
        var timesSpoken: [Int: Int] = [:]

        var counter = 1
        var lastNumber = 0
        for (index,number) in input.enumerated() {
            if index == 1 {
                lastTurnSpoken[number] = counter
            } else {
                previousTurnSpoken[number] = (lastTurnSpoken[number] ?? 0)
                lastTurnSpoken[number] = counter
            }
            timesSpoken[number] = 1
            lastNumber = number
//            print("Turn \(counter): \(number)")
            counter += 1
        }


        while counter <= 30000000 {

            if let times = timesSpoken[lastNumber] {
                if times == 1 {
                    currentNumber = 0
                    previousTurnSpoken[currentNumber] = (lastTurnSpoken[currentNumber] ?? 0)
                    lastTurnSpoken[currentNumber] = counter
                    timesSpoken[currentNumber] = (timesSpoken[currentNumber] ?? 0) + 1
                } else {
                    currentNumber = (lastTurnSpoken[currentNumber] ?? 0) - (previousTurnSpoken[currentNumber] ?? 0)
                    previousTurnSpoken[currentNumber] = (lastTurnSpoken[currentNumber] ?? 0)
                    lastTurnSpoken[currentNumber] = counter
                    timesSpoken[currentNumber] = (timesSpoken[currentNumber] ?? 0) + 1
                }
            } else {
                currentNumber = 0
                previousTurnSpoken[currentNumber] = (lastTurnSpoken[currentNumber] ?? 0)
                lastTurnSpoken[currentNumber] = counter
                timesSpoken[currentNumber] = 1
            }


//            print("Turn \(counter): \(currentNumber)")
            counter += 1
            lastNumber = currentNumber
        }

        return "\(lastNumber)"
    }
}
