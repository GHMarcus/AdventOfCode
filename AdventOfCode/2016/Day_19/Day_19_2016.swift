//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/19

// Note: Took 333.9231640100479 seconds

enum Day_19_2016: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2016
    
    static func convert(input: [String]) -> Int {
        Int(input.first!)!
    }

    class Elf: Equatable {
        static func == (lhs: Day_19_2016.Elf, rhs: Day_19_2016.Elf) -> Bool {
            lhs.number == rhs.number
        }
        
        let number: Int
        var leftNeighbor: Elf?
        
        init(number: Int, leftNeighbor: Elf?) {
            self.number = number
            self.leftNeighbor = leftNeighbor
        }
    }
    
    static func solvePart1(input: Int) -> String {
        let start = Elf(number: 1, leftNeighbor: nil)
        var current = start
        
        for i in 1..<input {
            let elf = Elf(number: i+1, leftNeighbor: nil)
            current.leftNeighbor = elf
            current = elf
        }
        
        current.leftNeighbor = start
        
        current = start
        
        while current.leftNeighbor != current {
            current.leftNeighbor = current.leftNeighbor!.leftNeighbor!
            current = current.leftNeighbor!
        }
        
        return "\(current.number)"
    }

    static func solvePart2(input: Int) -> String {
        var elfs: [Int] = []
        
        for i in 0..<input {
            elfs.append(i+1)
        }
        
        var current = 0
        while elfs.count > 1 {
            let robbedIndex = (current + elfs.count/2) % elfs.count
            let _ = elfs.remove(at: robbedIndex)
            if robbedIndex < current {
                current = current % elfs.count
            } else {
                current = (current + 1) % elfs.count
            }
        }
        
        return "\(elfs[0])"
    }
}
