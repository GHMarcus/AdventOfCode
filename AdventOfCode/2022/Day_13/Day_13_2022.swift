//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/13

enum Day_13_2022: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2022
    
    class Signal {
        init(own: String) {
            self.own = own
        }
        enum Kind {
            case integer, array
        }
        
        var own: String
        var subParts: [Signal] = []
        
        var kind: Kind {
            if own.contains("[") {
                return .array
            } else {
                return .integer
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        var rightOrders: [Int] = []
        var orderNumber = 1

        var checkPairs: [(left: Signal, right: Signal)] = []
        for l in stride(from: 0, to: input.count, by: 3) {
            let leftSignal = createSignal(for: input[l])
            let rightSignal = createSignal(for: input[l+1])
            
            checkPairs.append((leftSignal, rightSignal))
        }
        
        for pair in checkPairs {
            if let value = checkSignalOrder(pair.left, pair.right), value {
                rightOrders.append(orderNumber)
            }
            orderNumber += 1
        }

        return "\(rightOrders.reduce(0, +))"
    }

    static func solvePart2(input: [String]) -> String {
        let divider1 = "[[2]]"
        let divider2 = "[[6]]"
        var input = input
        input.append(contentsOf: ["", divider1, divider2])

        var signals: [Signal] = []
        for l in stride(from: 0, to: input.count, by: 3) {
            let leftSignal = createSignal(for: input[l])
            let rightSignal = createSignal(for: input[l+1])
            
            signals.append(contentsOf: [leftSignal, rightSignal])
        }
        
        signals = signals.sorted {
            checkSignalOrder($0, $1) ?? false
        }
        
        let divider1Index = Int(signals.firstIndex { $0.own == divider1 }!)
        let divider2Index = Int(signals.firstIndex { $0.own == divider2 }!)

        return "\((divider1Index + 1) * (divider2Index + 1))"
    }
    
    static func checkSignalOrder(_ left: Signal, _ right: Signal) -> Bool? {
        switch (left.kind, right.kind) {
        case (.integer, .integer):
            if let leftInt = Int(left.own), let rightInt = Int(right.own), leftInt < rightInt {
                return true
            } else if let leftInt = Int(left.own), let rightInt = Int(right.own), leftInt > rightInt  {
                return false
            } else {
                return nil
            }
        case (.integer, .array):
            let leftSubPart = Signal(own: left.own)
            left.subParts.append(leftSubPart)
            left.own = "[" + left.own + "]"
            return checkSignalOrder(left, right)
        case (.array, .integer):
            let rightSubPart = Signal(own: right.own)
            right.subParts.append(rightSubPart)
            right.own = "[" + right.own + "]"
            return checkSignalOrder(left, right)
        case (.array, .array):
            if left.subParts[0].own.isEmpty, !right.subParts[0].own.isEmpty {
                return true
            }
            if right.subParts[0].own.isEmpty, !left.subParts[0].own.isEmpty {
                return false
            }
            for n in 0..<left.subParts.count {
                if n >= right.subParts.count {
                    return false
                }
                if let value = checkSignalOrder(left.subParts[n], right.subParts[n]) {
                    return value
                }
            }
            if left.subParts.count < right.subParts.count {
                return true
            }
        }
        
        return nil
    }
    
    static func createSignal(for string: String) -> Signal {
        let signal = Signal(own: string)
        
        guard string.contains("[") else {
            return signal
        }
        // Get rid of the outer most brackets
        var parts = Array(string)
        parts.removeLast()
        parts.removeFirst()
        
        var subparts: [String] = []
        var currentPart: [Character] = []
        var openingInnerBrackets = 0
        for c in parts {
            if c == ",", openingInnerBrackets == 0 {
                subparts.append(String(currentPart))
                currentPart = []
            } else if c == "[" {
                openingInnerBrackets += 1
                currentPart.append(c)
            } else if c == "]" {
                openingInnerBrackets -= 1
                currentPart.append(c)
            } else {
                currentPart.append(c)
            }
        }
        
        subparts.append(String(currentPart))
        
        signal.subParts = subparts.map{
            createSignal(for: $0)
        }
        
        return signal
    }
}
