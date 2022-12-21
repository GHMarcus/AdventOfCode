//
//  main.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 01.12.20.
//

import Foundation

let startTime = CFAbsoluteTimeGetCurrent()
Year_2022().day_21.solve()
let diffTime = CFAbsoluteTimeGetCurrent() - startTime
print("Took \(diffTime) seconds")



/// To add a new year:
///  1. Go to `Script.swift`
///  2. Uncomment the hole file (ignore the Xcode warnings)
///  3. Change the value of the `year` property in line `6` to the new year
///  4. Open `Terminal` and navigate to `Script.swift` file
///  5. Make file executable with `chmod +x Script.swift` and run it with `./Script.swift`
///  6. Add the new generated folder to the project. (`Add Files to "AdventOfCode"...`). Be sure you have selected `Copy items if needed` and `Create groups`
///  7. Add the new year as an case in the enum `Year` in the file `ReadInput.swift`
