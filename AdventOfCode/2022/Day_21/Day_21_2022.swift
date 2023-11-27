//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/21

enum Day_21_2022: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2022


    class Monkey {
        enum Operation: String {
            case add = "+", sub = "-", mul = "*", div = "/"
        }

        let name: String
        var variables: [String]
        var operation: Operation
        var values: [Int]

        init(name: String, variables: [String], operation: Operation, values: [Int]) {
            self.name = name
            self.variables = variables
            self.operation = operation
            self.values = values
        }

        var value: Int {
            switch operation {
            case .add:
                return values.reduce(0, +)
            case .sub:
                return values[0] - values[1]
            case .mul:
                return values.reduce(1, *)
            case .div:
                return values[0] / values[1]
            }
        }
    }

    static func solvePart1(input: [String]) -> String {

        let parsedInput = parseInput(input)
        let monkeys: [Monkey] = parsedInput.0
        let rootMonkey: Monkey = parsedInput.1

        let rootValue = combineMonkeyVars(for: rootMonkey, in: monkeys)

        return "\(rootValue)"
    }

    static func solvePart2(input: [String]) -> String {

        let parsedInput = parseInput(input)
        let monkeys: [Monkey] = parsedInput.0
        let rootMonkey: Monkey = parsedInput.1

        let firstMonkey = monkeys.first { $0.name == rootMonkey.variables[0] }!
        let secondMonkey = monkeys.first { $0.name == rootMonkey.variables[1] }!

        let humanValue: Int
        // Note: Only one calculation path has the variable `human`
        if !hasHumanInCalculation(for: firstMonkey, in: monkeys) {
            let monkeyValue = combineMonkeyVars(for: firstMonkey, in: monkeys)
            humanValue = calculateHumanValue(for: monkeyValue, with: secondMonkey, in: monkeys)
        } else {
            let monkeyValue = combineMonkeyVars(for: secondMonkey, in: monkeys)
            humanValue = calculateHumanValue(for: monkeyValue, with: firstMonkey, in: monkeys)
        }

        return "\(humanValue)"
    }

    static func parseInput(_ input: [String]) -> ([Monkey], Monkey) {
        var monkeys: [Monkey] = []
        var rootMonkey: Monkey? = nil

        for line in input {
//        root: pppw + sjmn
//        dbpl: 5
            let cmp = line.components(separatedBy: " ")
            let name = String(cmp[0].dropLast())

            if cmp.count > 2 {
                let var1 = cmp[1]
                let var2 = cmp[3]
                let operation = Monkey.Operation(rawValue: cmp[2])!
                monkeys.append(Monkey(name: name, variables: [var1, var2], operation: operation, values: []))
            } else {
                let value = Int(cmp[1])!
                monkeys.append(Monkey(name: name, variables: [], operation: .add, values: [value]))
            }
            if name == "root" {
                rootMonkey = monkeys.last
            }
        }

        return (monkeys, rootMonkey!)
    }

    static func combineMonkeyVars(for monkey: Monkey, in monkeys: [Monkey]) -> Int {
        if monkey.variables.isEmpty {
            return monkey.value
        }

        let firstMonkey = monkeys.first { $0.name == monkey.variables[0] }!
        let secondMonkey = monkeys.first { $0.name == monkey.variables[1] }!

        let value1 = combineMonkeyVars(for: firstMonkey, in: monkeys)
        let value2 = combineMonkeyVars(for: secondMonkey, in: monkeys)
        let result: Int
        switch monkey.operation {
        case .add:
            result = value1 + value2
        case .sub:
            result = value1 - value2
        case .mul:
            result = value1 * value2
        case .div:
            result = value1 / value2
        }

        monkey.variables = []
        monkey.values = [value1, value2]

        return result
    }

    static func hasHumanInCalculation(for monkey: Monkey, in monkeys: [Monkey]) -> Bool {
        if monkey.name == "humn" {
            return true
        }

        for variable in monkey.variables {
            let nextMonkey = monkeys.first { $0.name == variable }!
            if hasHumanInCalculation(for: nextMonkey, in: monkeys) {
                return true
            }
        }

        return false
    }

    static func calculateHumanValue(for value: Int, with monkey: Monkey, in monkeys: [Monkey]) -> Int {
        if monkey.name == "humn" {
            return value
        }

        let firstMonkey = monkeys.first { $0.name == monkey.variables[0] }!
        let secondMonkey = monkeys.first { $0.name == monkey.variables[1] }!

        if hasHumanInCalculation(for: firstMonkey, in: monkeys) {
            let monkeyValue = combineMonkeyVars(for: secondMonkey, in: monkeys)
            switch monkey.operation {
            case .add:
                return calculateHumanValue(for: value - monkeyValue, with: firstMonkey, in: monkeys)
            case .sub:
                return calculateHumanValue(for: value + monkeyValue, with: firstMonkey, in: monkeys)
            case .mul:
                return calculateHumanValue(for: value / monkeyValue, with: firstMonkey, in: monkeys)
            case .div:
                return calculateHumanValue(for: value * monkeyValue, with: firstMonkey, in: monkeys)
            }
        } else {
            let monkeyValue = combineMonkeyVars(for: firstMonkey, in: monkeys)
            switch monkey.operation {
            case .add:
                return calculateHumanValue(for: value - monkeyValue, with: secondMonkey, in: monkeys)
            case .sub:
                return calculateHumanValue(for: ((value - monkeyValue) * -1), with: secondMonkey, in: monkeys)
            case .mul:
                return calculateHumanValue(for: value / monkeyValue, with: secondMonkey, in: monkeys)
            case .div:
                return calculateHumanValue(for: (1 / (value / monkeyValue)), with: secondMonkey, in: monkeys)
            }
        }
    }
}
