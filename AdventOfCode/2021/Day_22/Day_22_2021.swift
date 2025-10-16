//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/22

enum Day_22_2021: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2021
    
    struct Cube {
        let on: Bool
        let xMin, xMax, yMin, yMax, zMin, zMax: Int
        
        func isInRange(of range: ClosedRange<Int>) -> Bool {
            range.contains(self.xMin) && range.contains(self.xMax) && range.contains(self.yMin) && range.contains(self.yMax) && range.contains(self.zMin) && range.contains(self.zMax)
        }
    }
    
    static func convert(input: [String]) -> [Cube] {
        var steps: [Cube] = []
        for line in input {
            var cmp = line.components(separatedBy: " ")
            let on = cmp[0] == "on"
            cmp = cmp[1].components(separatedBy: ",").map({ String($0.dropFirst(2)) })
            let x = cmp[0].split(separator: "..").map{Int($0)!}
            let y = cmp[1].split(separator: "..").map{Int($0)!}
            let z = cmp[2].split(separator: "..").map{Int($0)!}
            steps.append(Cube(on: on, xMin: x[0], xMax: x[1], yMin: y[0], yMax: y[1], zMin: z[0], zMax: z[1]))
        }
        return steps
    }
    
    static func solvePart1(input: [Cube]) -> String {
        var onCubes: Set<String> = []
        for cube in input {
            guard cube.isInRange(of: -50...50) else { continue }
            if cube.on {
                for x in cube.xMin...cube.xMax {
                    for y in cube.yMin...cube.yMax {
                        for z in cube.zMin...cube.zMax {
                            onCubes.insert("\(x),\(y),\(z)")
                        }
                    }
                }
            } else {
                for x in cube.xMin...cube.xMax {
                    for y in cube.yMin...cube.yMax {
                        for z in cube.zMin...cube.zMax {
                            onCubes.remove("\(x),\(y),\(z)")
                        }
                    }
                }
            }
        }
       
        return "\(onCubes.count)"
    }

    // With the help of: https://www.reddit.com/r/adventofcode/comments/rlxhmg/comment/hqxczc4/?utm_source=share&utm_medium=web2x&context=3
    static func solvePart2(input: [Cube]) -> String {
        
        var cores: [Cube] = []
        
        for cube in input {
            var toAdd: [Cube] = cube.on ? [cube] : []
            
            for core in cores {
                if let intersection = intersection(cube, core) {
                    toAdd.append(intersection)
                }
            }
            
            cores.append(contentsOf: toAdd)
        }
        
        var onCubes = 0
        
        for cube in cores {
            let volume = (cube.zMax-cube.zMin+1) * (cube.yMax-cube.yMin+1) * (cube.xMax-cube.xMin+1)
            onCubes += (cube.on ? 1 : -1) * volume
        }

        return "\(onCubes)"
    }
    
    static func intersection(_ a: Cube, _ b: Cube) -> Cube? {
        let xMin = max(a.xMin, b.xMin)
        let xMax = min(a.xMax, b.xMax)
        let yMin = max(a.yMin, b.yMin)
        let yMax = min(a.yMax, b.yMax)
        let zMin = max(a.zMin, b.zMin)
        let zMax = min(a.zMax, b.zMax)
        
        if xMin > xMax || yMin > yMax || zMin > zMax {
            return nil
        }
        
        // We must add the opposite of a.on to subtract the intersection if a is on or to add if a is off
        return Cube(on: !b.on, xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, zMin: zMin, zMax: zMax)
    }
}
