//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/5

struct Rule {
    let first, second: Int
    
    func needForUpdate(_ update: [Int]) -> Bool {
        update.contains(first) && update.contains(second)
    }
    
    func isNeeded(for value: Int) -> Bool {
        first == value || second == value
    }
    
    func isCorrect(value: Int, before: [Int], after: [Int]) -> Bool {
        if value == first {
            return after.contains(second)
        } else if value == second {
            return before.contains(first)
        } else {
            return false
        }
    }
}

enum Day_5_2024: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2024

    static func convert(input: [String]) -> (rules: [Rule], updates: [[Int]]) {
        var rules: [Rule] = []
        var updates: [[Int]] = []
        
        var isRule: Bool = true
        
        for line in input {
            if line.isEmpty {
                isRule = false
                continue
            }
            
            if isRule {
                let cmp = line.components(separatedBy: "|")
                rules.append(Rule(first: Int(cmp[0])!, second: Int(cmp[1])!))
            } else {
                let cmp = line.components(separatedBy: ",").map{Int($0)!}
                updates.append(cmp)
            }
        }
        
        return (rules, updates)
    }

    static func solvePart1(input: (rules: [Rule], updates: [[Int]])) -> String {
        let correctUpdates = getFilteredUpdates(for: input.updates, with: input.rules)
        
        return "\(sumOfMiddleValues(for: correctUpdates))"
    }

    static func solvePart2(input: (rules: [Rule], updates: [[Int]])) -> String {
        let inCorrectUpdates = getFilteredUpdates(for: input.updates, with: input.rules, wantIncorrectOnes: true)
        
        var correctedUpdates: [[Int]] = []
        
        for update in inCorrectUpdates {
            var toSortUpdate = update
            let neededRules = input.rules.filter {
                $0.needForUpdate(update)
            }
            
            var isCorrected: Bool = false
            
            while !isCorrected {
                isCorrected = true
                for (index, value) in toSortUpdate.enumerated() {
                    
                    for rule in neededRules.filter ({$0.isNeeded(for: value)}) {
                        let beforeValues = index > 0 ? Array(toSortUpdate[0..<index]) : []
                        let afterValues = index < toSortUpdate.count ? Array(toSortUpdate[index+1..<toSortUpdate.count]) : []
                        if !rule.isCorrect(value: value, before: beforeValues, after: afterValues) {
                            
                            if value == rule.first {
                                let secondIndex = toSortUpdate.firstIndex(of: rule.second)!
                                toSortUpdate[index] = rule.second
                                toSortUpdate[secondIndex] = rule.first
                            } else {
                                let firstIndex = toSortUpdate.firstIndex(of: rule.first)!
                                toSortUpdate[index] = rule.first
                                toSortUpdate[firstIndex] = rule.second
                            }
                            
                            isCorrected = false
                            break
                        }
                    }
                    if !isCorrected {
                        break
                    }
                }
            }
            
            correctedUpdates.append(toSortUpdate)
            
        }
        
        return "\(sumOfMiddleValues(for: correctedUpdates))"
    }
    
    static func getFilteredUpdates(for updates: [[Int]], with rules: [Rule], wantIncorrectOnes: Bool = false) -> [[Int]] {
        var correctUpdates: [[Int]] = []
        var inCorrectUpdates: [[Int]] = []
        
        for update in updates {
            let neededRules = rules.filter {
                $0.needForUpdate(update)
            }
            
            var isCorrect: Bool = true
            
            for (index, value) in update.enumerated() {
                let beforeValues = index > 0 ? Array(update[0..<index]) : []
                let afterValues = index < update.count ? Array(update[index+1..<update.count]) : []
                
                isCorrect = isCorrect && neededRules.filter {
                    $0.isNeeded(for: value)
                }
                .allSatisfy {
                    $0.isCorrect(value: value, before: beforeValues, after: afterValues)
                }
            }
            
            if isCorrect {
                correctUpdates.append(update)
            } else {
                inCorrectUpdates.append(update)
            }
        }
        
        return wantIncorrectOnes ? inCorrectUpdates : correctUpdates
    }
    
    static func sumOfMiddleValues(for updates: [[Int]]) -> Int {
        updates.reduce(into: 0) { partialResult, update in
            if update.count.isEven {
                partialResult += update[update.count/2-1]
            } else {
                partialResult += update[update.count/2]
            }
        }
    }
}
