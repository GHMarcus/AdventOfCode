//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/4

import Foundation
import CryptoKit

enum Day_4_2015: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        var number = 0
        let secretKey = input[0]
        while true {
            let md5Hex = MD5(string:"\(secretKey)\(number)")
            if md5Hex.dropLast(md5Hex.count - 5) == "00000" {
                print(md5Hex)
                return "\(number)"
            } else {
                number += 1
            }
        }
    }

    static func solvePart2(input: [String]) -> String {
        var number = 0
        let secretKey = input[0]
        while true {
            let md5Hex = MD5(string:"\(secretKey)\(number)")
            if md5Hex.dropLast(md5Hex.count - 6) == "000000" {
                print(md5Hex)
                return "\(number)"
            } else {
                number += 1
            }
        }
    }

    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
