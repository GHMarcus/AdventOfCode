//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/3

enum Day_3_2018: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2018
    
    struct Claim {
        let id: String
        let x: Int
        let y: Int
        let width: Int
        let height: Int
        
        var maxX: Int {
            x+width
        }
        
        var maxY: Int {
            y+height
        }
        
        init(id: String, posStr: String, sizeStr: String) {
            self.id = String(id.suffix(from: String.Index(utf16Offset: 1, in: id)))
            
            // pos string: 1,3 -> x = 1, y = 3
            let position = posStr.components(separatedBy: ",")
            x = Int(position[0])!
            y = Int(position[1])!
            
            // size string: 5x4 -> width = 1, height = 3
            let size = sizeStr.components(separatedBy: "x")
            width = Int(String(size[0]))!
            height = Int(String(size[1]))!
        }
    }
    
    static var claims: [Claim] = []
    static var map: [[Character]] = []

    static func solvePart1(input: [String]) -> String {
        claims = input.map { line in
            let components = line.components(separatedBy: " ")
            
            return Claim(id: components[0], posStr: String(components[2].dropLast()), sizeStr: components[3])
        }
        
        map = Array(
            repeating: Array(
                repeating: ".",
                count: claims.map({ $0.maxX }).max()!
            ),
            count: claims.map({ $0.maxY }).max()!
        )
        
        for claim in claims {
            for yOffset in 0..<claim.height {
                for xOffset in 0..<claim.width {
                    let point = map[claim.y+yOffset][claim.x+xOffset]
                    if point == "." {
                        map[claim.y+yOffset][claim.x+xOffset] = "#"
                    } else if point == "#" {
                        map[claim.y+yOffset][claim.x+xOffset] = "X"
                    }
                }
            }
        }
        
        let overlaps = map.reduce(0) { partialResult, line in
            partialResult + String(line).countInstances(of: "X")
        }
        
        return "\(overlaps)"
    }
    
    static func solvePart2(input: [String]) -> String {
        
        var singleClaims: [String] = []
        
    claimsLoop:
        for claim in claims {
            for yOffset in 0..<claim.height {
                for xOffset in 0..<claim.width {
                    let point = map[claim.y+yOffset][claim.x+xOffset]
                    if point == "X" {
                        continue claimsLoop
                    }
                }
            }
            singleClaims.append(claim.id)
        }
        
        
        return "\(singleClaims)"
    }
}
