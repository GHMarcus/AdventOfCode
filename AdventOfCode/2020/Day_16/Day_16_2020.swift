//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/16

enum Day_16_2020: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2020

    struct Field: Equatable {
        let name: String
        let lowerRange: ClosedRange<Int>
        let upperRange: ClosedRange<Int>

        init(fieldStr: String) {
            let cmp = fieldStr.components(separatedBy: ": ")
            name = cmp.first ?? ""
            let ranges = (cmp.last ?? "").components(separatedBy: " or ")
            let rangeOne = (ranges.first ?? "").components(separatedBy: "-")
            let rangeTwo = (ranges.last ?? "").components(separatedBy: "-")
            lowerRange = (Int(rangeOne.first ?? "") ?? 0)...(Int(rangeOne.last ?? "") ?? 0)
            upperRange = (Int(rangeTwo.first ?? "") ?? 0)...(Int(rangeTwo.last ?? "") ?? 0)
        }

        func containsValue(_ value: Int) -> Bool {
            lowerRange.contains(value) || upperRange.contains(value)
        }
    }

    enum Inputs {
        case fields, ownTicket, nearbyTickets
    }

    static var fields: [Field] = []
    static var ownTicket: [Int] = []
    static var nearbyTickets: [[Int]] = []

    static func solvePart1(input: [String]) -> String {
        var inputType = Inputs.fields

        for line in input {

            if line == "" {
                continue
            }

            if line == "your ticket:" {
                inputType = .ownTicket
                continue
            }

            if line == "nearby tickets:" {
                inputType = .nearbyTickets
                continue
            }

            switch inputType {
            case .fields:
                fields.append(.init(fieldStr: line))
            case .ownTicket:
                ownTicket = line.components(separatedBy: ",").compactMap{ Int($0) }
            case .nearbyTickets:
                let values = line.components(separatedBy: ",").compactMap{ Int($0) }
                nearbyTickets.append(values)
            }

        }

        var notValidValues: [Int] = []
        for ticket in nearbyTickets {
            for value in ticket {
                var minOneValueValid = false
                for field in fields {
                    if field.containsValue(value) {
                        minOneValueValid = true
                        break
                    }
                }
                if !minOneValueValid {
                    notValidValues.append(value)

                }
            }
        }

        return "\(notValidValues.reduce(0, +))"
    }

    static func solvePart2(input: [String]) -> String {
        var validTickets: [[Int]] = []
        for ticket in nearbyTickets {
            var allTicketValuesValid = true
            for value in ticket {
                var minOneValueValid = false
                for field in fields {
                    if field.containsValue(value) {
                        minOneValueValid = true
                        break
                    }
                }
                if !minOneValueValid {
                    allTicketValuesValid = false
                    break
                }
            }
            if allTicketValuesValid {
                validTickets.append(ticket)
            }
        }

        // Combine same values to find the rule for it
        var combinedFieldValues: [[Int]] = []
        for index in 0..<ownTicket.count {
            var sameValues: [Int] = []
            for ticket in validTickets {
                sameValues.append(ticket[index])
            }
            combinedFieldValues.append(sameValues)
        }

        var rightFieldOrder: [[Field]] = []

        for sameValues in combinedFieldValues {
            var rightFields: [Field] = []
            for field in fields {
                var rightField = true
                for value in sameValues {
                    if !field.containsValue(value) {
                        rightField = false
                        break
                    }
                }
                if rightField {
                    rightFields.append(field)
                }
            }
            rightFieldOrder.append(rightFields)
        }

        var duplicates = true
        var index = 0
        let maxIndex = rightFieldOrder.count
        while duplicates {
            if index >= maxIndex {
                index = 0
            }

            if rightFieldOrder[index].count == 1 {
                for (outerIndex, fields) in rightFieldOrder.enumerated() {
                    if outerIndex == index {
                        continue
                    }
                    for (innerIndex, field) in fields.enumerated() {
                        if field == rightFieldOrder[index][0] {
                            rightFieldOrder[outerIndex].remove(at: innerIndex)
                        }
                    }
                }
            }

            duplicates = rightFieldOrder.reduce(0, { (result, fields) -> Int in
                result + fields.count
            }) != maxIndex

            index += 1
        }

        var departureIndexes: [Int] = []
        for (index, fields) in rightFieldOrder.enumerated() {
            if fields[0].name.contains("departure") {
                departureIndexes.append(index)
            }
        }

        var product = 1
        for index in departureIndexes {
            product *= ownTicket[index]
        }

        return "\(product)"
    }
}
