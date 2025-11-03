//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/15

enum Day_15_2017: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2017
    
    class Generator {
        let factor: Int
        let criteria: Int
        var prevValue: Int
        
        init(initValue: Int, factor: Int, criteria: Int) {
            prevValue = initValue
            self.factor = factor
            self.criteria = criteria
        }
        
        func next() -> Int {
            let next = (prevValue * factor) % 2147483647
            prevValue = next
            return next
        }
        
        func nextCriteriaValue() -> Int {
            while true {
                let next = next()
                if next.isMultiple(of: criteria) {
                    return next
                }
            }
        }
    }

    static func convert(input: [String]) -> [Int] {
        input.map {
            let cmp = $0.components(separatedBy: " ")
            return Int(cmp[4])!
        }
    }
    
    static func solvePart1(input: [Int]) -> String {
        let genA = Generator(initValue: input[0], factor: 16807, criteria: 4)
        let genB = Generator(initValue: input[1], factor: 48271, criteria: 8)
        
        var judgeCount = 0
        
        for _ in 0..<40000000 {
            if compare(genA.next(), genB.next()) {
               judgeCount += 1
            }
        }
        
        return "\(judgeCount)"
    }

    static func solvePart2(input: [Int]) -> String {
        let genA = Generator(initValue: input[0], factor: 16807, criteria: 4)
        let genB = Generator(initValue: input[1], factor: 48271, criteria: 8)
        
        var judgeCount = 0
        
        for _ in 0..<5000000 {
            if compare(genA.nextCriteriaValue(), genB.nextCriteriaValue()) {
               judgeCount += 1
            }
        }
        
        return "\(judgeCount)"
    }
    
    static func compare(_ a: Int, _ b: Int) -> Bool {
        let a16 = a & 65535
        let b16 = b & 65535
        
        return a16 == b16
    }
}
