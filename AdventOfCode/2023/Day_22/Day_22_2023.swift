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


struct Brick: Equatable {
    static var id = 1

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

    init(xr: ClosedRange<Int>, yr: ClosedRange<Int>, zr: ClosedRange<Int>) {
        self.name = String(Brick.id)
        Brick.id += 1
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

            bricks.append(Brick(xr: start[0]...end[0], yr: start[1]...end[1], zr: start[2]...end[2]))
        }


        let droppedBricks = dropDownAllBricks(bricks).bricks
        print("Bricks dropped")
        print("#########################")

        let disintegratedBricks = disintegrateBricks(droppedBricks)
        print("#########################")

        return "\(disintegratedBricks.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var bricks: [Brick] = []

        for line in input {
            let sides = line.components(separatedBy: "~")
            let start = sides[0].components(separatedBy: ",").map{Int($0)!}
            let end = sides[1].components(separatedBy: ",").map{Int($0)!}
            
            bricks.append(Brick(xr: start[0]...end[0], yr: start[1]...end[1], zr: start[2]...end[2]))
        }
        
        print("#########################")
        let droppedBricks = dropDownAllBricks(bricks).bricks
        print("Bricks dropped")
        print("#########################")
        
        let fallingBricks = countFallingBricksDuringDisintegration(droppedBricks)
        print("#########################")
        
        return "\(fallingBricks)"
    }
    
    static func dropDownAllBricks(_ bricks: [Brick], oneDropOnly: Bool = false) -> (bricks: [Brick], droppedBricks: Int) {
        var restingBricks: [Brick] = []
        var restingCubes: Set<Cube> = []
        var droppedBricks = 0
        var brickCanFall: Bool = false

        for var brick in bricks.sorted(by: { $0.minZ < $1.minZ }) {
            if brick.cubes.contains(where: {$0.z == 1}) {
                restingBricks.append(brick)
                restingCubes = restingCubes.union(brick.cubes)
                continue
            }

            while true {
                let fallenBrick = brick.getFallenBrick()
                let canFall = fallenBrick.cubes.intersection(restingCubes).isEmpty
                if oneDropOnly && canFall {
                    return ([], 1)
                } else if canFall && fallenBrick.minZ > 0 {
                    brick = fallenBrick
                    brickCanFall = true
                } else {
                    restingBricks.append(brick)
                    restingCubes = restingCubes.union(brick.cubes)
                    break
                }
            }
            if brickCanFall {
                droppedBricks += 1
            }
            
            brickCanFall = false
        }

        return (restingBricks, droppedBricks)
    }

    static func disintegrateBricks(_ bricks: [Brick]) -> [Brick] {
        var disintegratableBricks: [Brick] = []
        for (index, brick) in bricks.enumerated() {
            print("Brick \(index+1) / \(bricks.count)")
            var newBricks = bricks
            newBricks.remove(at: index)
            
            if dropDownAllBricks(newBricks, oneDropOnly: true).droppedBricks <= 0 {
                disintegratableBricks.append(brick)
            }
        }

        return disintegratableBricks
    }
    
    static func countFallingBricksDuringDisintegration(_ bricks: [Brick]) -> Int  {
        var fallingBricks = 0
        for (index, _) in bricks.enumerated() {
            print("Brick \(index+1) / \(bricks.count)")
            var newBricks = bricks
            newBricks.remove(at: index)
            
            let droppedBricks = dropDownAllBricks(newBricks).droppedBricks
            fallingBricks += droppedBricks
        }

        return fallingBricks
    }
}
