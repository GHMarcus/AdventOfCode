//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/14

enum Day_14_2021: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var input = input
        var polymer = Array(input.removeFirst())
        input.removeFirst()
        var insertions: [(String, Character)] = []

        for line in input {
            let comps = line.components(separatedBy: " -> ")
            insertions.append((comps[0], Character(comps[1])))
        }

        var count = 0
        while count < 10 {
            count += 1
            var newPolymer: [String.Element] = []

        out: for pos in 0..<polymer.count {
            guard pos+1 < polymer.count else {
                newPolymer.append(polymer[pos])
                break
            }
            let pair = String(polymer[pos]) + String(polymer[pos+1])
            for insertion in insertions {
                if pair == insertion.0 {
                    newPolymer.append(polymer[pos])
                    newPolymer.append(insertion.1)
                    continue out
                }
            }
            newPolymer.append(polymer[pos])
        }
            polymer = newPolymer
        }

        let occurrences =  String(polymer).getCountedCharacters.sorted {
            $0.value > $1.value
        }

        return "\(occurrences.first!.value - occurrences.last!.value)"
    }

    static func solvePart2(input: [String]) -> String {
        var input = input
        let polymer = Array(input.removeFirst())
        input.removeFirst()
        var insertions: [(String, Character)] = []

        for line in input {
            let comps = line.components(separatedBy: " -> ")
            insertions.append((comps[0], Character(comps[1])))
        }
        
        var pairs: [String: Int] = [:]
        
        for i in 0..<polymer.count-1 {
            let pair = String(polymer[i]) + String(polymer[i+1])
            pairs.updateValue(pairs[pair, default: 0] + 1, forKey: pair)
        }
        
        var countedCharacters = String(polymer).getCountedCharacters

        var count = 0
        while count < 40 {
            count += 1
            var newPairs: [String: Int] = [:]
            for pair in pairs {
                for insertion in insertions {
                    if pair.key == insertion.0 {
                        var newPair1 = String(pair.key.first!)
                            newPair1.append(insertion.1)
                        var newPair2 = String(insertion.1)
                            newPair2.append(pair.key.last!)
                        
                        countedCharacters.updateValue(countedCharacters[insertion.1, default: 0] + pair.value, forKey: insertion.1)
                        newPairs.updateValue(newPairs[newPair1, default: 0] + pair.value, forKey: newPair1)
                        newPairs.updateValue(newPairs[newPair2, default: 0] + pair.value, forKey: newPair2)
                        
                        break
                    }
                }
            }
            pairs = newPairs
        }
        
        let occurrences =  countedCharacters.sorted {
            $0.value > $1.value
        }

        return "\(occurrences.first!.value - occurrences.last!.value)"
    }
}
