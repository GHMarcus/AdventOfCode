//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

import Foundation

// https://adventofcode.com/2015/day/8

enum Day_8_2015: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2015
    
    static let allowedCharacters = CharacterSet(charactersIn:"0123456789abcdef")

    static func solvePart1(input: [String]) -> String {
        let numberOfCodeCharacters = input.reduce(0) { partialResult, line in
            partialResult + line.count
        }
        
        var numberOfMemoryCharacters = 0
        
        for var line in input {
            _ = line.removeFirst()
            _ = line.removeLast()
            var numberOfEscapes = line.countInstances(of: "\\\\")
            numberOfEscapes += line.countInstances(of: "\\\"")
            var numberOfASCII = 0
            let components = line.components(separatedBy: "\\x")
            for component in components.dropFirst() {
                if component.count >= 2 && component.prefix(2).trimmingCharacters(in: Day_8_2015.allowedCharacters).isEmpty {
                    numberOfASCII += 1
                }
            }
            
            numberOfMemoryCharacters += line.count - numberOfEscapes - 3 * numberOfASCII
        }
        
        return "\(numberOfCodeCharacters - numberOfMemoryCharacters)"
    }

    static func solvePart2(input: [String]) -> String {
        let numberOfCodeCharacters = input.reduce(0) { partialResult, line in
            partialResult + line.count
        }
        
        var numberOfMemoryCharacters = 0
        
        for var line in input {
            _ = line.removeFirst()
            _ = line.removeLast()
            var numberOfEscapes = line.countInstances(of: "\\\\")
            numberOfEscapes += line.countInstances(of: "\\\"")
            var numberOfASCII = 0
            let components = line.components(separatedBy: "\\x")
            for component in components.dropFirst() {
                if component.count >= 2 && component.prefix(2).trimmingCharacters(in: Day_8_2015.allowedCharacters).isEmpty {
                    numberOfASCII += 1
                }
            }
            
            numberOfMemoryCharacters += line.count + 6 + 2 * numberOfEscapes + numberOfASCII
        }
        
        return "\(numberOfMemoryCharacters - numberOfCodeCharacters)"
    }
}

