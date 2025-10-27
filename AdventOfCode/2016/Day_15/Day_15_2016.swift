//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/15

enum Day_15_2016: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2016
    
    struct Disk {
        var n: Int
        var pos: Int
        var initialPos: Int
        
        func pos(at time: Int) -> Int {
            let newPos = initialPos + (time + n) % pos
            return newPos >= pos ? newPos - pos : newPos
        }
    }
    
    static func convert(input: [String]) -> [Disk] {
        var disks = [Disk]()
        for line in input {
            let cmp = line.components(separatedBy: " ")
            disks.append(Disk(n: Int(cmp[1].dropFirst())!, pos: Int(cmp[3])!, initialPos: Int(cmp.last!.dropLast())!))
        }
        return disks
    }

    static func solvePart1(input: [Disk]) -> String {
        var time = 0
        
        while true {
            if input.allSatisfy({ $0.pos(at: time) == 0 }) {
                break
            } else {
                time += 1
            }
        }

        return "\(time)"
    }

    static func solvePart2(input: [Disk]) -> String {
        var time = 0
        var disks = input
        disks.append(Disk(n: input.count+1, pos: 11, initialPos: 0))
        
        while true {
            if disks.allSatisfy({ $0.pos(at: time) == 0 }) {
                break
            } else {
                time += 1
            }
        }

        return "\(time)"
    }
}
