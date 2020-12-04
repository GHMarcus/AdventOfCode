//#!/usr/bin/env xcrun swift
//
//import Foundation
//
//let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//let year = "2020"
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
//// https://adventofcode.com/2020/day/\(day)
//
//enum Day_\(day)_2020: Solvable {
//    static var day: Input.Day = .Day_\(day)
//    static var year: Input.Year = .Year_2020
//
//    static func solvePart1(input: [Int]) -> String {
//        "Add some Code here"
//    }
//
//    static func solvePart2(input: [Int]) -> String {
//        "Add some Code here"
//    }
//}
//"""
//    let filePathDay = currentDirectory
//        .appendingPathComponent(year)
//        .appendingPathComponent("Day_\(day)")
//        .appendingPathComponent("Day_\(day)_\(year).swift")
//
//    let filePathInput = currentDirectory
//        .appendingPathComponent("2020")
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
////  Year2020.swift
////  AdventOfCode
////
////  Created by Marcus Gollnick on 01.12.20.
////
//
//struct Year_2020 {
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
//    let yearPropertyTemplate = "    let day_\(day): Day_\(day)_2020.Type\n"
//    yearFileString += yearPropertyTemplate
//}
//
//yearFileString += yearMiddle
//
//for day in 1...25 {
//    let yearInitTemplate = "        day_\(day) = Day_\(day)_2020.self\n"
//    yearFileString += yearInitTemplate
//}
//
//yearFileString += yearBottom
//
//let filePathYear = currentDirectory
//    .appendingPathComponent(year)
//    .appendingPathComponent("Year2020.swift")
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
