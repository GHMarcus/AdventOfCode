//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/19

enum Day_19_2015: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        var input = input
        
        let startingMolecule = input.removeLast()
        input.removeLast()
        
        let replacements: [(String, String)] = input.map {
            let comps = $0.components(separatedBy: " ")
            return (comps.first!, comps.last!)
        }
        
        var generatedMolecules: Set<String> = []
        
        for replacement in replacements {
            let ranges = startingMolecule.ranges(of: replacement.0)
            for range in ranges {
                generatedMolecules.insert(startingMolecule.replacingCharacters(in: range, with: replacement.1))
            }
        }
        
        return "\(generatedMolecules.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var input = input
        
        var searchedMolecule = input.removeLast()
        input.removeLast()
        
        /// To ensure replacements of e happens at last, I have to put them on the end of the `replacements` array
        var electronReplacements: [(String, String)] = []
        var replacements: [(String, String)] = input.compactMap {
            let comps = $0.components(separatedBy: " ")
            
            if comps.first == "e" {
                electronReplacements.append((comps.first!, comps.last!))
                return nil
            } else {
                return (comps.first!, comps.last!)
            }
        }
        replacements.append(contentsOf: electronReplacements)
        
        
        var steps = 0
        while searchedMolecule != "e" {
            steps += 1
            for replacement in replacements {
                let ranges = searchedMolecule.ranges(of: replacement.1)
                
                if let range = ranges.first {
                    searchedMolecule = searchedMolecule.replacingCharacters(in: range, with: replacement.0)
                    break
                }
            }
        }
        
        return "\(steps)"
    }
}
