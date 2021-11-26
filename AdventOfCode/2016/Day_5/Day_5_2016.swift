//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/5

import Foundation
import CryptoKit

// Takes very long one part >> 500 sec
enum Day_5_2016: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2016

    static func solvePart1(input: [String]) -> String {
        var number = 0
        let doorId = input[0]
        var code = ""
        while code.count < 8 {
            let md5Hex = MD5(string:"\(doorId)\(number)")
            if md5Hex.dropLast(md5Hex.count - 5) == "00000" {
                print(md5Hex)
                code.append(md5Hex.dropLast(md5Hex.count - 6).last ?? "?")
            }
            number += 1
        }
        return code
    }

    static func solvePart2(input: [String]) -> String {
        var number = 0
        let doorId = input[0]
        var code: [Int: Character] = [:]
        while code.count < 8 {
            let md5Hex = MD5(string:"\(doorId)\(number)")
            if md5Hex.dropLast(md5Hex.count - 5) == "00000" {
                if let pos = Int(String(md5Hex.dropLast(md5Hex.count - 6).last!)),
                   pos >= 0,
                   pos < 8,
                   code[pos] == nil {
                    print(md5Hex)
                    code[pos] = md5Hex.dropLast(md5Hex.count - 7).last ?? "?"
                }
            }
            number += 1
        }
        return String(code
            .sorted { $0.key < $1.key }
            .map { $0.value })
            
    }
    
    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
