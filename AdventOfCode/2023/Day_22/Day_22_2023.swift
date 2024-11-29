//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/22

struct Cube: Hashable {
    let x, y: Int
    var z: Int
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func fall() -> Cube {
        Cube(x: x, y: y, z: z-1)
    }
    
    func revertFall() -> Cube {
        Cube(x: x, y: y, z: z+1)
    }
}


class Brick: Equatable {
    static func == (lhs: Brick, rhs: Brick) -> Bool {
        lhs.cubes == rhs.cubes
    }
    
    let name: String
    var cubes: Set<Cube>
    
    var desc: String {
        "\(name): \(cubes.sorted(by: { ($0.x, $0.y, $0.z) < ($1.x, $1.y, $1.z)}).map{"\($0.x),\($0.y),\($0.z)"}.joined(separator: ", "))"
    }
    
    var minZ: Int {
        cubes.map { $0.z }.min()!
    }
    var maxZ: Int {
        cubes.map { $0.z }.max()!
    }
    
    init(name: String = "", xr: ClosedRange<Int>, yr: ClosedRange<Int>, zr: ClosedRange<Int>) {
        self.name = name
        var cubes: Set<Cube> = []
        for x in xr {
            for y in yr {
                for z in zr {
                    cubes.insert(Cube(x: x, y: y, z: z))
                }
            }
        }
        self.cubes = cubes
    }
    
    init(name: String, cubes: Set<Cube>) {
        self.name = name
        self.cubes = cubes
    }
    
    func getFallenBrick() -> Brick {
        var newCubes: Set<Cube> = []
        cubes.forEach { newCubes.insert($0.fall()) }
        return Brick(name: name, cubes: newCubes)
    }
    
    func fall() {
        var newCubes: Set<Cube> = []
        cubes.forEach { newCubes.insert($0.fall()) }
        cubes = newCubes
    }
    
    func revertFall() {
        var newCubes: Set<Cube> = []
        cubes.forEach { newCubes.insert($0.revertFall()) }
        cubes = newCubes
    }
}

enum Day_22_2023: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2023
    
    static func convert(input: [String]) -> [String] {
        input
    }

    static func solvePart1(input: [String]) -> String {
        var bricks: [Brick] = []
        
        for line in input {
            let sides = line.components(separatedBy: "~")
            let start = sides[0].components(separatedBy: ",").map{Int($0)!}
            let end = sides[1].components(separatedBy: ",").map{Int($0)!}
            
//            bricks.append(Brick(name: sides[2], xr: start[0]...end[0], yr: start[1]...end[1], zr: start[2]...end[2]))
            bricks.append(Brick(xr: start[0]...end[0], yr: start[1]...end[1], zr: start[2]...end[2]))
        }
        
        
//        bricks.forEach {
//            print($0.desc)
//        }
        
        print("#########################")
        let droppedBricks = dropDownAllBricks(bricks)
//        droppedBricks.forEach {
//            print($0.desc)
//        }
        print("Bricks dropped")
        print("#########################")
        
        let disintegratedBricks = disintegrateBricks(droppedBricks)
//        disintegratedBricks.forEach {
//            print($0.desc)
//        }
        print("#########################")
        
        return "\(disintegratedBricks.count)"
    }

    static func solvePart2(input: [String]) -> String {
        return "Add some Code here"
    }
    
    static func dropDownAllBricks(_ bricks: [Brick], oneDropOnly: Bool = false) -> [Brick] {
        var restingBricks: [Brick] = []
        var restingCubes: Set<Cube> = []
        
        for brick in bricks.sorted(by: { $0.minZ < $1.minZ }) {
            if brick.cubes.contains(where: {$0.z == 1}) {
                restingBricks.append(brick)
                restingCubes = restingCubes.union(brick.cubes)
                continue
            }
            
            while true {
                let fallenBrick = brick.getFallenBrick()
                let canFall = fallenBrick.cubes.intersection(restingCubes).isEmpty
                if canFall && oneDropOnly {
                    return []
                } else if canFall && fallenBrick.minZ > 0 {
                    brick.fall()
                } else {
                    restingBricks.append(brick)
                    restingCubes = restingCubes.union(brick.cubes)
                    break
                }
            }
    
        }
        
        return restingBricks
    }
    
    static func disintegrateBricks(_ bricks: [Brick]) -> [Brick] {
        var disintegratableBricks: [Brick] = []
        
        for (index, brick) in bricks.enumerated() {
//            print("Brick \(index+1) / \(bricks.count)")
            var newBricks = bricks
            newBricks.remove(at: index)
            
            if !dropDownAllBricks(newBricks, oneDropOnly: true).isEmpty {
                disintegratableBricks.append(brick)
            }
        }
        
        return disintegratableBricks
    }
}


// to high: 587
