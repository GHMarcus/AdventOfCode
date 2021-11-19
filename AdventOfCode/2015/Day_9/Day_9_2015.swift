//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

import Foundation

// https://adventofcode.com/2015/day/9

enum Day_9_2015: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2015
    
    static var distances: [Int?] = []

    class Location {
        let name: String
    
        init(name: String) {
            self.name = name
        }
    }
    
    struct Route: Hashable {
        let from: String
        let to: String
        let distance: Int
    }
    
    static func solvePart1(input: [String]) -> String {
        
        var locations: [Location] = []
        var routes: [Route] = []
        
        for line in input {
            var components = line.components(separatedBy: " ")
            components.remove(at: 3)
            components.remove(at: 1)
            
            let location_1 = components[0]
            let location_2 = components[1]
            let distance = components[2]
            
            if locations.first(where: {$0.name == location_1}) == nil {
                locations.append(Location(name: location_1))
            }
            if locations.first(where: {$0.name == location_2}) == nil {
                locations.append(Location(name: location_2))
            }
            guard let distance = Int(distance) else { fatalError("Can not cast int from \(distance)")}
            routes.append(Route(from: location_1, to: location_2, distance: distance))
        }
        
        let ways = permutations(xs: locations)
        for way in ways {
            var distance: Int? = 0
            for i in 0 ..< way.count {
                guard i + 1 <= way.count - 1 else { break }
                let from = way[i]
                let to = way[i+1]
                
                if let d = getDistance(from: from, to: to, in: routes){
                    distance = (distance ?? 0) + d
                } else {
                    distance = nil
                    break
                }
                
            }
            distances.append(distance)
        }
        
        if let min = distances.compactMap({ $0 }).min() {
            return "\(min)"
        } else {
            return "nil"
        }
    }

    static func solvePart2(input: [String]) -> String {
        if let min = distances.compactMap({ $0 }).max() {
            return "\(min)"
        } else {
            return "nil"
        }
    }
}

extension Day_9_2015 {
    static func getDistance(from l1: Location, to l2: Location, in routes: [Route]) -> Int? {
        let route_1 = routes.first { $0.from == l1.name && $0.to == l2.name }
        let route_2 = routes.first { $0.from == l2.name && $0.to == l1.name }
        
        return route_1?.distance ?? route_2?.distance
    }
}
