//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/18

enum Day_18_2021: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var input = input
        while input.count > 1 {
            // Addition
            let newNumber = "[" + input[0] + "," + input[1] + "]"
            input = Array(input.dropFirst(2))
            input.insert(executeActions(newNumber), at: 0)

        }

        return "\(calculateMagnitude(number: input[0]))"
    }

    // Take about 32 seconds (with speed optimization) , but I don't want to refactoring it :D
    static func solvePart2(input: [String]) -> String {
        var magnitues: [Int] = []

        for first in 0..<input.count {
            for second in 0..<input.count {
                if first == second {
                    continue
                }

                var newNumber_one = "[" + input[first] + "," + input[second] + "]"
                newNumber_one = executeActions(newNumber_one)
                magnitues.append(calculateMagnitude(number: newNumber_one))


                var newNumber_two = "[" + input[second] + "," + input[first] + "]"
                newNumber_two = executeActions(newNumber_two)
                magnitues.append(calculateMagnitude(number: newNumber_two))
            }
        }

        return "\(magnitues.max()!)"
    }
}

extension Day_18_2021 {
    static func executeActions(_ number: String) -> String {

        var number = number
        while true {
            var actionsExecuted = 0
            while true {
                let newNumber = executeExplode(number)
                if newNumber == number {
                    number = newNumber
                    break
                }
                actionsExecuted += 1
                number = newNumber
            }

            while true {
                let newNumber = executeSplit(number)
                if newNumber == number {
                    number = newNumber
                    break
                }
                actionsExecuted += 1
                number = newNumber
                break
            }
            if actionsExecuted == 0 {
                break
            }
        }

        return number
    }

    static func executeExplode(_ number: String) -> String {
        let number = Array(number)
        var opening = 0
    out: for i in 0..<number.count {
            if number[i] == "[" {
                opening += 1
                continue
            }
            if number[i] == "]" {
                opening -= 1
                continue
            }
            if number[i] == "," && opening >= 5 {

                // Find exploding values
                var leftExplodingBracketIndex = 0
                var leftExplodingValue = ""
                var rightExplodingBracketIndex = 0
                var rightExplodingValue = ""

                for l in (0..<i).reversed() {
                    if number[l] == "[" {
                        leftExplodingBracketIndex = l
                        break
                    }
                    leftExplodingValue = String(number[l]) + leftExplodingValue
                    if Int(leftExplodingValue) == nil {
                        continue out
                    }
                }

                for r in i+1 ..< number.count {
                    if number[r] == "]" {
                        rightExplodingBracketIndex = r
                        break
                    }
                    rightExplodingValue.append(number[r])
                    if Int(rightExplodingValue) == nil {
                        continue out
                    }
                }

                // Find left value
                var leftCommaIndex = 0
                var leftBracketIndex = 0
                for lc in (0..<leftExplodingBracketIndex).reversed() {
                    if number[lc] == "," {
                        leftCommaIndex = lc
                        for lb in (0..<lc).reversed() {
                            if number[lb] == "]" {
                                leftCommaIndex = lb
                                for lb2 in (0..<lb).reversed() {
                                    if number[lb2] == "]" {
                                        leftCommaIndex = lb2
                                    }
                                    if number[lb2] == "," {
                                        leftBracketIndex = lb2
                                        break
                                    }
                                }
                                break
                            } else if number[lb] == "[" {
                                leftBracketIndex = lb
                                break
                            }
                        }
                        break
                    }
                }

                var newNumber: [Character] = []

                if leftCommaIndex != 0 {
                    let leftValue = number.dropLast(number.count-leftCommaIndex).dropFirst(leftBracketIndex+1)
                    let newValue = String(Int(String(leftValue))!+Int(leftExplodingValue)!)

                    for n in 0...leftBracketIndex {
                        newNumber.append(number[n])
                    }
                    newNumber.append(contentsOf: Array(newValue))

                    for n in leftCommaIndex...leftExplodingBracketIndex-1 {
                        newNumber.append(number[n])
                    }
                } else {
                    for n in 0 ..< leftExplodingBracketIndex {
                        newNumber.append(number[n])
                    }
                }


                newNumber.append(contentsOf: "0")

                // Find exploding values
                var rightCommaIndex = 0
                var rightBracketIndex = 0
                for rc in rightExplodingBracketIndex+1 ..< number.count {
                    if number[rc] == "," {
                        rightCommaIndex = rc
                        for rb in rc+1 ..< number.count {
                            if number[rb] == "[" {
                                rightCommaIndex = rb
                                for rb2 in rb+1 ..< number.count {
                                    if number[rb2] == "[" {
                                        rightCommaIndex = rb2
                                    }
                                    if number[rb2] == "," {
                                        rightBracketIndex = rb2
                                        break
                                    }
                                }
                                break
                            } else if number[rb] == "]" {
                                rightBracketIndex = rb
                                break
                            }
                        }
                        break
                    }
                }

                if rightCommaIndex != 0 {
                    let rightValue = number.dropLast(number.count-rightBracketIndex).dropFirst(rightCommaIndex+1)
                    let newValue = String(Int(String(rightValue))!+Int(rightExplodingValue)!)

                    for n in rightExplodingBracketIndex+1 ... rightCommaIndex {
                        newNumber.append(number[n])
                    }
                    newNumber.append(contentsOf: Array(newValue))
                    for n in rightBracketIndex ..< number.count {
                        newNumber.append(number[n])
                    }
                } else {
                    for n in rightExplodingBracketIndex+1 ..< number.count {
                        newNumber.append(number[n])
                    }
                }
                return String(newNumber)
            }
         }
        return String(number)
    }

    static func executeSplit(_ number: String) -> String {
        var number = Array(number)

        for var c in 0 ..< number.count {
            var value = ""
            if number[c] != "[" || number[c] != "," || number[c] != "]" {
                for v in c..<number.count {
                    if number[v] != "[" || number[v] != "," || number[v] != "]" {
                        if let value = Int(value), value > 9 {
                            let lowValue = value/2
                            let highValue: Int
                            if value%2 == 0 {
                                highValue = value/2
                            } else {
                                highValue = value/2 + 1
                            }
                            let newValue = Array("[" + String(lowValue) + "," + String(highValue) + "]")
                            number.replaceSubrange(c-1..<v, with: newValue)
                            return String(number)
                        } else {
                            c = v
                        }
                    }
                    value.append(number[v])
                }
            }
        }



        return String(number)
    }

    static func calculateMagnitude(number: String) -> Int {
        var number = Array(number)
        var indexes = number.allIndices(of: ",")
        while indexes.count > 1 {
            for index in indexes {
                var left = ""
                var leftIndex = 0
                for l in (0..<index).reversed() {
                    if number[l] == "[" {
                        leftIndex = l
                        break
                    }
                    if number[l] == "]" {
                        left = ""
                        break
                    }
                    left = String(number[l]) + left
                }

                var right = ""
                var rightIndex = 0
                for r in index+1 ..< number.count {
                    if number[r] == "]" {
                        rightIndex = r
                        break
                    }
                    if number[r] == "[" {
                        right = ""
                        break
                    }
                    right.append(number[r])
                }

                if !left.isEmpty && !right.isEmpty {
                    let new = 3 * Int(left)! + 2  * Int(right)!
                    number.replaceSubrange(leftIndex...rightIndex, with: Array(String(new)))
                    break
                }
            }
            indexes = number.allIndices(of: ",")
        }
        number.removeFirst()
        number.removeLast()
        let comps = String(number).components(separatedBy: ",")

        return 3 * Int(comps[0])! + 2 * Int(comps[1])!
    }
}
