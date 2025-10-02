//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/12

enum Day_12_2023: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2023
    
    static func convert(input: [String]) -> [([Character], [Int])] {
        var lines: [([Character], [Int])] = []
        for line in input {
            let cmp = line.components(separatedBy: " ")
            let record = cmp[0]
            let springsValues = cmp[1].components(separatedBy: ",").map { Int($0)! }
            lines.append((Array(record), springsValues))
        }
        return lines
    }

    static func solvePart1(input: [([Character], [Int])]) -> String {
        var sum = 0
        
        for (record, springs) in prepareInput(input) {
            sum += countArrangements(record: record, springs: springs)
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: [([Character], [Int])]) -> String {
        var sum = 0
        
        for (record, springs) in prepareInput(input, isPart2: true) {
            sum += countArrangements(record: record, springs: springs)
        }
        
        return "\(sum)"
    }
    
    // With the help of this post: https://www.reddit.com/r/adventofcode/comments/18ge41g/2023_day_12_solutions/kd4ihxm/?context=3
    static func countArrangements(record: [Character], springs: [Bool]) -> Int {
        let n = record.count
        let m = springs.count
        
        var dp = Array(repeating: Array(repeating: 0, count: m+1), count: n+1)
        dp[n][m] = 1
        
        for i in (0..<n).reversed() {
            for j in (0..<m).reversed() {
                var damaged = false
                var operational = false
                
                switch record[i] {
                case "#":
                    damaged = true
                case ".":
                    operational = true
                default:
                    damaged = true
                    operational = true
                }
                
                var sum = 0
                if damaged && springs[j] {
                    sum += dp[i+1][j+1]
                } else if operational && !springs[j] {
                    sum += dp[i+1][j+1] + dp[i+1][j]
                }
                dp[i][j] = sum
            }
        }
        
        return dp[0][0]
    }
    
    static func prepareInput(_ input: [([Character], [Int])], isPart2: Bool = false) -> [([Character], [Bool])] {
        var newInput = [([Character], [Bool])]()
        let dot: [Character] = ["."]
        let question: [Character] = ["?"]
        
        for (origRecord, origSprings) in input {
            let springsValues: [Int]
            let record: [Character]
            if isPart2 {
                springsValues = origSprings+origSprings+origSprings+origSprings+origSprings
                record = dot + origRecord + question + origRecord + question + origRecord + question + origRecord + question + origRecord + dot
            } else {
                springsValues = origSprings
                record = dot + origRecord + dot
            }
            
            var springs: [Bool] = [false]
            for value in springsValues {
                springs.append(contentsOf: Array(repeating: true, count: value))
                springs.append(false)
            }
            
            newInput.append((record, springs))
        }
        
        return newInput
    }
    
    static func unfoldInput(_ input: [([Character], [Bool])]) -> [([Character], [Bool])] {
        var newInput = [([Character], [Bool])]()
        
        input.forEach {
            var newLine = $0.0
            var newArray = $0.1
            
            for _ in 0..<4 {
                newLine += "?" + $0.0
                newArray += $0.1
            }
            
            newInput.append((newLine, newArray))
        }
        
        return newInput
    }
}
