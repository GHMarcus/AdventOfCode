//#!/usr/bin/env xcrun swift
//
//import Foundation
//
//let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//let year = "2024"
//for day in 1...25 {
//    let templateString =
//"""
////
////  Day_\(day).swift
////  AdventOfCode
////
////  Created by Marcus Gollnick on 04.12.20.
////
//
//// https://adventofcode.com/\(year)/day/\(day)
//
//enum Day_\(day)_\(year): Solvable {
//    static var day: Input.Day = .Day_\(day)
//    static var year: Input.Year = .Year_\(year)
//
//    static func convert(input: [String]) -> [String] {
//        input
//    }
//
//    static func solvePart1(input: [String]) -> String {
//        return "Add some Code here"
//    }
//
//    static func solvePart2(input: [String]) -> String {
//        return "Add some Code here"
//    }
//}
//"""
//    let filePathDay = currentDirectory
//        .appendingPathComponent(year)
//        .appendingPathComponent("Day_\(day)")
//        .appendingPathComponent("Day_\(day)_\(year).swift")
//
//    let filePathInput = currentDirectory
//        .appendingPathComponent(year)
//        .appendingPathComponent("Day_\(day)")
//        .appendingPathComponent("Day_\(day)_\(year)_Input")
//
//
//    try FileManager.default.createDirectory(at: filePathDay.deletingLastPathComponent(),
//                                            withIntermediateDirectories: true)
//
//    if FileManager.default.fileExists(atPath: filePathDay.path) {
//        print("file with \(filePathDay.lastPathComponent) already exists")
//    } else {
//        do {
//            try templateString.write(to: filePathDay, atomically: true, encoding: .utf8)
//            print(filePathDay)
//        } catch _ {
//            print("An error occurred while writing to \(filePathDay)")
//        }
//    }
//
//
//    if FileManager.default.fileExists(atPath: filePathInput.path) {
//        print("file with \(filePathInput.lastPathComponent) already exists")
//    } else {
//        do {
//            try "".write(to: filePathInput, atomically: true, encoding: .utf8)
//            print(filePathInput)
//        } catch _ {
//            print("An error occurred while writing to \(filePathInput)")
//        }
//
//    }
//}
//
//let yearHeader =
//"""
////
////  Year\(year).swift
////  AdventOfCode
////
////  Created by Marcus Gollnick on 01.12.20.
////
//
//struct Year_\(year) {
//
//"""
//
//let yearMiddle =
//"""
//
//    init() {
//
//"""
//
//let yearBottom =
//"""
//    }
//}
//
//"""
//
//var yearFileString = yearHeader
//
//for day in 1...25 {
//    let yearPropertyTemplate = "    let day_\(day): Day_\(day)_\(year).Type\n"
//    yearFileString += yearPropertyTemplate
//}
//
//yearFileString += yearMiddle
//
//for day in 1...25 {
//    let yearInitTemplate = "        day_\(day) = Day_\(day)_\(year).self\n"
//    yearFileString += yearInitTemplate
//}
//
//yearFileString += yearBottom
//
//let filePathYear = currentDirectory
//    .appendingPathComponent(year)
//    .appendingPathComponent("Year\(year).swift")
//
//try FileManager.default.createDirectory(at: filePathYear.deletingLastPathComponent(),
//                                        withIntermediateDirectories: true)
//
//if FileManager.default.fileExists(atPath: filePathYear.path) {
//    print("file with \(filePathYear.lastPathComponent) already exists")
//} else {
//    do {
//        try yearFileString.write(to: filePathYear, atomically: true, encoding: .utf8)
//        print(filePathYear)
//    } catch _ {
//        print("An error occurred while writing to \(filePathYear)")
//    }
//}
