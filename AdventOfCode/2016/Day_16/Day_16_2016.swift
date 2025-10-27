//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/16

enum Day_16_2016: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2016
    
    static func convert(input: [String]) -> String {
        input.first!
    }

    static func solvePart1(input: String) -> String {
        let data = getExtendedData(with: input, to: 272)
        let checkSum = findChecksum(for: data)
        return "\(checkSum)"
    }

    static func solvePart2(input: String) -> String {
        let data = getExtendedData(with: input, to: 35651584)
        let checkSum = findChecksum(for: data)
        return "\(checkSum)"
    }
    
    static func getExtendedData(with data: String, to length: Int) -> String {
        var data = data
        while data.count < length {
            data = modifiedDragonCurve(with: data)
        }
        return String(data.dropLast(data.count-length))
    }
    
    static func modifiedDragonCurve(with data: String) -> String {
        var newData = "0"
        for c in data.reversed() {
            newData.append(c == "1" ? "0" : "1")
        }
        return data + newData
    }
    
    static func findChecksum(for data: String) -> String {
        var checkSum: String = ""
        let data = Array(data)
        var index = 0
        while index < data.count - 1 {
            if data[index] == data[index+1] {
                checkSum.append("1")
            } else {
                checkSum.append("0")
            }
            index += 2
        }
        
        return checkSum.count.isMultiple(of: 2)
        ? findChecksum(for: checkSum)
        : checkSum
    }
}
