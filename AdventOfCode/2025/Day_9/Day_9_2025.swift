//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2025/day/9

// Took 135.527498960495 seconds

enum Day_9_2025: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2025
    typealias ConvertedInput = [Pos]

    struct Pos: Hashable {
        let x,y: Int

        var desc: String {
            "(\(x), \(y))"
        }
    }

    struct Rect {
        let x1: Int
        let y1: Int
        let x2: Int
        let y2: Int

        var area: Int {
            (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        var pos: [Pos] = []
        for line in input {
            let cmp = line.components(separatedBy: ",")
            pos.append(Pos(x: Int(cmp[0])!, y: Int(cmp[1])!))
        }
        return pos
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let cornerPairs = input.uniqueCombinations(ofLength: 2)
        var max = 0
        for corners in cornerPairs {
            let first = corners.first!
            let second = corners.last!
            // we need the plus 1 so that the actual corner points are included in the area
            let area = (abs(first.x - second.x) + 1) * (abs(first.y - second.y) + 1)
            if area > max {
                max = area
            }
        }
        return "\(max)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        guard let best = largestRectangle(in: input) else {
            fatalError("Could not find best rectangle")
        }

        return "\(best.area)"
    }

    // MARK: - Scanline Intervalle (konkav + mehrere Intervalle pro Linie)

    static func polygonScanlineIntervals(polygon: [Pos]) -> [Int: [(Int, Int)]] {
        let n = polygon.count
        let minY = polygon.map(\.y).min()!
        let maxY = polygon.map(\.y).max()!

        var result: [Int: [(Int, Int)]] = [:]

        for y in minY..<maxY { // Diskrete Zellen, Scanline in Zellmitte
            let scanY = Double(y) + 0.5
            var xs: [Double] = []

            for i in 0..<n {
                let a = polygon[i]
                let b = polygon[(i + 1) % n]

                let y1 = Double(a.y)
                let y2 = Double(b.y)

                if scanY >= min(y1, y2) && scanY < max(y1, y2) {
                    let t = (scanY - y1) / (y2 - y1)
                    let x = Double(a.x) + t * Double(b.x - a.x)
                    xs.append(x)
                }
            }

            xs.sort()
            guard xs.count >= 2 else { continue }

            var intervals: [(Int, Int)] = []
            for i in stride(from: 0, to: xs.count - 1, by: 2) {
                let x1 = Int(xs[i].rounded(.up))
                let x2 = Int(xs[i + 1].rounded(.down))
                if x1 <= x2 {
                    intervals.append((x1, x2))
                }
            }

            if !intervals.isEmpty {
                result[y] = intervals
            }
        }

        return result
    }

    // MARK: - Rechteck liegt vollständig im Polygon

    static func rectangleInsidePolygon(rect: Rect, intervals: [Int: [(Int, Int)]]) -> Bool {
        for y in rect.y1..<rect.y2 {
            guard let row = intervals[y] else { return false }
            var covered = false
            for (ix1, ix2) in row {
                if rect.x1 >= ix1 && rect.x2 <= ix2 {
                    covered = true
                    break
                }
            }
            if !covered { return false }
        }
        return true
    }

    static func largestRectangle(in polygon: [Pos]) -> Rect? {
        let intervals = polygonScanlineIntervals(polygon: polygon)
        var best: Rect? = nil

        for pair in polygon.uniqueCombinations(ofLength: 2) {
            let p1 = pair.first!
            let p2 = pair.last!

            // Diagonale muss unterschiedlich in x und y
            if p1.x == p2.x || p1.y == p2.y { continue }

            let rect = Rect(
                x1: min(p1.x, p2.x),
                y1: min(p1.y, p2.y),
                x2: max(p1.x, p2.x),
                y2: max(p1.y, p2.y)
            )

            if let best = best, rect.area <= best.area { continue }
            if !rectangleInsidePolygon(rect: rect, intervals: intervals) { continue }

            best = rect
        }

        return best
    }
}
