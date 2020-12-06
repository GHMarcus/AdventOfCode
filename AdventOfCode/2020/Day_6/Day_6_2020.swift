//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/6

enum Day_6_2020: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2020

    static func input() -> [String] {
        Input.getGroupedArray(for: day, in: year)
    }

    static func solvePart1(input: [String]) -> String {
        let combinedAnswers = input.map { answer -> String in
            answer.replacingOccurrences(of: " ", with: "").uniqueCharacters()
        }
        let yesCount = combinedAnswers.reduce(0) { (result, next) -> Int in
            result + next.count
        }
        return "\(yesCount)"
    }

    static func solvePart2(input: [String]) -> String {
        let cmps = input.map { $0.components(separatedBy: " ") }

        var grouped: [(count: Int, dict: [Character: Int])] = []

        guard cmps.count == input.count else {
            fatalError("Something went really wrong")
        }

        for i in 0..<input.count {
            let count = cmps[i].count
            let str = input[i].replacingOccurrences(of: " ", with: "")
            let dict = Array(str).reduce(into: [:]) { result, character in
                result[character, default: 0] += 1
            }
            grouped.append((count, dict))
        }

        let yesCount = grouped.reduce(0) { (result, next: (count: Int, dict: [Character: Int])) -> Int in
            var allAnsers = 0
            next.dict.forEach { (_, value) in
                if value == next.count {
                    allAnsers += 1
                }
            }
            return result + allAnsers

        }
        return "\(yesCount)"
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}

extension String {
    func uniqueCharacters() -> String {
        return String(self.unique())
    }
}
