//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/15

import Foundation

enum Day_15_2021: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        var map: [[Int]] = []
        for line in input {
            map.append(Array(line).compactMap({ Int(String($0))}))
        }
        let dummyMap = DummyMap(map: map)
        let pathfinder = AStarPathfinder()
        pathfinder.dataSource = dummyMap
        
        let fromTileCoord = TileCoord(col: 0, row: 0)
        let toTileCoord = TileCoord(col: map.count-1, row: map[0].count-1)
        
        let shortestPath = pathfinder.shortestPathFromTileCoord(fromTileCoord: fromTileCoord, toTileCoord: toTileCoord)
        
        var totalRiskLevel = 0
        
        for pos in shortestPath {
            if pos == fromTileCoord {
                continue
            }
            totalRiskLevel += map[pos.col][pos.row]
        }
        
        return "\(totalRiskLevel)"
    }

    static func solvePart2(input: [String]) -> String {
        var map: [[Int]] = []
        for line in input {
            map.append(Array(line).compactMap({ Int(String($0))}))
        }
        
        map = extend(map)
        
        let dummyMap = DummyMap(map: map)
        let pathfinder = AStarPathfinder()
        pathfinder.dataSource = dummyMap
        
        let fromTileCoord = TileCoord(col: 0, row: 0)
        let toTileCoord = TileCoord(col: map.count-1, row: map[0].count-1)
        
        let shortestPath = pathfinder.shortestPathFromTileCoord(fromTileCoord: fromTileCoord, toTileCoord: toTileCoord)
        
        var totalRiskLevel = 0
        
        for pos in shortestPath {
            if pos == fromTileCoord {
                continue
            }
            totalRiskLevel += map[pos.col][pos.row]
        }
        
        return "\(totalRiskLevel)"
    }
    
    private static func extend(_ map: [[Int]]) -> [[Int]] {
        var newMap: [[Int]] = []
        for y in 0...4 {
            for row in map {
                var newRow: [Int] = []
                for x in 0...4 {
                    newRow.append(contentsOf: row.map({
                        let newValue = $0 + x + y
                        return newValue > 9 ? newValue-9 : newValue
                    }))
                }
                newMap.append(newRow)
            }
        }
        return newMap
    }
}

class DummyMap: PathfinderDataSource {
    let map: [[Int]]
    
    init(map: [[Int]]) {
        self.map = map
    }
    
    func isValidTileCoord(_ tileCoord: TileCoord) -> Bool {
        return (0..<map.count).contains(tileCoord.col) && (0..<map[0].count).contains(tileCoord.row)
    }
    
    func walkableAdjacentTilesCoordsForTileCoord(tileCoord: TileCoord) -> [TileCoord] {
        let adjacentTiles = [tileCoord.top, tileCoord.left, tileCoord.bottom, tileCoord.right]
        return adjacentTiles.filter { isValidTileCoord($0) }
    }
    
    func costToMoveFromTileCoord(fromTileCoord: TileCoord, toAdjacentTileCoord toTileCoord: TileCoord) -> Int {
        return map[toTileCoord.col][toTileCoord.row]
    }
}


protocol PathfinderDataSource {
    func walkableAdjacentTilesCoordsForTileCoord(tileCoord: TileCoord) -> [TileCoord]
    func costToMoveFromTileCoord(fromTileCoord: TileCoord, toAdjacentTileCoord toTileCoord: TileCoord) -> Int
}

/** A pathfinder based on the A* algorithm to find the shortest path between two locations */
class AStarPathfinder {
    var dataSource: PathfinderDataSource?
    
