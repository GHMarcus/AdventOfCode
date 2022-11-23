//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

import Foundation

// https://adventofcode.com/2018/day/4

enum Day_4_2018: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2018
    
    static var formatter = DateFormatter()
    
    struct GuardState {
        let originalLine: String
        let date: Date
        let status: String
        
        init(line: String) {
            originalLine = line
            let components = line.components(separatedBy: " ")
            let dateString = components[0] + " " + components[1]
            date = formatter.date(from: dateString)!
            status = String(originalLine.suffix(from: String.Index(utf16Offset: dateString.count + 1, in: originalLine)))
        }
        
        var minute: Int {
            Int(date.minuteString)!
        }
    }

    static func solvePart1(input: [String]) -> String {
        formatter.dateFormat = "[yyyy-MM-dd HH:mm]"
        var guardStates: [GuardState] = input.map { GuardState(line: $0) }
        guardStates.sort { $0.date < $1.date }
        
        let guardsSleepMinutes = getGuardSleepMinutes(for: guardStates)
        
        var sleepiestGuard = ""
        
        for sleepMinutes in guardsSleepMinutes {
            if let sleepiestGuardMinutes = guardsSleepMinutes[sleepiestGuard]?.count {
                if sleepMinutes.value.count > sleepiestGuardMinutes {
                    sleepiestGuard = sleepMinutes.key
                }
            } else {
                sleepiestGuard = sleepMinutes.key
            }
        }
        
        let sleepyMinute = guardsSleepMinutes[sleepiestGuard]!.countedElements.sorted(by: { $0.value > $1.value }).first!.key
        
        return "\(Int(sleepiestGuard)! * sleepyMinute)"
    }

    static func solvePart2(input: [String]) -> String {
        formatter.dateFormat = "[yyyy-MM-dd HH:mm]"
        var guardStates: [GuardState] = input.map { GuardState(line: $0) }
        guardStates.sort { $0.date < $1.date }
        
        let guardsSleepMinutes = getGuardSleepMinutes(for: guardStates)
        
        var sleepiestGuard: (String, [Int])?
        
        for sleepMinutes in guardsSleepMinutes {
            
            if let foundSleepiestGuard = sleepiestGuard {
                let sleepiestMinutesCount = foundSleepiestGuard.1.countedElements.sorted(by: { $0.value > $1.value }).first!.value
                let currentMinutesCount = sleepMinutes.value.countedElements.sorted(by: { $0.value > $1.value }).first?.value ?? 0
                if currentMinutesCount > sleepiestMinutesCount {
                    sleepiestGuard = (sleepMinutes.key, sleepMinutes.value)
                }
            } else {
                sleepiestGuard = (sleepMinutes.key, sleepMinutes.value)
            }

        }
        
        let sleepyMinute = sleepiestGuard!.1.countedElements.sorted(by: { $0.value > $1.value }).first!.key
        
        return "\(Int(sleepiestGuard!.0)! * sleepyMinute)"
    }
    
    static func getGuardSleepMinutes(for states: [GuardState]) -> [String: [Int]] {
        var guardOnShift = ""
        var minute = -1
        
        var guardsSleepMinutes: [String: [Int]] = [:]
        
        for state in states {
            if state.status.contains("Guard") {
                guardOnShift = String(state.status.components(separatedBy: " ")[1].dropFirst())
                minute = state.minute
                if guardsSleepMinutes[guardOnShift] == nil {
                    guardsSleepMinutes[guardOnShift] = []
                }
            } else if state.status == "falls asleep" {
                minute = state.minute
            } else if state.status == "wakes up" {
                var newSleepMinutes = guardsSleepMinutes[guardOnShift]!
                for sleepMinute in minute..<state.minute {
                    newSleepMinutes.append(sleepMinute)
                }
                guardsSleepMinutes[guardOnShift] = newSleepMinutes
                minute = state.minute
            }
        }
        
        return guardsSleepMinutes
    }
}



private extension Date {
    static let minuteDateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()

    var minuteString: String {
        Date.minuteDateFormatter.string(from: self)
    }
}
