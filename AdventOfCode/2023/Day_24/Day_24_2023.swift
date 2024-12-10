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
        let rockPos = rockPos(h0: input[0], h1: input[1], h2: input[2])
        
        return "\(Int(rockPos.reduce(0, +)))"
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
    
    // Given equations:
    // x(t) = x0 + vx * t
    // y(t) = y0 + vy * t
    // Now when you have two stones that must have the same position on different times you can say
    // x01 + vx1 * t1 = x02 + vx2 * t2
    // y01 + vy1 * t1 = y02 + vy2 * t2
    // The two unknown here are t1 and t2, for soling it you have the given two equations (`calculateT1` and `calculateT2`)
    // After find t1 and t2 its simple logic:
    // - If both are positive: The meet in the future (which we want to know)
    // - If one of them is negative they had meet in the past
    // - If there is no solution (inf) they never meet

    static func calculateT2(s1: HailStone, s2: HailStone) -> Double {
        (s1.y0 - s2.y0 + (((s2.x0 - s1.x0)/s1.vx) * s1.vy)) / (s2.vy - ((s2.vx * s1.vy)/s1.vx))
    }
    static func calculateT1(s1: HailStone, s2: HailStone, t2: Double) -> Double {
        ((s2.x0 - s1.x0)/s1.vx) + ((s2.vx/s1.vx) * t2)
    }
    
    // According to this post on reddit https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/kxqjg33/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    // we need only 3 hail stones and we have to get the time of the collision off two of them with rock, related to the third hailstone.
    // With: Stones 1 and 2, relative to stone 0:
    //    p1 = position_1 - position_0
    //    v1 = velocity_1 - velocity_0
    //    p2 = position_2 - position_0
    //    v2 = velocity_2 - velocity_0
    // And: Viewed from hailstone 0, the two collisions are at
    //    p1 + t1 * v1
    //    p2 + t2 * v2
    // After some mathematical magic (explained in the post) we get something like this:
    //    t1 = -((p1 x p2) * v2) / ((v1 x p2) * v2)
    //    t2 = -((p1 x p2) * v1) / ((p1 x v2) * v1)
    // If we have the two times we can calculate the two collision points:
    //    c1 = position_1 + t1 * velocity_1
    //    c2 = position_2 + t2 * velocity_2
    // And then the velocity and position of the rock
    //    v = (c2 - c1) / (t2 - t1)
    //    p = c1 - t1 * v
    // this all in code looks like:
    static func rockPos(h0: HailStone, h1: HailStone, h2: HailStone) -> [Double] {
        let p1 = subtract(a: [h1.x0, h1.y0, h1.z0], b: [h0.x0, h0.y0, h0.z0])
        let p2 = subtract(a: [h2.x0, h2.y0, h2.z0], b: [h0.x0, h0.y0, h0.z0])
        
        let v1 = subtract(a: [h1.vx, h1.vy, h1.vz], b: [h0.vx, h0.vy, h0.vz])
        let v2 = subtract(a: [h2.vx, h2.vy, h2.vz], b: [h0.vx, h0.vy, h0.vz])
        
        let t1 = t1(p1: p1, v1: v1, p2: p2, v2: v2)
        let t2 = t2(p1: p1, v1: v1, p2: p2, v2: v2)
        
        let c1 = add(a: [h1.x0, h1.y0, h1.z0], b: multiply(a: [h1.vx, h1.vy, h1.vz], b: t1))
        let c2 = add(a: [h2.x0, h2.y0, h2.z0], b: multiply(a: [h2.vx, h2.vy, h2.vz], b: t2))
        
        let v = divide(a: subtract(a: c2, b: c1), b: t2-t1)
        return subtract(a: c1, b: multiply(a: v, b: t1))
    }
    
    static func t1(p1: [Double], v1: [Double], p2: [Double], v2: [Double]) -> Double {
        -1*scalarProduct(a: crossProdukt(a: p1, b: p2), b: v2) / scalarProduct(a: crossProdukt(a: v1, b: p2), b: v2)
    }
    
    static func t2(p1: [Double], v1: [Double], p2: [Double], v2: [Double]) -> Double {
        -1*scalarProduct(a: crossProdukt(a: p1, b: p2), b: v1) / scalarProduct(a: crossProdukt(a: p1, b: v2), b: v1)
    }
}
