//
//  Day_5_2020.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/5

enum Day_5_2020: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2020
    static var seatsIds: [Int] = []

    static func solvePart1(input: [String]) -> String {
        let binaryInput = convertStringToBinary(input: input)
        let seats = convertBinaryToSeat(input: binaryInput)

        seatsIds = seats.map { seat -> Int in
            seat.r * 8 + seat.c
        }
        return "\(seatsIds.max() ?? 0)"
    }

    static func solvePart2(input: [String]) -> String {
        let diffSeats = seatsIds.sorted()
        var mySeat = 0

        for pos in 0..<diffSeats.count {
            if pos + 1 >= diffSeats.count {
                break
            }
            if diffSeats[pos + 1] - diffSeats[pos] == 2 {
                mySeat = diffSeats[pos] + 1
                break
            }
        }

        return "\(mySeat)"
    }

    private static func convertStringToBinary(input: [String]) -> [String] {
        input.map {
            $0.replacingOccurrences(of: "F", with: "0")
                .replacingOccurrences(of: "B", with: "1")
                .replacingOccurrences(of: "R", with: "1")
                .replacingOccurrences(of: "L", with: "0")
        }
    }

    private static func convertBinaryToSeat(input: [String]) -> [(r: Int, c: Int)] {
        var seats: [(r: Int, c: Int)] = []
        for line in input {
            guard let row = Int(line.dropLast(3), radix: 2),
                  let column = Int (line.dropFirst(7), radix: 2)
            else { continue }

            seats.append((r: row, c: column))
        }
        return seats
    }
}

