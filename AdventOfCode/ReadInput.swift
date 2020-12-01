//
//  ReadInput.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

import Foundation

enum Year: String {
    case Year_2020 = "2020"
}

enum Day: String {
    case Day_1, Day_2, Day_3, Day_4, Day_5, Day_6, Day_7, Day_8, Day_9, Day_10, Day_11, Day_12, Day_13, Day_14, Day_15, Day_16, Day_17, Day_18, Day_19, Day_20, Day_21, Day_22, Day_23, Day_24, Day_25
}

enum Input {
    static func getIntArray(for day: Day, in year: Year) -> [Int] {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(year.rawValue)
            .appendingPathComponent(day.rawValue)
            .appendingPathComponent("\(day.rawValue)_Input")

        guard let stringContent = try? String(contentsOf: url) else {
            fatalError("Could not read content this file here: \(url)")
        }

        let components = stringContent.components(separatedBy: "\n")
        let intContent = components.compactMap({ Int($0) })

        // Minus 1 for the last empty line in a file
        guard (components.count - 1) == intContent.count else {
            fatalError("Converted Input is smaler then original input")
        }

        return intContent
    }
}
