//
//  ReadInput.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

import Foundation

enum Input {

    enum Year: String {
        case Year_2015 = "2015"
        case Year_2016 = "2016"
        case Year_2017 = "2017"
        case Year_2018 = "2018"
        case Year_2020 = "2020"
        case Year_2021 = "2021"
        case Year_2022 = "2022"
    }

    enum Day: String {
        case Day_1, Day_2, Day_3, Day_4, Day_5, Day_6, Day_7, Day_8, Day_9, Day_10, Day_11, Day_12, Day_13, Day_14, Day_15, Day_16, Day_17, Day_18, Day_19, Day_20, Day_21, Day_22, Day_23, Day_24, Day_25
    }

    static func getLeaderboard(for year: Year) -> Leaderboard? {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(year.rawValue)
            .appendingPathComponent("Leaderboard_\(year.rawValue)_JSON")

        guard let dataContent = try? Data(contentsOf: url) else {
            print("Could not read content this file here: \(url)")
            return nil
        }

        return try? JSONDecoder().decode(Leaderboard.self, from: dataContent)
    }

    static func getIntArray(for day: Day, in year: Year) -> [Int] {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(year.rawValue)
            .appendingPathComponent(day.rawValue)
            .appendingPathComponent("\(day.rawValue)_\(year.rawValue)_Input")

        guard let stringContent = try? String(contentsOf: url) else {
            print("Could not read content this file here: \(url)")
            return []
        }

        let components = stringContent.components(separatedBy: "\n")
        let intContent = components.compactMap({ Int($0) })

        // Minus 1 for the last empty line in a file
        guard (components.count - 1) == intContent.count else {
            print("Converted Input is smaler then original input")
            return []
        }

        return intContent
    }

    static func getStringArray(for day: Day, in year: Year) -> [String] {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(year.rawValue)
            .appendingPathComponent(day.rawValue)
            .appendingPathComponent("\(day.rawValue)_\(year.rawValue)_Input")

        guard let stringContent = try? String(contentsOf: url) else {
            print("Could not read content this file here: \(url)")
            return []
        }

        // .dropLast() for the last empty line in a file
        return stringContent.components(separatedBy: "\n").dropLast()
    }

    static func getJSONArray(for day: Day, in year: Year) -> [String] {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(year.rawValue)
            .appendingPathComponent(day.rawValue)
            .appendingPathComponent("\(day.rawValue)_\(year.rawValue)_Input")

        guard let stringContent = try? String(contentsOf: url) else {
            print("Could not read content this file here: \(url)")
            return []
        }

        let lines = stringContent.components(separatedBy: "\n")
        var objects: [String] = []
        var currentObject = ""
        for line in lines {
            if line.isEmpty {
                currentObject = "{\"" + currentObject
                    .dropLast(3)
                    .replacingOccurrences(of: ":", with: "\":\"")
                    .replacingOccurrences(of: " ", with: "\",\"")
                    .appending("\"}")
                objects.append(currentObject)
                currentObject = ""
                continue
            }
            if currentObject == "" {
                currentObject = line + "\",\""
            } else {
                currentObject += line + "\",\""
            }
        }

        return objects
    }

    static func getGroupedArray(for day: Day, in year: Year) -> [String] {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(year.rawValue)
            .appendingPathComponent(day.rawValue)
            .appendingPathComponent("\(day.rawValue)_\(year.rawValue)_Input")

        guard let stringContent = try? String(contentsOf: url) else {
            print("Could not read content this file here: \(url)")
            return []
        }

        let lines = stringContent.components(separatedBy: "\n")
        var objects: [String] = []
        var currentObject = ""
        for line in lines {
            if line.isEmpty {
                objects.append(String(currentObject.dropLast()))
                currentObject = ""
                continue
            }
            if currentObject == "" {
                currentObject = line + " "
            } else {
                currentObject += line  + " "
            }
        }

        return objects
    }
}
