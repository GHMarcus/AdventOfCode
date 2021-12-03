//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/13

import Foundation

enum Day_13_2020: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        let time = Int(input.first ?? "") ?? 0
        let buses = (input.last ?? "")
            .replacingOccurrences(of: "x,", with: "")
            .components(separatedBy: ",")
            .compactMap({Int($0)})

        let times = buses.map { Double(time) / Double($0) }
        let timesRounded = times.map { $0.rounded(.up) }
        let diffs = zip(times, timesRounded).map(-).map({abs($0)})

        var minIndex = 0
        var minValue = 1.0

        for (index, diff) in diffs.enumerated() {
            if diff < minValue {
                minIndex = index
                minValue = diff
            }
        }

        let bus = buses[minIndex]
        let takeTime = Int(timesRounded[minIndex]) * bus

        return "\((takeTime - time) * bus)"
    }

    static func solvePart2(input: [String]) -> String {
        let pairs: [(Int, Int)] = input[1].split(separator: ",")
            .enumerated()
            .compactMap { (index: Int, value: Substring) in
                if let int = Int(value) {
                    var index = -index
                    while index < 0 { index += int }
                    return (index, int)
                } else {
                    return nil
                }
            }
        let a = pairs.map { $0.0 }
        let n = pairs.map { $0.1 }

        return ("\(chineseRemainderTheorem(a, n))")
    }


    static func euclideanAlgorithm(_ m: Int, _ n: Int) -> (Int, Int) {
        if m % n == 0 {
            return (0, 1)
        } else {
            let rs = euclideanAlgorithm(n % m, m)
            let r = rs.1 - rs.0 * (n / m)
            let s = rs.0

            return (r, s)
        }
    }

    static func gcd(_ m: Int, _ n: Int) -> Int {
        let rs = euclideanAlgorithm(m, n)
        return m * rs.0 + n * rs.1
    }

    static func chineseRemainderTheorem(_ a_i: [Int], _ n_i: [Int]) -> Int {

        // Calculate factor N
        let N = n_i.map { $0 }.reduce(1, *)

        // Using euclidean algorithm to calculate r_i, s_i
        let s = n_i.reduce(into: []) { s, n in
            s.append(euclideanAlgorithm(n, N / n).1)
        }

        // Solve for x
        let x = a_i.enumerated().reduce(0) {
            $0 + $1.1 * s[$1.0] * (N / n_i[$1.0])
        }

        // Return minimal solution
        return abs(x % N)
    }
}
