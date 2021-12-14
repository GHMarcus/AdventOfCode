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
        let template = Array(input.removeFirst())
        input.removeFirst()
        var insertions: [(String, Character)] = []

        for line in input {
            let comps = line.components(separatedBy: " -> ")
            insertions.append((comps[0], Character(comps[1])))
        }

        var polymer = template
        var count = 0
        while count < 10 {
            count += 1
//            print("Step: \(count)")
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

//        print(occurrences)

        return "\(occurrences.first!.value - occurrences.last!.value)"
    }

    static func solvePart2(input: [String]) -> String {
        var input = input
        let template = Array(input.removeFirst())
        input.removeFirst()
        var insertions: [(String, Character)] = []

        for line in input {
            let comps = line.components(separatedBy: " -> ")
            insertions.append((comps[0], Character(comps[1])))
        }

        var polymer = template
        var count = 0
        while count < 40 {
            count += 1
            print("Step: \(count)")
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

//        print(occurrences)

        return "\(occurrences.first!.value - occurrences.last!.value)"
    }
}
