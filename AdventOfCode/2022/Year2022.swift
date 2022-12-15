//
//  Year2022.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

struct Year_2022 {
    let day_1: Day_1_2022.Type
    let day_2: Day_2_2022.Type
    let day_3: Day_3_2022.Type
    let day_4: Day_4_2022.Type
    let day_5: Day_5_2022.Type
    let day_6: Day_6_2022.Type
    let day_7: Day_7_2022.Type
    let day_8: Day_8_2022.Type
    let day_9: Day_9_2022.Type
    let day_10: Day_10_2022.Type
    let day_11: Day_11_2022.Type
    let day_12: Day_12_2022.Type
    let day_13: Day_13_2022.Type
    let day_14: Day_14_2022.Type
    let day_15: Day_15_2022.Type
    let day_16: Day_16_2022.Type
    let day_17: Day_17_2022.Type
    let day_18: Day_18_2022.Type
    let day_19: Day_19_2022.Type
    let day_20: Day_20_2022.Type
    let day_21: Day_21_2022.Type
    let day_22: Day_22_2022.Type
    let day_23: Day_23_2022.Type
    let day_24: Day_24_2022.Type
    let day_25: Day_25_2022.Type

    init() {
        day_1 = Day_1_2022.self
        day_2 = Day_2_2022.self
        day_3 = Day_3_2022.self
        day_4 = Day_4_2022.self
        day_5 = Day_5_2022.self
        day_6 = Day_6_2022.self
        day_7 = Day_7_2022.self
        day_8 = Day_8_2022.self
        day_9 = Day_9_2022.self
        day_10 = Day_10_2022.self
        day_11 = Day_11_2022.self
        day_12 = Day_12_2022.self
        day_13 = Day_13_2022.self
        day_14 = Day_14_2022.self
        day_15 = Day_15_2022.self
        day_16 = Day_16_2022.self
        day_17 = Day_17_2022.self
        day_18 = Day_18_2022.self
        day_19 = Day_19_2022.self
        day_20 = Day_20_2022.self
        day_21 = Day_21_2022.self
        day_22 = Day_22_2022.self
        day_23 = Day_23_2022.self
        day_24 = Day_24_2022.self
        day_25 = Day_25_2022.self
    }

    static func printLeaderboard() {
        Input.getLeaderboard(for: .Year_2022)?.print()
    }
}
