//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/13

enum Day_13_2017: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2017

    enum Dir {
        case down, up
    }
    
    struct Layer {
        let depth: Int
        let range: Int
    }
    
    class Scanner {
        let x: Int
        var y: Int
        let range: Int
        var dir: Dir = .down
        
        init(x: Int, y: Int, range: Int) {
            self.x = x
            self.y = y
            self.range = range
        }
        
        var isAtTop: Bool {
            y == 0
        }
        
        var description: String {
            "(\(x), \(y))"
        }
        
        func move() {
            
            switch dir {
            case .down:
                if y == range - 1 {
                    y -= 1
                    dir = .up
                } else {
                    y += 1
                }
            case .up:
                if y == 0 {
                    y += 1
                    dir = .down
                } else {
                    y -= 1
                }
            }
        }
        
        func isAtTop(at time: Int) -> Bool {
            let time = time+x
            var pos = 0
            if (time / (range - 1)).isOdd {
                pos = range - 1 - time % (range - 1)
            } else {
                pos = time % (range - 1)
            }
            return pos == 0
        }
    }
    
    static func convert(input: [String]) -> [Layer] {
        input.map {
            let cmp = $0.components(separatedBy: ": ")
            return Layer(depth: Int(cmp[0])!, range: Int(cmp[1])!)
        }
    }
    
    
    static func solvePart1(input: [Layer]) -> String {
        let maxDepth = input.map(\.depth).max()!
        
        var scanners: [Scanner] = []

        for layer in input {
            scanners.append(.init(x: layer.depth, y: 0, range: layer.range))
        }
        
        var packetX = -1
        var severity = 0
        
        for d in 0...maxDepth {
            packetX += 1
            if let scanner = scanners.first(where: { $0.x == packetX }), scanner.isAtTop {
                severity += d * scanner.range
            }
            scanners.forEach{ $0.move() }
        }
        
        return "\(severity)"
    }

    static func solvePart2(input: [Layer]) -> String {
        var scanners: [Scanner] = []

        for layer in input {
            scanners.append(.init(x: layer.depth, y: 0, range: layer.range))
        }
        
        
        var delay = 0
        
        while true {
            let wayIsFree = scanners.allSatisfy {
                return !$0.isAtTop(at: delay)
            }
            
            if wayIsFree {
                break
            } else {
                delay += 1
            }
            
        }

        return "\(delay)"
    }
}
