//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/25


// Took 2997.1837561130524 seconds

enum Day_25_2023: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2023
    
    struct Node {
        let name: String
        var connections: [Set<String>]
    }
    
    struct Graph {
        let nodes: [String: Node]
        let connections: [Set<String>]
    }
    
    static func convert(input: [String]) -> Graph {
        var nodes: Set<String> = []
        var connections: Set<Set<String>> = []
        for line in input {
            let cmp = line.components(separatedBy: ": ")
            let name = cmp[0]
            nodes.insert(name)
            for connection in cmp[1].components(separatedBy: " ") {
                nodes.insert(connection)
                connections.insert(Set([name, connection]))
            }
        }
        
        let actualNodes: [String: Node] = nodes
            .map{ name in
                Node(name: name, connections: connections.filter({ $0.contains(name) }))
            }
            .reduce(into: [:]) { $0[$1.name] = $1 }
        
        return Graph(nodes: actualNodes, connections: connections.shuffled())
    }

    static func solvePart1(input: Graph) -> String {
        var cuts: [Set<String>] = []
        while cuts.count != 3 {
            cuts = kargersAlgorithm(graph: input)
        }
        let groups = cuts[0].map {$0.count/3}
        return "\(groups.reduce(1, *))"
    }

    static func solvePart2(input: Graph) -> String {
        return "Add some Code here"
    }
    
    static func kargersAlgorithm(graph: Graph) -> [Set<String>] {
        var nodes: [String: Node] = graph.nodes
        var connections: [Set<String>] = graph.connections
        while nodes.count > 2 {
            // Pick random connection
            let randomIndex = Int.random(in: 0..<connections.count)
            let randomConnection = connections.remove(at: randomIndex).sorted()
            
            // Contract the connection
            var node1 = nodes.removeValue(forKey: randomConnection[0])!
            var node2 = nodes.removeValue(forKey: randomConnection[1])!
            
            let removeIndex1 = node1.connections.firstIndex(of: Set(randomConnection))!
            node1.connections.remove(at: removeIndex1)
            
            let removeIndex2 = node2.connections.firstIndex(of: Set(randomConnection))!
            node2.connections.remove(at: removeIndex2)
            
            let newName = "\(node1.name)\(node2.name)"
            let newNode = Node(name: newName, connections: node1.connections + node2.connections)
            nodes[newName] = newNode
            
            for node in nodes.values.indices {
                for i in 0..<nodes.values[node].connections.count {
                    if nodes.values[node].connections[i].contains(node1.name) {
                        nodes.values[node].connections[i].remove(node1.name)
                        nodes.values[node].connections[i].insert(newName)
                    }
                    
                    if nodes.values[node].connections[i].contains(node2.name) {
                        nodes.values[node].connections[i].remove(node2.name)
                        nodes.values[node].connections[i].insert(newName)
                    }
                }
                // Other connections to the two nodes that were combined will lead in an se of one element
                // We have to delete theme
                nodes.values[node].connections = nodes.values[node].connections.filter {$0.count == 2}
            }
            
            for i in 0..<connections.count {
                if connections[i].contains(node1.name) {
                    connections[i].remove(node1.name)
                    connections[i].insert(newName)
                }
                if connections[i].contains(node2.name) {
                    connections[i].remove(node2.name)
                    connections[i].insert(newName)
                }
            }
            
            // Other connections to the two nodes that were combined will lead in an se of one element
            // We have to delete theme
            connections = connections.filter {$0.count == 2}
        
        }
        
        return connections
    }
}
