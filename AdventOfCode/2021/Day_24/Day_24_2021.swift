//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/24

enum Day_24_2021: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2021
    
    // Note: Solution with the help of https://www.reddit.com/r/adventofcode/comments/rnejv5/comment/hpuva2w/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    
    static func convert(input: [String]) -> [(a: Int, b: Int, c: Int)] {
        var programParts: [[String]] = []
        var part: [String] = []
        for line in input {
            if line.contains("inp") {
                programParts.append(part)
                part = []
            }
            part.append(line)
        }
        
        programParts.append(part)
        programParts = Array(programParts.dropFirst())
        
        var values: [(a: Int, b: Int, c: Int)] = []
        
        for part in programParts {
            values.append((
                Int(part[5].components(separatedBy: " ").last!)!,
                Int(part[4].components(separatedBy: " ").last!)!,
                Int(part[15].components(separatedBy: " ").last!)!
            ))
        }
        
        return values
    }

    static func solvePart1(input: [(a: Int, b: Int, c: Int)]) -> String {
        var maxZ: [Int] = []
        let valuesCount = input.count
        for i in 0..<valuesCount {
            let subArray = Array(input[i..<valuesCount]).map { $0.b }
            
            maxZ.append(subArray.reduce(1, {$0 * $1}))
        }
        
        var solutions: [String] = []
        
        search(depth: 0, z: 0, values: input, maxZ: maxZ, currentSolution: "", solutions: &solutions)

        return "\(solutions.last!)"
    }
    
    static func solvePart2(input: [(a: Int, b: Int, c: Int)]) -> String {
        var maxZ: [Int] = []
        let valuesCount = input.count
        for i in 0..<valuesCount {
            let subArray = Array(input[i..<valuesCount]).map { $0.b }
            
            maxZ.append(subArray.reduce(1, {$0 * $1}))
        }
        
        var solutions: [String] = []
        
        search(depth: 0, z: 0, values: input, maxZ: maxZ, currentSolution: "", solutions: &solutions)
        return "\(solutions.first!)"
    }
    
    static func stage(values: (a: Int, b: Int, c: Int), w: Int, z: Int) -> Int {
        if (z % 26 + values.a == w) {
            return z / values.b;
        } else {
            return 26 * (z / values.b) + w + values.c;
        }
    }
    
    static func search(depth: Int, z: Int, values: [(a: Int, b: Int, c: Int)], maxZ: [Int], currentSolution: String, solutions: inout [String]) {
        if depth == 14 {
            if z == 0 {
                solutions.append(currentSolution)
            }
            return
        } else if z >= maxZ[depth] {
            return
        }
                    
        
        for i in 1...9 {
            search(
                depth: depth+1,
                z: stage(values: values[depth], w: i, z: z),
                values: values,
                maxZ: maxZ,
                currentSolution: currentSolution+"\(i)",
                solutions: &solutions
            )
        }
    }
}
