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
                    fatalError("Can not form Int Number in Rule")
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

        var zeroRulesSet: Set<String> = []

        for rule in getZeroRules(for: 0, in: rules) {
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
        var rules: [Rule] = []
        var messages: [String] = []
        var isRules = true
        for var line in input {
            if line == "" {
                isRules = false
                continue
            } else if line.dropLast(line.count-2) == "8:" {
                line = "8: 42 | 42 8"
            } else if line.dropLast(line.count-3) == "11:" {
                line = "11: 42 31 | 42 11 31"
            }
            if isRules {
                let ruleLine = line
                    .replacingOccurrences(of: "\"", with: "")
                    .components(separatedBy: ": ")
                guard ruleLine.count == 2,
                      let number = Int(ruleLine.first ?? "")
                else {
                    fatalError("Can not form Int Number in Rule")
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

        let messageSizes = messages.map { $0.count }

        let fourtyTwo = getZeroRules(for: 42, in: rules).map{ $0.replacingOccurrences(of: " ", with: "")}
        let thirtyOne = getZeroRules(for: 31, in: rules).map{ $0.replacingOccurrences(of: " ", with: "")}

        let size = (messageSizes.max() ?? 0) / ((fourtyTwo.first ?? "").replacingOccurrences(of: " ", with: "").count)
        let zeroes = getZeroRules(for: 0, in: rules, breakAfterIteration: true, size: size*2)

        var messageSet: Set<String> = []
        messages.forEach { messageSet.insert($0) }


        var splitedMessages: [[String]] = []
        for message in messageSet {
            splitedMessages.append(message.split(every: ((fourtyTwo.first ?? "").replacingOccurrences(of: " ", with: "").count)))
        }

        var newSplitedMessages: [[String]] = []
        for message in splitedMessages {
            var resultingMessage: [String] = []
            for split in message {
                if fourtyTwo.contains(split) {
                    resultingMessage.append("42")
                } else if thirtyOne.contains(split) {
                    resultingMessage.append("31")
                } else {
                    resultingMessage.append("nan")
                }
            }
            newSplitedMessages.append(resultingMessage)
        }

        let newMessages = newSplitedMessages.map { $0.joined(separator: " ")}
        var validMessages = 0

        for message in newMessages {
            if zeroes.contains(message) {
                validMessages += 1
            }
        }

        return "\(validMessages)"
    }

    static func getZeroRules(for zero: Int, in rules: [Rule], breakAfterIteration: Bool = false, size: Int = 0) -> Set<String> {

        guard let ruleZero = rules.first(where: { $0.number == zero }) else {
            fatalError("Can not find rule zero")
        }

        var zeroRules: Set<String> = [ruleZero.value1]

        if ruleZero.value2 != "" {
            zeroRules.insert(ruleZero.value2)
        }

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
                        
                        if breakAfterIteration && number != 8 && number != 11 {
                            continue
                        }

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
                }
            }

            if good == zeroRules.count {
                run = false
            }

            if breakAfterIteration {
                for rule in zeroRules {
                    if rule.components(separatedBy: " ").count >= size {
                        run = false
                        break
                    }
                }
            }
        }

        return zeroRules
    }
}

extension String {
    func split(every length:Int) -> [String] {
        guard length > 0 && length < count else { return [String(suffix(from:startIndex))] }

        return (0 ... (count - 1) / length).map { String(dropFirst($0 * length).prefix(length)) }
    }
}