    func shortestPathFromTileCoord(fromTileCoord: TileCoord, toTileCoord: TileCoord) -> [TileCoord] {
        // 1
        if self.dataSource == nil {
            fatalError("Datasource should be set")
        }
        let dataSource = self.dataSource!
        
        // 2
        var closedSteps = Set<ShortestPathStep>()
        var openSteps = [ShortestPathStep(position: fromTileCoord)]
        
        while !openSteps.isEmpty {
            // 3
            let currentStep = openSteps.remove(at: 0)
            closedSteps.insert(currentStep)
            
            // 4
            if currentStep.position == toTileCoord {
                //            print("PATH FOUND : ")
                var step: ShortestPathStep? = currentStep
                var steps: [TileCoord] = []
                while step != nil {
                    //              print(step!)
                    steps.append(step!.position)
                    step = step!.parent
                }
                return steps.reversed()
            }
            
            // 5
            let adjacentTiles = dataSource.walkableAdjacentTilesCoordsForTileCoord(tileCoord: currentStep.position)
            for tile in adjacentTiles {
                // 6
                let step = ShortestPathStep(position: tile)
                if closedSteps.contains(step) {
                    continue
                }
                let moveCost = dataSource.costToMoveFromTileCoord(fromTileCoord: currentStep.position, toAdjacentTileCoord: step.position)
                
                if let existingIndex = openSteps.firstIndex(of: step) {
                    // 7
                    let step = openSteps[existingIndex]
                    
                    if currentStep.gScore + moveCost < step.gScore {
                        step.setParent(parent: currentStep, withMoveCost: moveCost)
                        
                        openSteps.remove(at:existingIndex)
                        insertStep(step: step, inOpenSteps: &openSteps)
                    }
                    
                } else {
                    // 8
                    step.setParent(parent: currentStep, withMoveCost: moveCost)
                    step.hScore = hScoreFromCoord(fromCoord: step.position, toCoord: toTileCoord)
                    
                    insertStep(step: step, inOpenSteps: &openSteps)
                }
            }
            
        }
        
        fatalError("You have to start anywhere")
    }
    
    private func insertStep(step: ShortestPathStep, inOpenSteps openSteps: inout [ShortestPathStep]) {
        openSteps.append(step)
        openSteps.sort { $0.fScore <= $1.fScore }
    }
    
    func hScoreFromCoord(fromCoord: TileCoord, toCoord: TileCoord) -> Int {
        return abs(toCoord.col - fromCoord.col) + abs(toCoord.row - fromCoord.row)
    }
}

/** A single step on the computed path; used by the A* pathfinding algorithm */
private class ShortestPathStep: Hashable, Equatable {
    let position: TileCoord
    var parent: ShortestPathStep?
    
    var gScore = 0
    var hScore = 0
    var fScore: Int {
        return gScore + hScore
    }
    
    init(position: TileCoord) {
        self.position = position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
    
    func setParent(parent: ShortestPathStep, withMoveCost moveCost: Int) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.parent = parent
        self.gScore = parent.gScore + moveCost
    }
    
    static func ==(lhs: ShortestPathStep, rhs: ShortestPathStep) -> Bool {
        lhs.position == rhs.position
    }
}


struct TileCoord: Equatable, Hashable {
    let col: Int
    let row: Int
    
    /** coordinate 1 cell above self */
    var top: TileCoord {
        return TileCoord(col: col, row: row - 1)
    }
    /** coordinate 1 cell to the left of self */
    var left: TileCoord {
        return TileCoord(col: col - 1, row: row)
    }
    /** coordinate 1 cell to the right of self */
    var right: TileCoord {
        return TileCoord(col: col + 1, row: row)
    }
    /** coordinate 1 cell beneath self */
    var bottom: TileCoord {
        return TileCoord(col: col, row: row + 1)
    }
    
    var description: String {
        return "[col=\(col) row=\(row)]"
    }
    
    static func ==(lhs: TileCoord, rhs: TileCoord) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row
    }
    
    static func -(lhs: TileCoord, rhs: TileCoord) -> TileCoord {
        return TileCoord(col: lhs.col - rhs.col, row: lhs.row - rhs.row)
    }
}
