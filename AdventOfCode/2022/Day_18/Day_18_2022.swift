//
//  Day_18.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/18

enum Day_18_2022: Solvable {
    static var day: Input.Day = .Day_18
    static var year: Input.Year = .Year_2022

    class Cube: Equatable, Hashable {
        static func == (lhs: Day_18_2022.Cube, rhs: Day_18_2022.Cube) -> Bool {
            lhs.x ==  rhs.x && lhs.y == rhs.y && rhs.z == lhs.z
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
            hasher.combine(z)
        }

        let x,y,z: Int
        var commonSiteCubes: Set<Cube>

        init(x: Int, y: Int, z: Int, commonSiteCubes: Set<Cube> = []) {
            self.x = x
            self.y = y
            self.z = z
            self.commonSiteCubes = commonSiteCubes
        }

        var freeSites: Int {
            6 - commonSiteCubes.count
        }

        func isConnectedTo(_ other: Cube) {
            switch (x == other.x, y == other.y, z == other.z) {
            case (true, true, false):
                if abs(z - other.z) == 1 {
                    commonSiteCubes.insert(other)
                    other.commonSiteCubes.insert(self)
                }
            case (true, false, true):
                if abs(y - other.y) == 1 {
                    commonSiteCubes.insert(other)
                    other.commonSiteCubes.insert(self)
                }
            case (false, true, true):
                if abs(x - other.x) == 1 {
                    commonSiteCubes.insert(other)
                    other.commonSiteCubes.insert(self)
                }
            default:
                return
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        var cubes: [Cube] = []
        for line in input {
            let coords = line.components(separatedBy: ",").map { Int($0)! }
            cubes.append(Cube(x: coords[0], y: coords[1], z: coords[2]))
        }

        for cube1 in cubes {
            for cube2 in cubes {
                cube1.isConnectedTo(cube2)
            }
        }

        let freeSites = cubes.map { $0.freeSites }.reduce(0, +)

        return "\(freeSites)"
    }



    static func solvePart2(input: [String]) -> String {
        var cubes: Set<Cube> = []
        for line in input {
            let coords = line.components(separatedBy: ",").map { Int($0)! }
            cubes.insert(Cube(x: coords[0], y: coords[1], z: coords[2]))
        }

        let minX = cubes.map { $0.x }.min()!
        let maxX = cubes.map { $0.x }.max()!

        let minY = cubes.map { $0.y }.min()!
        let maxY = cubes.map { $0.y }.max()!

        let minZ = cubes.map { $0.z }.min()!
        let maxZ = cubes.map { $0.z }.max()!

        let allMin = [minX, minY, minZ].min()! - 1
        let allMax = [maxX, maxY, maxZ].max()! + 1

        var waterCubes: Set<Cube> = []
        floodFill(
            start: Cube(x: allMin, y: allMin, z: allMin),
            cubes: cubes,
            water: &waterCubes,
            max: allMax,
            min: allMin
        )

        var allCubes: Set<Cube> = []
        for x in allMin...allMax {
            for y in allMin...allMax {
                for z in allMin...allMax {
                    let cube = Cube(x: x, y: y, z: z)
                    allCubes.insert(cube)
                }
            }
        }

        let airCubes = allCubes.subtracting(waterCubes).subtracting(cubes)

        for cube1 in cubes {
            for cube2 in cubes {
                cube1.isConnectedTo(cube2)
            }
        }

        for cube in cubes {
            for airCube in airCubes {
                cube.isConnectedTo(airCube)
            }
        }

        let freeSites = cubes.map { $0.freeSites }.reduce(0, +)

        return "\(freeSites)"
    }

    static func floodFill(start: Cube, cubes: Set<Cube>, water: inout Set<Cube>, max: Int, min: Int) {
        if cubes.contains(start) || water.contains(start) {
            return
        }

        water.insert(start)

        for new in [(1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1)] {

            let newCube = Cube(
                x: start.x + new.0,
                y: start.y + new.1,
                z: start.z + new.2
            )

            if newCube.x > max || newCube.x < min || newCube.y > max || newCube.y < min || newCube.z > max || newCube.z < min {
                continue
            }

            floodFill(
                start: newCube,
                cubes: cubes,
                water: &water,
                max: max,
                min: min
            )
        }
    }
}
