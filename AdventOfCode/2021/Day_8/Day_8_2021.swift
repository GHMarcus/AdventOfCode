//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/8

enum Day_8_2021: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var  appearances = 0

        for line in input {
            let output  = line.components(separatedBy: "|")[1].components(separatedBy: " ").dropFirst()

            for signal in output {
                if signal.count == 2 {
                    appearances += 1
                    continue
                }
                if signal.count == 3 {
                    appearances += 1
                    continue
                }
                if signal.count == 4 {
                    appearances += 1
                    continue
                }
                if signal.count == 7 {
                    appearances += 1
                    continue
                }
            }
        }

        return "\(appearances)"
    }

    static func solvePart2(input: [String]) -> String {

        var numbers: [Int: [Character]] = [:]
        var outputNumbers: [Int] = []

        for line in input {
            var signals  = line.components(separatedBy: "|")[0].components(separatedBy: " ").dropLast()

            // 1
            numbers[1] = Array(signals.filter({ $0.count == 2 })[0]).sorted(by: <)
            signals = signals.filter({$0.count != 2})

            // 4
            numbers[4] = Array(signals.filter({ $0.count == 4 })[0]).sorted(by: <)
            signals = signals.filter({$0.count != 4})

            // 7
            numbers[7] = Array(signals.filter({ $0.count == 3 })[0]).sorted(by: <)
            signals = signals.filter({$0.count != 3})

            // 8
            numbers[8] = Array(signals.filter({ $0.count == 7 })[0]).sorted(by: <)
            signals = signals.filter({$0.count != 7})



            for signal in signals {

                if signal.count == 5 {
                    // 2, 3, or 5
                    let seven = numbers[7]!
                    var signalsOfSeven = 0
                    for c in seven {
                        if signal.contains(c) {
                            signalsOfSeven += 1
                        }
                    }
                    if signalsOfSeven == 3 {
                        numbers[3] = Array(signal).sorted(by: <)
                        continue
                    }
                    let four = numbers[4]!
                    var signalsOfFour = 0
                    for c in four {
                        if signal.contains(c) {
                            signalsOfFour += 1
                        }
                    }

                    if signalsOfFour == 3 {
                        numbers[5] = Array(signal).sorted(by: <)
                        continue
                    } else {
                        numbers[2] = Array(signal).sorted(by: <)
                        continue
                    }
                } else {
                    // 0, 6, or 9
                    let four = numbers[4]!
                    var signalsOfFour = 0
                    for c in four {
                        if signal.contains(c) {
                            signalsOfFour += 1
                        }
                    }
                    if signalsOfFour == 4 {
                        numbers[9] = Array(signal).sorted(by: <)
                        continue
                    }
                    let seven = numbers[7]!
                    var signalsOfSeven = 0
                    for c in seven {
                        if signal.contains(c) {
                            signalsOfSeven += 1
                        }
                    }
                    if signalsOfSeven == 3 {
                        numbers[0] = Array(signal).sorted(by: <)
                        continue
                    } else {
                        numbers[6] = Array(signal).sorted(by: <)
                        continue
                    }
                }
            }


            let outputs  = line.components(separatedBy: "|")[1].components(separatedBy: " ").dropFirst()
            var multiplicator = 1000
            var outputNumber = 0
            for output in outputs {
                let number = numbers.filter {$0.value == Array(output).sorted(by: <)}
                outputNumber += number.first!.key * multiplicator
                multiplicator /= 10
            }
            outputNumbers.append(outputNumber)
        }

        return "\(outputNumbers.reduce(0, +))"
    }
}
