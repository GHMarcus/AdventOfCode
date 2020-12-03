//
//  Year2020.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

struct Year_2020 {
    let day_1: Day_1_2020.Type
    let day_2: Day_2_2020.Type
    let day_3: Day_3_2020.Type
    let day_4: Day_4_2020.Type

    init() {
        day_1 = Day_1_2020.self
        day_2 = Day_2_2020.self
        day_3 = Day_3_2020.self
        day_4 = Day_4_2020.self
    }
}
