//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/16

enum Day_16_2021: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var bits:[String] = []
        let line = Array(input[0]).map{String($0)}

        for c in line {
            var bit = Array(String(Int(c, radix: 16)!, radix: 2)).map{String($0)}
            if bit.count < 4 {
                while bit.count < 4 {
                    bit.insert("0", at: 0)
                }
            }
            bits.append(contentsOf: bit)
        }

        var versionsSum = 0

        while bits.count > 11 {

            // Get Version
            versionsSum += Int(bits.prefix(upTo: 3).joined(), radix: 2)!
            bits = Array(bits.dropFirst(3))

            // Get Type ID
            let id = bits.prefix(upTo: 3).joined()
            bits = Array(bits.dropFirst(3))

            switch id {
            case "100": // 4
                while true {
                    let groupBit = bits.removeFirst()
                    bits = Array(bits.dropFirst(4))
                    if groupBit == "0" {
                        break
                    }
                }
            default:
                if bits.removeFirst() == "1" {
                    bits = Array(bits.dropFirst(11))
                } else {
                    bits = Array(bits.dropFirst(15))
                }
            }
        }

        return "\(versionsSum)"
    }

    static func solvePart2(input: [String]) -> String {
        var bits:[String] = []
        let line = Array(input[0]).map{String($0)}

        for c in line {
            var bit = Array(String(Int(c, radix: 16)!, radix: 2)).map{String($0)}
            if bit.count < 4 {
                while bit.count < 4 {
                    bit.insert("0", at: 0)
                }
            }
            bits.append(contentsOf: bit)
        }

        let result = evaluate(bits)

        return "\(result.0)"
    }

    static  func evaluate(_ bits: [String]) -> (Int, [String]) {
        var bits = bits

        // Remove Version
        bits = Array(bits.dropFirst(3))

        // Get Type ID
        let id = bits.prefix(upTo: 3).joined()
        bits = Array(bits.dropFirst(3))

        switch id {
        case "000": // 0 -> Sum
            let values = extractPackages(in: &bits)
            return (values.reduce(0, +), bits)
        case "001": // 1 -> Product
            let values = extractPackages(in: &bits)
            return (values.reduce(1, *), bits)
        case "010": // 2 -> Minimum
            let values = extractPackages(in: &bits)
            return (values.min()!, bits)
        case "011": // 3 -> Maximum
            let values = extractPackages(in: &bits)
            return (values.max()!, bits)
        case "100": // 4
            var value = ""
            while true {
                let groupBit = bits.removeFirst()
                value += bits.prefix(upTo: 4).joined()
                bits = Array(bits.dropFirst(4))
                if groupBit == "0" {
                    break
                }
            }
            return (Int(value, radix: 2)!, bits)
        case "101": // 5 -> Greater Than
            let values = extractPackages(in: &bits)
            return (values[0] > values[1] ? 1 : 0, bits)
        case "110": // 6 -> Less Than
            let values = extractPackages(in: &bits)
            return (values[0] < values[1] ? 1 : 0, bits)
        case "111": // 7 -> Equal
            let values = extractPackages(in: &bits)
            return (values[0] == values[1] ? 1 : 0, bits)
        default:
            fatalError()
        }
    }

    private static func extractPackages(in bits: inout [String]) -> [Int] {
        var values: [Int] = []

        // Check if length is 11 or 15
        if bits.removeFirst() == "1" {
            let count = Int(bits.prefix(upTo: 11).joined(), radix: 2)!
            bits = Array(bits.dropFirst(11))

            for _ in 0..<count {
                let result = evaluate(bits)
                values.append(result.0)
                bits = result.1
            }
        } else {
            let length = Int(bits.prefix(upTo: 15).joined(), radix: 2)!
            bits = Array(bits.dropFirst(15))

            var subPackages = Array(bits.prefix(upTo: length))
            bits = Array(bits.dropFirst(length))

            while true {
                let result = evaluate(subPackages)
                values.append(result.0)
                subPackages = result.1
                if subPackages.isEmpty {
                    break
                }
            }
        }
        return values
    }
}
