//
//  Day_4_2020.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 03.12.20.
//

// https://adventofcode.com/2020/day/4

import Foundation

enum Day_4_2020: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2020

    struct ValidPassport: Decodable {
        let byr: String
        let iyr: String
        let eyr: String
        let hgt: String
        let hcl: String
        let ecl: String
        let pid: String
        let cid: String?
    }

    struct ValidPresentPassport: Decodable {
        let byr: Int
        let iyr: Int
        let eyr: Int
        let hgt: String
        let hcl: String
        let ecl: EyeColor
        let pid: String
        let cid: String?

        static let allowedCharacters = CharacterSet(charactersIn:"#abcdef0123456789").inverted

        enum EyeColor: String, Decodable {
            case amb, blu, brn, gry, grn, hzl, oth
        }

        enum PresentError: Error {
            case presentError(String)
        }

        private enum CodingKeys: CodingKey {
            case byr, iyr, eyr, hgt, hcl, ecl, pid, cid
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let byrValue = Int(try container.decode(String.self, forKey: .byr))
            if let presentByr = byrValue, presentByr >= 1920, presentByr <= 2002 {
                byr = presentByr
            } else {
                throw PresentError.presentError("byr")
            }

            let iyrValue = Int(try container.decode(String.self, forKey: .iyr))
            if let presentIyr = iyrValue, presentIyr >= 2010, presentIyr <= 2020 {
                iyr = presentIyr
            } else {
                throw PresentError.presentError("iyr")
            }

            let eyrValue = Int(try container.decode(String.self, forKey: .eyr))
            if let presentEyr = eyrValue, presentEyr >= 2020, presentEyr <= 2030 {
                eyr = presentEyr
            } else {
                throw PresentError.presentError("eyr")
            }

            let hgtValue = try container.decode(String.self, forKey: .hgt)
            if hgtValue.contains("cm"), let hgtInt = Int(hgtValue.dropLast(2)), hgtInt >= 150, hgtInt <= 193 {
                hgt = hgtValue
            } else if hgtValue.contains("in"), let hgtInt = Int(hgtValue.dropLast(2)), hgtInt >= 59, hgtInt <= 76 {
                hgt = hgtValue
            } else {
                throw PresentError.presentError("hgt")
            }

            let hclValue = try container.decode(String.self, forKey: .hcl)
            let filtered = hclValue.trimmingCharacters(in: Day_4_2020.ValidPresentPassport.allowedCharacters)
            if hclValue.first == "#", hclValue.count == 7, hclValue == filtered {
                hcl = hclValue
            } else {
                throw PresentError.presentError("hcl")
            }

            ecl = try container.decode(EyeColor.self, forKey: .ecl)

            let pidValue = try container.decode(String.self, forKey: .pid)
            if pidValue.count == 9, let _ = Int(pidValue) {
                pid = pidValue
            } else {
                throw PresentError.presentError("pid")
            }

            cid = try container.decodeIfPresent(String.self, forKey: .cid)
        }
    }

    static func input() -> [String] {
        Input.getJSONArray(for: day, in: year)
    }

    static func solvePart1(input: [String]) -> String {
        let decoder = JSONDecoder()
        var passports: [ValidPassport] = []

        for obj in input {
            if let passport = try? decoder.decode(ValidPassport.self, from: obj.data(using: .utf8) ?? Data()) {
                passports.append(passport)
            }
        }

        return "\(passports.count)"
    }

    static func solvePart2(input: [String]) -> String {
        let decoder = JSONDecoder()
        var passports: [ValidPresentPassport] = []

        for obj in input {
            if let passport = try? decoder.decode(ValidPresentPassport.self, from: obj.data(using: .utf8) ?? Data()) {
                passports.append(passport)
            }
        }

        return "\(passports.count)"
    }
}
