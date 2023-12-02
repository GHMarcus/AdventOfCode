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
    associatedtype MainStruct
    static func input() -> InputType
    static func convert(input: InputType) -> MainStruct
    
    static func solvePart1(input: MainStruct) -> String
    static func solvePart2(input: MainStruct) -> String
}

extension Solvable {
    static func solve() {
        print("********** \(day.rawValue) Year \(year.rawValue) **********")
        print("Solution for Part 1: \(solvePart1(input: convert(input: input())))")
        print("Solution for Part 2: \(solvePart2(input: convert(input: input())))")
        print("*************************************")
    }

    static func input() -> [String] {
        Input.getStringArray(for: day, in: year)
    }
    
    static func input() -> [[Character]] {
        Input.getStringCharactersArray(for: day, in: year)
    }

    static func input() -> [Int] {
        Input.getIntArray(for: day, in: year)
    }
    
    static func input() -> [Character] {
        Array(Input.getStringArray(for: day, in: year).first ?? "")
    }
    
    static func convert(input: [String]) -> [String] {
        input
    }
    
    static func convert(input: [Int]) -> [Int] {
        input
    }
    
    static func convert(input: [Character]) -> [Character] {
        input
    }
    
    static func convert(input: [[Character]]) -> [[Character]] {
        input
    }
}
