//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/11

enum Day_11_2022: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2022

    enum Operation {
        case add, mul, quad
    }

    class Monkey {
        init(
            number: Int,
            itemWorryLevels: [Int],
            operation: Day_11_2022.Operation,
            operationValue: Int,
            testValue: Int,
            trueMonkey: Int,
            falseMonkey: Int,
            counter: Int = 0
        ) {
            self.number = number
            self.itemWorryLevels = itemWorryLevels
            self.operation = operation
            self.operationValue = operationValue
            self.testValue = testValue
            self.trueMonkey = trueMonkey
            self.falseMonkey = falseMonkey
            self.counter = counter
        }

        let number: Int
        var itemWorryLevels: [Int]
        let operation: Operation
        let operationValue: Int
        let testValue: Int
        let trueMonkey: Int
        let falseMonkey: Int
        var counter: Int

        func getNextMonkeyFor(
            itemWorryLevel: Int,
            with commonModulo: Int,
            isPart1: Bool = true) -> (nextMonkey: Int, itemWorryLevel: Int) {
            var newLevel: Int
            switch operation {
            case .add:
                newLevel = itemWorryLevel + operationValue
            case .mul:
                newLevel = itemWorryLevel * operationValue
            case .quad:
                newLevel = itemWorryLevel * itemWorryLevel
            }

            if isPart1 {
                newLevel = newLevel/3
            }

            counter += 1

            let commonModuloValue = newLevel % commonModulo
            if commonModuloValue % testValue == 0 {
                return (trueMonkey, commonModuloValue)
            } else {
                return (falseMonkey, commonModuloValue)
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        let monkeys: [Monkey] = getMonkeys(for: input)
        let commonModulo = monkeys.map { $0.testValue }.reduce(1, *)
        var round = 1

        while round <= 20 {
            for m in 0..<monkeys.count {
                for _ in monkeys[m].itemWorryLevels {
                    let item = monkeys[m].itemWorryLevels.removeFirst()
                    let nextMonkey = monkeys[m].getNextMonkeyFor(itemWorryLevel: item, with: commonModulo)
                    monkeys.first {
                        $0.number == nextMonkey.nextMonkey
                    }!.itemWorryLevels.append(nextMonkey.itemWorryLevel)
                }
            }

            round += 1
        }

        let inspections = monkeys.map { $0.counter }.sorted(by: >)

        return "\(inspections[0] * inspections[1])"
    }

    static func solvePart2(input: [String]) -> String {
        let monkeys: [Monkey] = getMonkeys(for: input)
        let commonModulo = monkeys.map { $0.testValue }.reduce(1, *)
        var round = 1

        while round <= 10000 {
            for m in 0..<monkeys.count {
                for _ in monkeys[m].itemWorryLevels {
                    let item = monkeys[m].itemWorryLevels.removeFirst()
                    let nextMonkey = monkeys[m].getNextMonkeyFor(itemWorryLevel: item, with: commonModulo)
                    monkeys.first {
                        $0.number == nextMonkey.nextMonkey
                    }!.itemWorryLevels.append(nextMonkey.itemWorryLevel)

                }
            }

            round += 1
        }

        let inspections = monkeys.map { $0.counter }.sorted(by: >)

        return "\(inspections[0] * inspections[1])"
    }

    static func getMonkeys(for input: [String]) -> [Monkey] {
        var monkeys: [Monkey] = []
        for line in stride(from: 0, to: input.count, by: 7) {
            var numberStr = input[line].components(separatedBy: " ")[1]
            numberStr.removeLast()

            let itemWorryLevels = input[line+1]
                .components(separatedBy: ": ")[1]
                .components(separatedBy: ", ")
                .map { Int($0)! }

            let operation: Operation
            let operationValue: Int
            var operationCmp = input[line+2].components(separatedBy: " ")
            if let value = Int(operationCmp.removeLast()) {
                operationValue = value
                if operationCmp.last == "+" {
                    operation = .add
                } else if operationCmp.last == "*" {
                    operation = .mul
                } else {
                    fatalError()
                }
            } else {
                operation = .quad
                operationValue = 0
            }

            let testValue = Int(input[line+3].components(separatedBy: " ").last!)!
            let trueMonkey = Int(input[line+4].components(separatedBy: " ").last!)!
            let falseMonkey = Int(input[line+5].components(separatedBy: " ").last!)!

            monkeys.append(Monkey(
                number: Int(numberStr)!,
                itemWorryLevels: itemWorryLevels,
                operation: operation,
                operationValue: operationValue,
                testValue: testValue,
                trueMonkey: trueMonkey,
                falseMonkey: falseMonkey
            ))
        }

        return monkeys
    }
}
