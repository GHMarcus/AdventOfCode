//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/9

enum Day_9_2016: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2016
    
    static func solvePart1(input: [String]) -> String {
        var decompressedLength = 0
        
        for line in input {
            let length = decompressPart1(for: line)
            decompressedLength += length
        }
        
        return "\(decompressedLength)"
    }
    
    static func solvePart2(input: [String]) -> String {
        var decompressedLength = 0
        
        for line in input {
            let length = decompressPart2(for: line)
            decompressedLength += length
        }
        
        return "\(decompressedLength)"
    }
    
    static func decompressPart1(for line: String) -> Int {
        if line.contains("(") {
            let firstOpenParenthesisIndex = line.firstIndex(of: "(")!
            let firstClosingParenthesisIndex = line.firstIndex(of: ")")!
            let firstPart = String(line[..<firstOpenParenthesisIndex])
            let insideParenthesis = String(line[line.index(after: firstOpenParenthesisIndex)..<firstClosingParenthesisIndex])
            let secondPart = String(line[line.index(after: firstClosingParenthesisIndex)...])
            
            let (count, length) = mapCompressionRate(insideParenthesis)
            
            
            return firstPart.count + (length * count) + decompressPart1(for: String(secondPart.dropFirst(length)))
        } else {
            return line.replacingOccurrences(of: " ", with: "").count
        }
    }
    
    // With the help of the comment here: https://github.com/rhardih/aoc/blob/master/2016/9p2.c
    static func decompressPart2(for line: String) -> Int {
        var weights = Array(repeating: 1, count: line.count)
        var lengths = 0
        
        var currentMarker = ""
        var markerDetected = false
        for (index, c) in Array(line).enumerated() {
            if c == "(" {
                currentMarker = ""
                markerDetected = true
                continue
            }
            if c == ")" {
                markerDetected = false
                let (count, lengths) = mapCompressionRate(currentMarker)
                for n in 1...lengths {
                    weights[index+n] *= count
                }
                continue
            }
            if markerDetected {
                currentMarker.append(c)
                continue
            }
            lengths += weights[index]
        }
        
        return lengths
    }
    
    static func mapCompressionRate(_ string: String) -> (count: Int, length: Int) {
        let cmp = string.components(separatedBy: "x")//.map { Int($0)! }
        return (Int(cmp[1])!, Int(cmp[0])!)
    }
}
