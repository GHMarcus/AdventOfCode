//
//  Day_2_2020.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

// https://adventofcode.com/2020/day/2

enum Day_2_2020: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2020

    struct Password {
        let rule: ClosedRange<Int>
        let letter: String
        let pwd: String

        var isValidOldPolicie: Bool {
            let occ = pwd.components(separatedBy: letter).count - 1
            return rule.contains(occ)
        }

        var isValidNewPolicie: Bool {
            let pwdArr = Array(pwd)
            let lowerChar = String(pwdArr[rule.lowerBound-1])
            let upperChar = String(pwdArr[rule.upperBound-1])

            return (lowerChar == letter) != (upperChar == letter)
        }
    }

    static func solvePart1(input: [String]) -> String {
        var validPwd: [Bool] = []
        input.forEach { line in
            validPwd.append(convertStringInPassword(line: line).isValidOldPolicie)
        }
        validPwd = validPwd.filter { $0 }
        return "\(validPwd.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var validPwd: [Bool] = []
        input.forEach { line in
            validPwd.append(convertStringInPassword(line: line).isValidNewPolicie)
        }
        validPwd = validPwd.filter { $0 }
        return "\(validPwd.count)"
    }

    private static func convertStringInPassword(line: String) -> Password {
        /// lines looks like this: `1-7 t: rtctmtt`

        let componets = line.components(separatedBy: " ")

        guard componets.count == 3 else {
            fatalError("Lines is too short with: \(componets.count)")
        }

        let boundCmp = componets[0].components(separatedBy: "-")

        guard let lowerBound = Int(boundCmp.first ?? ""),
              let upperBound = Int(boundCmp.last ?? "")
        else {
            fatalError("Cannot form bound of range: \(boundCmp)")
        }

        let range = lowerBound...upperBound
        let letter = String(componets[1].first ?? " ")

        return Password(rule: range, letter: letter, pwd: componets[2])
    }
}
