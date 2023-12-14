//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/14

enum Day_14_2023: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2023
    
    struct Pos: Hashable {
        let x,y: Int
    }
    
    static func convert(input: [String]) -> (roundRocks: Set<Pos>, cubeRocks: Set<Pos>, maxY: Int, maxX: Int) {
        var roundRocks: Set<Pos> = []
        var cubeRocks: Set<Pos> = []
        
        for (y, line) in input.enumerated() {
            for (x, c) in Array(line).enumerated() {
                if c == "O" {
                    roundRocks.insert(Pos(x: x, y: y))
                } else if c == "#" {
                    cubeRocks.insert(Pos(x: x, y: y))
                }
            }
        }
        
        return (roundRocks, cubeRocks, input.count, input[0].count)
    }
    
    static func solvePart1(input: (roundRocks: Set<Pos>, cubeRocks: Set<Pos>, maxY: Int, maxX: Int)) -> String {
        let rolledRocks = rollNorth(roundRocks: input.roundRocks, cubeRocks: input.cubeRocks)
        
        let sum = rolledRocks.reduce(0) { $0 + (input.maxY - $1.y) }
        
        return "\(sum)"
    }

    static func solvePart2(input: (roundRocks: Set<Pos>, cubeRocks: Set<Pos>, maxY: Int, maxX: Int)) -> String {
        var rolledRocks = input.roundRocks
        
        var uniquePos: Set<Set<Pos>> = []
        var cache: [Int: Set<Pos>] = [:]
        
        var count = -1
        var firstNotUnique = false
        var startOfLoop: Set<Pos>? = nil
        
        var startLoopIndex = 0
        
        
        while true {
            count += 1
            rolledRocks = rollNorth(roundRocks: rolledRocks, cubeRocks: input.cubeRocks)
            rolledRocks = rollWest(roundRocks: rolledRocks, cubeRocks: input.cubeRocks)
            rolledRocks = rollSouth(roundRocks: rolledRocks, cubeRocks: input.cubeRocks, maxY: input.maxY)
            rolledRocks = rollEast(roundRocks: rolledRocks, cubeRocks: input.cubeRocks, maxX: input.maxX)
            
            cache[count] = rolledRocks
            
            if let start = startOfLoop, start == rolledRocks {
                break
            }
            
            if !uniquePos.insert(rolledRocks).inserted, !firstNotUnique {
                startLoopIndex = count
                firstNotUnique = true
                startOfLoop = rolledRocks
            }
        }
        
        let loopCount = cache.count - startLoopIndex - 1
        let offset = startLoopIndex

        let sum = cache[((1000000000-offset-1)%(loopCount))+offset]!.reduce(0) { $0 + (input.maxY - $1.y) }
        
        return "\(sum)"
    }
    
    static func rollNorth(roundRocks: Set<Pos>, cubeRocks: Set<Pos>) -> Set<Pos> {
        var rolledRocks: Set<Pos> = []
        let sortedRoundRocks = roundRocks.sorted { ($0.x, $0.y) < ($1.x, $1.y) }
        for rock in sortedRoundRocks {
            let alreadyRolledRocks = rolledRocks.filter {
                $0.x == rock.x && $0.y < rock.y
            }
            
            let blockingCubeRocks = cubeRocks.filter {
                $0.x == rock.x && $0.y < rock.y
            }
            
            let newY: Int
            
            if let maxRolled = alreadyRolledRocks.max(by: {$0.y < $1.y })?.y,
               let maxCube = blockingCubeRocks.max(by: {$0.y < $1.y })?.y {
                newY = max(maxRolled, maxCube) + 1
            } else if let maxRolled = alreadyRolledRocks.max(by: {$0.y < $1.y })?.y {
                newY = maxRolled + 1
            } else if let maxCube = blockingCubeRocks.max(by: {$0.y < $1.y })?.y {
                newY = maxCube + 1
            } else {
                newY = 0
            }
            
            rolledRocks.insert(Pos(x: rock.x, y: newY))
        }
        
        return rolledRocks
    }
    
    static func rollSouth(roundRocks: Set<Pos>, cubeRocks: Set<Pos>, maxY: Int) -> Set<Pos> {
        var rolledRocks: Set<Pos> = []
        let sortedRoundRocks = roundRocks.sorted { ($0.x, $0.y) > ($1.x, $1.y) }
        for rock in sortedRoundRocks {
            let alreadyRolledRocks = rolledRocks.filter {
                $0.x == rock.x && $0.y > rock.y
            }
            
            let blockingCubeRocks = cubeRocks.filter {
                $0.x == rock.x && $0.y > rock.y
            }
            
            let newY: Int
            
            if let minRolled = alreadyRolledRocks.min(by: {$0.y < $1.y })?.y,
               let minCube = blockingCubeRocks.min(by: {$0.y < $1.y })?.y {
                newY = min(minRolled, minCube) - 1
            } else if let minRolled = alreadyRolledRocks.min(by: {$0.y < $1.y })?.y {
                newY = minRolled - 1
            } else if let maxCube = blockingCubeRocks.min(by: {$0.y < $1.y })?.y {
                newY = maxCube - 1
            } else {
                newY = maxY-1
            }
            
            rolledRocks.insert(Pos(x: rock.x, y: newY))
        }
        
        return rolledRocks
    }
    
    static func rollWest(roundRocks: Set<Pos>, cubeRocks: Set<Pos>) -> Set<Pos> {
        var rolledRocks: Set<Pos> = []
        let sortedRoundRocks = roundRocks.sorted { $0.x < $1.x }
        for rock in sortedRoundRocks {
            let alreadyRolledRocks = rolledRocks.filter {
                $0.y == rock.y && $0.x < rock.x
            }
            
            let blockingCubeRocks = cubeRocks.filter {
                $0.y == rock.y && $0.x < rock.x
            }
            
            let newX: Int
            
            if let maxRolled = alreadyRolledRocks.max(by: {$0.x < $1.x })?.x,
               let maxCube = blockingCubeRocks.max(by: {$0.x < $1.x })?.x {
                newX = max(maxRolled, maxCube) + 1
            } else if let maxRolled = alreadyRolledRocks.max(by: {$0.x < $1.x })?.x {
                newX = maxRolled + 1
            } else if let maxCube = blockingCubeRocks.max(by: {$0.x < $1.x })?.x {
                newX = maxCube + 1
            } else {
                newX = 0
            }
            
            rolledRocks.insert(Pos(x: newX, y: rock.y))
        }
        
        return rolledRocks
    }
    
    static func rollEast(roundRocks: Set<Pos>, cubeRocks: Set<Pos>, maxX: Int) -> Set<Pos> {
        var rolledRocks: Set<Pos> = []
        let sortedRoundRocks = roundRocks.sorted { $0.x > $1.x }
        for rock in sortedRoundRocks {
            let alreadyRolledRocks = rolledRocks.filter {
                $0.y == rock.y && $0.x > rock.x
            }
            
            let blockingCubeRocks = cubeRocks.filter {
                $0.y == rock.y && $0.x > rock.x
            }
            
            let newX: Int
            
            if let minRolled = alreadyRolledRocks.min(by: {$0.x < $1.x })?.x,
               let minCube = blockingCubeRocks.min(by: {$0.x < $1.x })?.x {
                newX = min(minRolled, minCube) - 1
            } else if let minRolled = alreadyRolledRocks.min(by: {$0.x < $1.x })?.x {
                newX = minRolled - 1
            } else if let maxCube = blockingCubeRocks.min(by: {$0.x < $1.x })?.x {
                newX = maxCube - 1
            } else {
                newX = maxX-1
            }
            
            rolledRocks.insert(Pos(x: newX, y: rock.y))
        }
        
        return rolledRocks
    }
}
