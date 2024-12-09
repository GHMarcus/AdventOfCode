//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/1

enum Day_1_2024: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (left: [Int], right: [Int])

    static func convert(input: [String]) -> ConvertedInput {
        var leftList: [Int] = []
        var rightList: [Int] = []
        
        for line in input {
            let cmp = line.components(separatedBy: "   ")
            leftList.append(Int(cmp[0])!)
            rightList.append(Int(cmp[1])!)
        }
        
        return (left: leftList, right: rightList)
    }

    static func solvePart1(input: ConvertedInput) -> String {
        
        let sortedLeft = input.left.sorted()
        let sortedRight = input.right.sorted()
        
        var sumOfDistances: Int = 0
        
        for n in 0..<sortedLeft.count {
            sumOfDistances += abs(sortedLeft[n] - sortedRight[n])
        }
        
        return "\(sumOfDistances)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        
        let countedRightList = input.right.countedElements
        var similarityScore: Int = 0
        
        for i in input.left {
            similarityScore += (countedRightList[i] ?? 0) * i
        }
        
        return "\(similarityScore)"
    }
}
