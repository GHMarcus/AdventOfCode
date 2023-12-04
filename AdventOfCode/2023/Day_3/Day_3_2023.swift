//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/3

enum Day_3_2023: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2023
    
    struct Pos: Hashable {
        let x, y: Int
        
        var neighbours: Set<Pos> {
            [
                Pos(x: x, y: y-1),
                Pos(x: x, y: y+1),
                Pos(x: x-1, y: y),
                Pos(x: x+1, y: y),
                Pos(x: x-1, y: y-1),
                Pos(x: x-1, y: y+1),
                Pos(x: x+1, y: y+1),
                Pos(x: x+1, y: y-1)
            ]
        }
    }
    
    struct Part {
        let value: Int
        let selfPos: Set<Pos>
        
        var neighbours: Set<Pos> {
            var pos: Set<Pos> = []
            
            for p in selfPos {
                pos = pos.union(p.neighbours)
            }
            
            return pos.subtracting(selfPos)
        }
    }
    
    struct Plan {
        var parts: [Part]
        var symbols: Set<Pos>
        var gears: Set<Pos>
        
        func isReal(_ part: Part) -> Bool {
            !symbols.intersection(part.neighbours).isEmpty
        }
    }
    
    static func convert(input: [[Character]]) -> Plan {
        var plan = Plan(parts: [], symbols: [], gears: [])
        
        for (y, line) in input.enumerated() {
            var number = ""
            var numberPos: Set<Pos> = []
            
            let createNumber = {
                let part = Part(value: Int(number)!, selfPos: numberPos)
                plan.parts.append(part)
                number = ""
                numberPos = []
            }
            
            for (x, c) in line.enumerated() {
                if c == "." {
                    if !number.isEmpty {
                        createNumber()
                    }
                    continue
                } else if Int(String(c)) != nil {
                    numberPos.insert(Pos(x: x, y: y))
                    number.append(c)
                } else {
                    if !number.isEmpty {
                        createNumber()
                    }
                    plan.symbols.insert(Pos(x: x, y: y))
                    if c == "*" {
                        plan.gears.insert(Pos(x: x, y: y))
                    }
                }
            }
            if !number.isEmpty {
                createNumber()
            }
        }
        
        return plan
    }

    static func solvePart1(input: Plan) -> String {
        var sum = 0
        for part in input.parts {
            if input.isReal(part) {
                sum += part.value
            }
        }
        return "\(sum)"
    }

    static func solvePart2(input: Plan) -> String {
        var sum = 0
        let realParts = input.parts.filter { input.isReal($0) }
        for gear in input.gears {
            let gearNeighbours = gear.neighbours
            let partNeighbours = realParts.filter {
                !gearNeighbours.intersection($0.selfPos).isEmpty
            }
            
            if partNeighbours.count == 2 {
                sum += partNeighbours.reduce(1) { $0 * $1.value }
            }
        }
        return "\(sum)"
    }
}
