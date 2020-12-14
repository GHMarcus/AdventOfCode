//
//  main.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

import Foundation

let startTime = CFAbsoluteTimeGetCurrent()
Year_2020().day_14.solve()
//Year_2015().day_5.solve()
let diffTime = CFAbsoluteTimeGetCurrent() - startTime
print("Took \(diffTime) seconds")
