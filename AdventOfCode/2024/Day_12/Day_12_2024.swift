//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/12

enum Day_12_2024: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Character: [Set<Position>]]

    struct Perimeter {
        enum Location: CaseIterable {
            case top
            case bottom
            case left
            case right
        }
        
        let outside: Int
        let pos: Int
        let location: Location
    }
    
    struct Position: Hashable, Equatable {
        let x: Int
        let y: Int
        var perimeters: [Perimeter] = []
        
        var neighbors: Set<Position> {
            [
                Position(x: x - 1, y: y),
                Position(x: x + 1, y: y),
                Position(x: x, y: y - 1),
                Position(x: x, y: y + 1),
            ]
        }
        
        var perimeterCount: Int {
            perimeters.count
        }
        
        static func == (lhs: Position, rhs: Position) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
        
        mutating func calculatePerimeter(in map: [[Character]], with type: Character) {
            var perimeters: [Perimeter] = []
            for neighbor in neighbors {
                if neighbor.x < 0 || neighbor.x >= map[0].count {
                    perimeters.append(Perimeter(outside: neighbor.x, pos: y, location: neighbor.x < x ? .left : .right))
                } else if neighbor.y < 0 || neighbor.y >= map.count {
                    perimeters.append(Perimeter(outside: neighbor.y, pos: x, location: neighbor.y < y ? .top : .bottom))
                } else if map[neighbor.y][neighbor.x] != type {
                    if neighbor.x == x {
                        perimeters.append(Perimeter(outside: neighbor.y, pos: x, location: neighbor.y < y ? .top : .bottom))
                    } else {
                        perimeters.append(Perimeter(outside: neighbor.x, pos: y, location: neighbor.x < x ? .left : .right))
                    }
                }
            }
            self.perimeters = perimeters
        }
    }
    
   
    
    static func convert(input: [String]) -> ConvertedInput {
        let map = input.map { Array($0) }
        
        var regions: [Character: [Set<Position>]] = [:]
        var plots: [Character: Set<Position>] = [:]
        
        for y in 0..<input.count {
            for x in 0..<input[0].count {
                let plot = map[y][x]
                if var existingPlots = plots[plot] {
                    existingPlots.insert(Position(x: x, y: y))
                    plots.updateValue(existingPlots, forKey: plot)
                } else {
                    plots[plot] = [Position(x: x, y: y)]
                }
            }
        }
        
        var sortedPlots = plots.sorted { $0.key < $1.key }
        
        while !sortedPlots.isEmpty {
            let plot = sortedPlots.removeFirst()
            let plotType = plot.key
            var plotPositions = plot.value
            
            while !plotPositions.isEmpty {
                var newRegion: Set<Position> = [plotPositions.removeFirst()]
                while true {
                    var regionNeighbors: Set<Position> = []
                    newRegion.forEach {
                        regionNeighbors.formUnion($0.neighbors)
                    }
                    let newNeighbors = regionNeighbors.intersection(plotPositions)
                    if !newNeighbors.isEmpty {
                        newNeighbors.forEach {
                            plotPositions.remove($0)
                        }
                        newRegion.formUnion(newNeighbors)
                    } else {
                        break
                    }
                }
                if let existingRegion = regions[plotType] {
                    var region = existingRegion
                    region.append(newRegion)
                    regions.updateValue(region, forKey: plotType)
                } else {
                    regions.updateValue([newRegion], forKey: plotType)
                }
            }
        }
        
        for (type, regionsForType) in regions {
            var newRegions: [Set<Position>] = []
            
            for region in regionsForType {
                var newRegion: Set<Position> = []
                for var pos in region {
                    pos.calculatePerimeter(in: map, with: type)
                    newRegion.insert(pos)
                }
                newRegions.append(newRegion)
            }
            
            regions.updateValue(newRegions, forKey: type)
        }
        
        return regions
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let price = input.reduce(into: 0) { partialResult, regions in
            partialResult += regions.value.reduce(into: 0) { perimeterForType, regionForType in
                perimeterForType += regionForType.count * regionForType.reduce(into: 0) {
                    $0 += $1.perimeterCount
                }
            }
        }
        
        return "\(price)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        let price = input.reduce(into: 0) { partialResult, regions in
            partialResult += regions.value.reduce(into: 0) { perimeterForType, regionForType in
                let perimeters = regionForType.flatMap(\.perimeters)
                perimeterForType += regionForType.count * getSideCount(for: perimeters, with: regions.key)
            }
        }
        
        return "\(price)"
    }
    
    static func getSideCount(for perimeters: [Perimeter], with type: Character) -> Int {
        var sideCount = 0
        
        for location in Perimeter.Location.allCases {
            let filteredPerimeters = perimeters
                .filter{ $0.location == location }
                .reduce(into: [:]) {
                    $0.updateValue([$1] + ($0[$1.outside] ?? []), forKey: $1.outside)
                }
            
            for value in filteredPerimeters.values {
                let sortedValues = value.sorted(by: { $0.pos < $1.pos })
                sideCount += 1
                for i in 1..<sortedValues.count {
                    if sortedValues[i].pos == sortedValues[i-1].pos + 1 {
                        continue
                    } else {
                        sideCount += 1
                    }
                }
            }
        }
        
        return sideCount
    }
}
