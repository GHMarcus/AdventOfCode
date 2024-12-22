//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/22

// Took 40.4521279335022 seconds
enum Day_22_2024: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Int]
    
    static func convert(input: [String]) -> ConvertedInput {
        input.map{ Int($0)! }
    }
    
    static func mixAndPrune(_ number: Int, newNumber: Int) -> Int {
        (newNumber ^ number) % 16777216
    }
    
    static func solvePart1(input: ConvertedInput) -> String {
        var numbers = input
        
        for _ in 0..<2000 {
            for n in 0..<numbers.count {
                let current = numbers[n]
                let v1 = mixAndPrune(current, newNumber: current * 64)
                let v2 = mixAndPrune(v1, newNumber: v1 / 32)
                let v3 = mixAndPrune(v2, newNumber: v2 * 2048)
                numbers[n] = v3
            }
        }
        
        return "\(numbers.reduce(0, +))"
    }
    
    static func solvePart2(input: ConvertedInput) -> String {
        var numbers = input
        
        var priceDiffs: [[(price: Int, diff: Int)]] = []
        
        for n in 0..<numbers.count {
            var currentPriceDiffs: [(price: Int, diff: Int)] = []
            for _ in 0..<2000 {
                let current = numbers[n]
                let v1 = mixAndPrune(current, newNumber: current * 64)
                let v2 = mixAndPrune(v1, newNumber: v1 / 32)
                let v3 = mixAndPrune(v2, newNumber: v2 * 2048)
                
                let price = v3 % 10
                let prevPrice = current % 10
                currentPriceDiffs.append((price, diff: price - prevPrice))
                numbers[n] = v3
            }
            priceDiffs.append(currentPriceDiffs)
        }
        
        var pricesBySequence: [[[Int]: Int]] = []
        var uniqueSequences: Set<[Int]> = []
        
        for priceDiff in priceDiffs {
            var priceBySequence: [[Int]: Int] = [:]
            for i in 0..<priceDiff.count-3 {
                let sequence = priceDiff[i...i+3].map { $0.diff }
                let price = priceDiff[i+3].price
                    
                // Only first appear of sequence should be saved
                if priceBySequence[sequence] == nil {
                    uniqueSequences.insert(sequence)
                    priceBySequence[sequence] = price
                }
            }
            pricesBySequence.append(priceBySequence)
        }
        
        var maxBananas = 0
        for uniqueSequence in uniqueSequences {
            let current = pricesBySequence.map {
             return $0[uniqueSequence] ?? 0
            }.reduce(0, +)
            maxBananas = max(maxBananas, current)
        }
        
        return "\(maxBananas)"
    }
}
