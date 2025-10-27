//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/14

// Note: Took 633.4742189645767 seconds

import Foundation
import CryptoKit

enum Day_14_2016: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2016
    
    static func convert(input: [String]) -> String {
        input.first!
    }

    static func solvePart1(input: String) -> String {
        var preGeneratedKeys: [String] = []
        
        for index in 0..<1000 {
            preGeneratedKeys.append(MD5(string: input + String(index)))
        }
        
        var foundKeys: [String] = []
        var index = 0
        
        while foundKeys.count < 64 {
            let key = preGeneratedKeys.removeFirst()
            preGeneratedKeys.append(MD5(string: input + String(index+1000)))
            
            if let triple = findTriple(in: key) {
                let quintuple = (triple + triple).dropLast()
                
                if preGeneratedKeys.contains(where: { $0.contains(quintuple) }) {
                    foundKeys.append(key)
                }
            }
            index += 1
        }
        
        return "\(index-1)"
    }

    static func solvePart2(input: String) -> String {
        var preGeneratedKeys: [String] = []
        
        for index in 0..<1000 {
            preGeneratedKeys.append(stretchedMD5(string: input + String(index)))
        }
        
        var foundKeys: [String] = []
        var index = 0
        
        while foundKeys.count < 64 {
            let key = preGeneratedKeys.removeFirst()
            preGeneratedKeys.append(stretchedMD5(string: input + String(index+1000)))
            
            if let triple = findTriple(in: key) {
                let quintuple = (triple + triple).dropLast()
                
                if preGeneratedKeys.contains(where: { $0.contains(quintuple) }) {
                    foundKeys.append(key)
                }
            }
            index += 1
        }
        
        return "\(index-1)"
    }
    
    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    static func stretchedMD5(string: String) -> String {
        var current = string
        for _ in 0...2016 {
            current = MD5(string: current)
        }
        return current
    }
    
    static func stretchedMD52(string: String, depth: Int) -> String {
        if depth == 2016 {
            return string
        } else {
            return stretchedMD52(string: MD5(string: string), depth: depth+1)
        }
    }
    
    static func findTriple(in text: String) -> String? {
        // Regex: (.)\1\1  -> Ein beliebiges Zeichen, das zweimal wiederholt wird
        if let match = text.firstMatch(of: /(.)\1\1/) {
            return String(match.0) // match.0 ist der gesamte gefundene Teil (z. B. "eee")
        }
        return nil
    }
}
