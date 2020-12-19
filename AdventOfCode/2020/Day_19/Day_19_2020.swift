//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/19

import Foundation

enum Day_19_2020: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2020

    static let allowedCharacters = CharacterSet(charactersIn:"ab ")

    struct Rule {
        let number: Int
        let value1: String
        let value2: String
    }

    static func solvePart1(input: [String]) -> String {
        var rules: [Rule] = []
        var messages: [String] = []
        var isRules = true
        for line in input {
            if line == "" {
                isRules = false
                continue
            }
            if isRules {
                let ruleLine = line
                    .replacingOccurrences(of: "\"", with: "")
                    .components(separatedBy: ": ")
                guard ruleLine.count == 2,
                      let number = Int(ruleLine.first ?? "")
                else {
                    fatalError("Can not form Int Nubmer in Rule")
                }

                if ruleLine[1].contains("|") {
                    let cmp = ruleLine[1].components(separatedBy: " | ")
                    rules.append(.init(number: number, value1: cmp[0], value2: cmp[1]))
                } else {
                    rules.append(.init(number: number, value1: ruleLine[1], value2: ""))
                }
            } else {
                messages.append(line)
            }
        }

        guard let ruleZero = rules.first(where: { $0.number == 0 }) else {
            fatalError("Can not find rule zero")
        }

        var zeroRules: Set<String> = [ruleZero.value1]
        var zeroRulesSet: Set<String> = []

        var run = true
        var values: [String] = []
        while run {
            for rule in zeroRules {
                values = rule.components(separatedBy: " ")
                var newRules: [[String]] = [values]
                for (valueIndex, value) in values.enumerated() {
                    if value.trimmingCharacters(in: Day_19_2020.allowedCharacters).isEmpty {
                        continue
                    } else {
                        guard let number = Int(value),
                              let newRule = rules.first(where: { $0.number == number })
                        else { continue }

                        if newRule.value2 == "" {
                            for (index, var rule) in newRules.enumerated() {
                                rule[valueIndex] = newRule.value1
                                newRules[index] = rule
                            }
                        } else {
                            var duplicatesNewRules = newRules
                            for (index, var rule) in newRules.enumerated() {
                                rule[valueIndex] = newRule.value1
                                newRules[index] = rule
                            }

                            for (index, var rule) in duplicatesNewRules.enumerated() {
                                rule[valueIndex] = newRule.value2
                                duplicatesNewRules[index] = rule
                            }
                            newRules += duplicatesNewRules
                        }
                    }
                }
                zeroRules.remove(rule)
                for rule in newRules {
                    zeroRules.insert(rule.joined(separator: " "))
                }

            }
            var good = 0
            for rule in zeroRules {
                if rule.trimmingCharacters(in: Day_19_2020.allowedCharacters).isEmpty {
                    good += 1
//                    zeroRulesSet.insert(rule.replacingOccurrences(of: " ", with: ""))
//                    zeroRules.remove(rule)
                }
            }
            print("\(good) / \(zeroRules.count)")
            if good == zeroRules.count {
                run = false
            }
        }

        for rule in zeroRules {
            zeroRulesSet.insert(rule.replacingOccurrences(of: " ", with: ""))
        }

        var validMessages = 0
        for message in messages {
            if zeroRulesSet.contains(message) {
                validMessages += 1
            }
        }

        return "\(validMessages)"
    }

    static func solvePart2(input: [String]) -> String {
        "Add some Code here"
    }
}

/*
 8 11
 42 42 31

 120 16 120 16 31
 120 16 2 126 31
 2 126 120 16 31
 2 126 2 126 31


 */
