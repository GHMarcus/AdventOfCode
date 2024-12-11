//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/11

enum Day_11_2024: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Int: Int]

    static func convert(input: [String]) -> ConvertedInput {
        var stones: ConvertedInput = [:]
        input[0].components(separatedBy: " ").map{ Int($0)! }.forEach { stone in
            stones[stone] = 1 + (stones[stone] ?? 0)
        }
        return stones
    }
    
    static func solvePart1(input: ConvertedInput) -> String {
        "\(blinking(25, with: input))"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        "\(blinking(75, with: input))"
    }
    
    static func blinking(_ blinks: Int, with stones: ConvertedInput) -> Int {
        var stones = stones
        for _ in 1...blinks {
            var newStones: ConvertedInput = [:]
            for (stone, count) in stones {
                if stone == 0 {
                    newStones[1] = count + (newStones[1] ?? 0)
                } else if String(stone).count.isEven {
                    let stoneStr = String(stone)
                    let length = stoneStr.count
                    let first = Int(stoneStr.dropLast(length/2))!
                    let last = Int(stoneStr.dropFirst(length/2))!
                    newStones[first] = count + (newStones[first] ?? 0)
                    newStones[last] = count + (newStones[last] ?? 0)
                } else {
                    let newValue = stone*2024
                    newStones[newValue] = count + (newStones[newValue] ?? 0)
                }
            }
            stones = newStones
        }
        
        return stones.values.reduce(0, +)
    }
}
