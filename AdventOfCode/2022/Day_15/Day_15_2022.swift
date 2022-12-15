//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/15

enum Day_15_2022: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2022

    static let searchRow = 2000000

    struct Position: Equatable, Hashable, Comparable {
        static func < (lhs: Day_15_2022.Position, rhs: Day_15_2022.Position) -> Bool {
            lhs.x < rhs.x && lhs.y < rhs.y
        }

        var x,y: Int
    }

    class Sensor {
        init(pos: Day_15_2022.Position, beaconDistance: Int) {
            self.pos = pos
            self.beaconDistance = beaconDistance
        }

        var pos: Position
        var beaconDistance: Int

        func getCoveredPoints() -> [Position] {
            let minX = pos.x - beaconDistance
            let maxX = pos.x + beaconDistance
            let minY = pos.y - beaconDistance
            let maxY = pos.y + beaconDistance

            let row = Day_15_2022.searchRow
            guard (minY...maxY).contains(row) else { return [] }

            var points: [Position] = []
            for x in minX...maxX {
                let distance = abs(pos.x-x) + abs(pos.y-row)
                if distance <= beaconDistance {
                    points.append(Position(x: x, y: row))
                }
            }

            return points
        }

        func getCoveredPointsPart2() -> [Position] {
            let minX = pos.x - beaconDistance
            let maxX = pos.x + beaconDistance
            let minY = pos.y - beaconDistance
            let maxY = pos.y + beaconDistance

            let xh = (maxX - minX)/2
            let yh = (maxY - minY)/2

            var points: [Position] = []
            for y in 0...yh {
                for x in 0...xh {
                    points.append(Position(x: x+minX, y: y+minY))
                    points.append(Position(x: x+minX+xh, y: y+minY))
                    points.append(Position(x: x+minX, y: y+minY+yh))
                    points.append(Position(x: x+minX+xh, y: y+minY+yh))
                }
            }

//            let distance = abs(pos.x-x) + abs(pos.y-y)

            points = points.filter {
                (abs(pos.x-$0.x) + abs(pos.y-$0.y)) <= beaconDistance
            }

            return points
        }
    }

    static func solvePart1(input: [String]) -> String {
        var sensors: [Sensor] = []
        var beaconPositons: [Position] = []
        for line in input {
            //Sensor at x=2, y=18: closest beacon is at x=-2, y=15

            let cmp = line.components(separatedBy: " ")
            let sx = Int(String(cmp[2].dropLast().dropFirst(2)))!
            let sy = Int(String(cmp[3].dropLast().dropFirst(2)))!
            let bx = Int(String(cmp[8].dropLast().dropFirst(2)))!
            let by = Int(String(cmp[9].dropFirst(2)))!

            let distance = abs(sx-bx) + abs(sy-by)
            let sensor = Sensor(pos: .init(x: sx, y: sy), beaconDistance: distance)
            sensors.append(sensor)
            beaconPositons.append(Position(x: bx, y: by))
        }

//        for sensor in sensors {
//            print("Sensor: \(sensor.pos.x),\(sensor.pos.y) -> Beacon: \(sensor.beaconDistance)")
//            if sensor.pos.x == 8 && sensor.pos.y == 7 {
//                for point in sensor.getCoveredPoints().sorted() {
//                    print("Point: \(point.x),\(point.y)")
//                }
//            }
//        }

        var uniquePoints: Set<Position> = []

        var count = 0
        for sensor in sensors {
            print(count)
            for point in  sensor.getCoveredPoints() {
//                if !beaconPositons.contains(point) && !sensors.contains(where: { $0.pos == point }) {
                    uniquePoints.insert(point)
//                }
            }
            count += 1
        }

        let pointsInSearchedRow = uniquePoints.filter {
            $0.y == Day_15_2022.searchRow
        }

//        print(pointsInSearchedRow)

        return "\(pointsInSearchedRow.count)"
    }

    static func solvePart2(input: [String]) -> String {

        var fx = 0
        var fy = 0

        let max = 4000000

        var sensors: [Sensor] = []
        var beaconPositons: [Position] = []
        for line in input {
            //Sensor at x=2, y=18: closest beacon is at x=-2, y=15

            let cmp = line.components(separatedBy: " ")
            let sx = Int(String(cmp[2].dropLast().dropFirst(2)))!
            let sy = Int(String(cmp[3].dropLast().dropFirst(2)))!
            let bx = Int(String(cmp[8].dropLast().dropFirst(2)))!
            let by = Int(String(cmp[9].dropFirst(2)))!

            let distance = abs(sx-bx) + abs(sy-by)
            let sensor = Sensor(pos: .init(x: sx, y: sy), beaconDistance: distance)
            sensors.append(sensor)
            beaconPositons.append(Position(x: bx, y: by))
        }



        var uniquePoints: Set<Position> = []

        var count = 0
        for sensor in sensors {
            print(count)
            for point in  sensor.getCoveredPointsPart2() {
//                if !beaconPositons.contains(point) && !sensors.contains(where: { $0.pos == point }) {
                    uniquePoints.insert(point)
//                }
            }
            count += 1
        }

        print("All points found")
        for y in 0...max {
            for x in 0...max {
                if !uniquePoints.contains(Position(x: x, y: y)) {
                    fx = x
                    fy = y
                    break
                }
            }
        }

        print(fx)
        print(fy)


        return "\(4000000*fx + fy)"
    }
}

// 3211120
