//
//  Solvable.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

import Foundation

protocol Solvable {
    static var day: Input.Day { get }
    static var year: Input.Year { get }
    associatedtype InputType
    static func input() -> InputType

    static func solvePart1(input: InputType) -> String
    static func solvePart2(input: InputType) -> String
}

extension Solvable {
    static func solve() {
        print("********** \(day.rawValue) Year \(year.rawValue) **********")
        print("Solution for Part 1: \(solvePart1(input: input()))")
        print("Solution for Part 2: \(solvePart2(input: input()))")
        print("*************************************")
    }

    static func input() -> [String] {
        Input.getStringArray(for: day, in: year)
    }

    static func input() -> [Int] {
        Input.getIntArray(for: day, in: year)
    }
    
    static func input() -> [Character] {
        Array(Input.getStringArray(for: day, in: year).first ?? "")
    }
}
