//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/19

import Foundation

enum Day_19_2021: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2021

    static var scannerPos = [Point(x: 0, y: 0, z: 0)]

    struct Point: Hashable {
        var x: Int
        var y: Int
        var z: Int

        static func - (lhs: Point, rhs: Point) -> Point {
            Point(
                x: lhs.x - rhs.x,
                y: lhs.y - rhs.y,
                z: lhs.z - rhs.z
            )
        }

        static func + (lhs: Point, rhs: Point) -> Point {
            Point(
                x: rhs.x + lhs.x,
                y: rhs.y + lhs.y,
                z: rhs.z + lhs.z
            )
        }
    }

    class Scanner {
        let number: String
        var points: [Point]
        var notCommonBeacons: Int

        init(number: String, points: [Point]) {
            self.number = number
            self.points = points
            notCommonBeacons = 0
        }
    }

    static func solvePart1(input: [String]) -> String {
        var isHeadline = true
        var scanners: [Scanner] = []
        var number = ""
        var points: [Point] = []
        for line in input {
            if isHeadline {
                number = line.components(separatedBy: " ")[2]
                isHeadline = false
            } else if line.isEmpty {
                scanners.append(Scanner(number: number, points: points))
                number = ""
                points = []
                isHeadline = true
            } else {
                let comps = line.components(separatedBy: ",")
                let point = Point(x: Int(comps[0])!, y: Int(comps[1])!, z: Int(comps[2])!)
                points.append(point)
            }
        }

        scanners.append(Scanner(number: number, points: points))

        let s0 = scanners.removeFirst()

        var beacons: Set<Point> = []
        s0.points.forEach {
            beacons.insert($0)
        }

        while !scanners.isEmpty {
            for beacon in beacons {
                let beaconDiffs = Set(beacons.map { $0 - beacon })

            search:
                for scanner in scanners {
                    for rotation in getAllRotationsOfPoints(scanner.points) {
                        for point in rotation {
                            let currentPointDiffs = Set(rotation.map { $0 - point })
                            let commonPoints = beaconDiffs.intersection(currentPointDiffs)

                            if commonPoints.count >= 12 {
                                scanners.removeAll { $0.number == scanner.number }

                                let scannerShift = beacon - point
                                for point in rotation {
                                    beacons.insert(point + scannerShift)
                                }

                                scannerPos.append(scannerShift)

                                break search
                            }
                        }
                    }
                }
            }
        }
        
        return "\(beacons.count)"
    }

    static func solvePart2(input: [String]) -> String {
        var distances: [Int] = []

        for pos1 in scannerPos {
            for pos2 in scannerPos {
                let shift = pos1 - pos2
                let distance = abs(shift.x) + abs(shift.y) + abs(shift.z)
                distances.append(distance)
            }
        }


        return "\(distances.max()!)"
    }


    static func getAllRotationsOfPoints(_ points: [Point]) -> [[Point]] {
        var allPoints: Set<[Point]> = []

        for angle in getAllAngels() {
            var newPoints: [Point] = []
            for point in points {
                newPoints.append(rotate(point: point, pitch: angle[0], roll: angle[1], yaw: angle[2]))
            }
            allPoints.insert(newPoints)
        }

        return allPoints.unique()
    }

    private static func rotate(point: Point, pitch: Int, roll: Int, yaw: Int) -> Point {
        let cosa = Int(cos(Double(yaw) * Double.pi / 180))
        let sina = Int(sin(Double(yaw) * Double.pi / 180))

        let cosb = Int(cos(Double(pitch) * Double.pi / 180))
        let sinb = Int(sin(Double(pitch) * Double.pi / 180))

        let cosc = Int(cos(Double(roll) * Double.pi / 180))
        let sinc = Int(sin(Double(roll) * Double.pi / 180))

        let Axx = cosa*cosb
        let Axy = cosa*sinb*sinc - sina*cosc
        let Axz = cosa*sinb*cosc + sina*sinc

        let Ayx = sina*cosb
        let Ayy = sina*sinb*sinc + cosa*cosc
        let Ayz = sina*sinb*cosc - cosa*sinc

        let Azx = -sinb
        let Azy = cosb*sinc
        let Azz = cosb*cosc

        let newX = Axx * point.x + Axy * point.y + Axz * point.z
        let newY = Ayx * point.x + Ayy * point.y + Ayz * point.z
        let newZ = Azx * point.x + Azy * point.y + Azz * point.z

        return Point(
            x: newX,
            y: newY,
            z: newZ
        )
    }

    private static func getAllAngels() -> [[Int]]{
        var x = 0
        var y = 0
        var z = 0

        var angels: [[Int]] = []

        while true {
            angels.append([x,y,z])
            z += 90
            if z == 360 {
                z = 0
                y += 90
            }
            if y == 360 {
                y = 0
                x += 90
            }
            if x == 360 {
                break
            }
        }

        return angels
    }
}

