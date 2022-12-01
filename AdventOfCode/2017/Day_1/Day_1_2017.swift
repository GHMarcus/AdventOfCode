//
//  Day_1.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/1

enum Day_1_2017: Solvable {
    static var day: Input.Day = .Day_1
    static var year: Input.Year = .Year_2017

    static func solvePart1(input: [Character]) -> String {
        var numbers = input.map { Int(String($0))! }
        let first = numbers.first!
        numbers.append(first)
        
        var sum = 0
        for i in 0..<numbers.count-1 {
            let current = numbers[i]
            if current == numbers[i+1] {
                sum += current
            }
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: [Character]) -> String {
        let numbers = input.map { Int(String($0))! }
        let offset = numbers.count / 2
        
        var sum = 0
        for i in 0..<numbers.count {
            let current = numbers[i]
            let next = i + offset > numbers.count - 1 ? (i + offset - numbers.count) : (i + offset)
            if current == numbers[next] {
                sum += current
            }
        }
        
        return "\(sum)"
    }
}
