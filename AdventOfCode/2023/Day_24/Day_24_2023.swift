//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/24

struct HailStone {
    static var id = 1
    
    let id: Int
    let x0, y0, z0, vx, vy, vz: Double
    
    func getPoint(for t: Double) -> (x: Double, y: Double, z: Double) {
        let x = x0 + vx * t
        let y = y0 + vy * t
        let z = z0 + vz * t
        
        return (x, y, z)
    }
}

enum Day_24_2023: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2023
    
    static func convert(input: [String]) -> [HailStone] {
        var stones: [HailStone] = []
        
        // 19, 13, 30 @ -2,  1, -2
        for line in input {
            let comp = line.components(separatedBy: " @ ")
            let coords = comp[0].components(separatedBy: ", ").map { Double($0.trimmingCharacters(in: .whitespaces))! }
            let vel = comp[1].components(separatedBy: ", ").map { Double($0.trimmingCharacters(in: .whitespaces))! }
            stones.append(HailStone(id: HailStone.id, x0: coords[0], y0: coords[1], z0: coords[2], vx: vel[0], vy: vel[1], vz: vel[2]))
            HailStone.id += 1
        }
        
        return stones
    }
    
    

    static func solvePart1(input: [HailStone]) -> String {
        
        let intersections = determineCrossingPaths(for: input, min: 200000000000000, max: 400000000000000)
        return "\(intersections)"
    }

    static func solvePart2(input: [HailStone]) -> String {
        return "Add some Code here"
    }
    
    static func determineCrossingPaths(for stones: [HailStone], min: Double, max: Double) -> Int {
        let combinations = Array(0...stones.count-1).uniqueCombinations(ofLength: 2)
        
        var intersections = 0
        
        for combination in combinations {
            let s1 = stones[combination[0]]
            let s2 = stones[combination[1]]
            
            
            let t2 = calculateT2(s1: s1, s2: s2)
            let t1 = calculateT1(s1: s1, s2: s2, t2: t2)
            if t1 < 0 || t2 < 0 {
                // Meet in the past
                continue
            } else if t1.isInfinite || t2.isInfinite {
                // Never meet
                continue
            } else {
                let point = s1.getPoint(for: t1)
                
                if point.x >= min && point.x <= max && point.y >= min && point.y <= max {
                    // Meet inside test area
                    intersections += 1
                } else {
                    // Meet outside test area
                    continue
                }
            }
        }
        
        return intersections
    }
    
    static func calculateT2(s1: HailStone, s2: HailStone) -> Double {
        (s1.y0 - s2.y0 + (((s2.x0 - s1.x0)/s1.vx) * s1.vy)) / (s2.vy - ((s2.vx * s1.vy)/s1.vx))
    }
    static func calculateT1(s1: HailStone, s2: HailStone, t2: Double) -> Double {
        ((s2.x0 - s1.x0)/s1.vx) + ((s2.vx/s1.vx) * t2)
    }
}
