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

    static func solvePart1(input: [String]) -> String {
        var rightOrders: [Int] = []
        var orderNumber = 1
        
        for l in stride(from: 0, to: input.count, by: 3) {
            let leftSide = input[l]
            let rightSide = input[l+1]

            if checkOrderFor(left: leftSide, right: rightSide) {
                rightOrders.append(orderNumber)
            }
            orderNumber += 1
        }

        print("*********************************")
        print(rightOrders)

        return "\(rightOrders.reduce(0, +))"
    }

    static func solvePart2(input: [String]) -> String {
        return "Add some Code here"
    }

    static func checkOrderFor(left: String, right: String) -> Bool {
        if left.countInstances(of: "[") == right.countInstances(of: "[") {
//            print("------------------------------")
            let leftInts = left
                .replacingOccurrences(of: "[", with: " ")
                .replacingOccurrences(of: "]", with: " ")
                .replacingOccurrences(of: ",", with: " ")
                .components(separatedBy: " ")
                .compactMap { Int($0) }
//            print(leftInts)

            let rightInts = right
                .replacingOccurrences(of: "[", with: " ")
                .replacingOccurrences(of: "]", with: " ")
                .replacingOccurrences(of: ",", with: " ")
                .components(separatedBy: " ")
                .compactMap { Int($0) }
            //            print(rightInts)

            var isRightOrder = true
            for n in 0..<leftInts.count {
                // right side run out of elements
                if n >= rightInts.count {
                    isRightOrder = false
                    break
                }
                // left side is bigger, so stop comparing
                if leftInts[n] > rightInts[n] {
                    isRightOrder = false
                    break
                }

                if leftInts[n] < rightInts[n] {
                    isRightOrder = true
                    break
                }
            }
            return isRightOrder
        } else {
            var leftParts: [String] = []
            var rightParts: [String] = []

            var leftArr = Array(left)
            var rightArr = Array(right)

            func getNextPartFrom(arr: [Character]) -> (part: String, rest: [Character]) {
                var openingBrs: [Int] = []

                var part = ""
                var rest = arr


                for c in 0..<arr.count {
                    if arr[c] == "[" {
                        openingBrs.append(c)
                    } else if arr[c] == "]" {
                        let openingBr = openingBrs.removeLast()
                        part = String(arr[openingBr...c])
                        if #available(macOS 13.0, *) {
                            rest = arr.replacing(arr[openingBr...c], with: [])
                        } else {
                            fatalError("Update your mac")
                        }
                        break
                    }
                }

                return (part, rest)
            }

            while true {
                if leftArr.isEmpty {
                    break
                }
                let next = getNextPartFrom(arr: leftArr)
                leftParts.append(next.part)
                leftArr = next.rest
            }

            while true {
                if rightArr.isEmpty {
                    break
                }
                let next = getNextPartFrom(arr: rightArr)
                rightParts.append(next.part)
                rightArr = next.rest
            }

            var isRightOrder = true

//            print("+++++++++++++++++++++++++++++")
//            print(leftParts)
//            print(rightParts)
//            print(left)
//            print(right)

            for n in 0..<leftParts.count {
                if leftParts[n] == "[,]" {
                    continue
                }
                if n >= rightParts.count {
                    isRightOrder = false
                    break
                }
                isRightOrder = isRightOrder && checkOrderFor(left: leftParts[n], right: rightParts[n])
            }



            return isRightOrder
        }


        return false
    }
}

// [5, 31, 42, 50, 69, 72, 76, 83, 104, 126, 146]
// 804 -> low
