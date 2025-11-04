//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/17

enum Day_17_2017: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2017
    
    static func convert(input: [String]) -> Int {
        Int(input.first!)!
    }

    static func solvePart1(input: Int) -> String {
        var values: [Int] = [0]
        var current = 0
        for i in 1...2017 {
            if values.count == 1 {
                values.append(i)
                current = 1
            } else {
                let index = (current + input + 1) % values.count
//                print(values, index, i)
                //
                values.insert(i, at: index)
                current = index
            }
        }
        
        return "\(values[current + 1])"
    }

    // Note: Thanks to https://www.reddit.com/r/adventofcode/comments/7kc0xw/comment/drd61ue/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    // I did not needed to brute force it with all values.
    
    static func solvePart2(input: Int) -> String {
        var current = 0
        var valueAtIndex1 = 0
        for i in 1...50000000 {
            let index = ((input + current) % i) + 1
            current = index
            if index == 1 {
                valueAtIndex1 = i
            }
        }
        
        return "\(valueAtIndex1)"
    }
}
