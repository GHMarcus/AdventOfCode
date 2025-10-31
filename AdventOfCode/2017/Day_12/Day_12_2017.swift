//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/12

enum Day_12_2017: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2017
    
    struct Group {
        let id: String
        let connections: [String]
    }
    
    static func convert(input: [String]) -> [String: Group] {
        var groups: [String: Group] = [:]
        for line in input {
            let cmp = line.components(separatedBy: " <-> ")
            groups[cmp[0]] = Group(id: cmp[0], connections: cmp[1].components(separatedBy: ", "))
        }
        return groups
    }

    static func solvePart1(input: [String: Group]) -> String {
        let connections = findConnections(of: input["0"]!, in: input, connections: [])
        return "\(connections.count)"
    }

    static func solvePart2(input: [String: Group]) -> String {
        var groupsCount = 0
        var allGroups = input
        
        while !allGroups.isEmpty {
            let connections = findConnections(of: allGroups.first!.1, in: input, connections: [])
            connections.forEach { allGroups.removeValue(forKey: $0) }
            groupsCount += 1
        }
        
        return "\(groupsCount)"
    }
    
    static func findConnections(of group: Group, in groups: [String: Group], connections: Set<String>) -> Set<String> {
        var connections = connections
        if !connections.insert(group.id).inserted {
            return connections
        } else {
            for connection in group.connections {
                connections = connections.union(findConnections(of: groups[connection]!, in: groups, connections: connections))
            }
            return connections
        }
    }
}
