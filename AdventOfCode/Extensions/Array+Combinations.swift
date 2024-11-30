//
//  Array+Combinations.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 30.11.24.
//


extension Array {
    func uniqueCombinations(ofLength k: Int) -> [[Element]] {
        // Wenn k größer als die Anzahl der Elemente im Array ist, gibt es keine Kombinationen
        guard k > 0, k <= self.count else {
            return []
        }
        
        var result: [[Element]] = []
        
        func combinations(startingAt index: Int, currentCombination: [Element]) {
            if currentCombination.count == k {
                result.append(currentCombination)
                return
            }
            
            for i in index..<self.count {
                combinations(startingAt: i + 1, currentCombination: currentCombination + [self[i]])
            }
        }
        
        combinations(startingAt: 0, currentCombination: [])
    
        return result
    }
}
