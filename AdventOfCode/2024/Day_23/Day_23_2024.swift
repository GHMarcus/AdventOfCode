//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/23

enum Day_23_2024: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [String: Computer]
    
    class Computer: Hashable, Equatable {
        static func == (lhs: Day_23_2024.Computer, rhs: Day_23_2024.Computer) -> Bool {
            lhs.name == rhs.name
        }
        
        let name: String
        var connections: Set<String>
        
        init(name: String, connections: Set<String> = []) {
            self.name = name
            self.connections = connections
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        var computers: [String: Computer] = [:]
        input.forEach { line in
            let components = line.components(separatedBy: "-")
            let computer1Name = components[0]
            let computer2Name = components[1]
            
            if let existingComputer1 = computers[computer1Name] {
                existingComputer1.connections.insert(computer2Name)
            } else {
                computers[computer1Name] = Computer(name: computer1Name, connections: [computer2Name])
            }
            
            if let existingComputer2 = computers[computer2Name] {
                existingComputer2.connections.insert(computer1Name)
            } else {
                computers[computer2Name] = Computer(name: computer2Name, connections: [computer1Name])
            }
            
        }
        return computers
    }

    static func solvePart1(input: ConvertedInput) -> String {
        var partyOfThree: Set<Set<String>> = []
        
        for computer1 in input {
            for computer2 in computer1.value.connections {
                for computer3 in input[computer2]!.connections {
                    if input[computer3]!.connections.contains(computer1.key) {
                        partyOfThree.insert([computer1.key, computer2, computer3])
                    }
                }
            }
        }
        
        partyOfThree = partyOfThree.filter {
            $0.contains {
                $0.starts(with: "t")
            }
        }
        
        return "\(partyOfThree.count)"
    }
    
    static func solvePart2(input: ConvertedInput) -> String {
        let maximalCliques = bronKerboschAlgorithm(
            for: Set(input.map{$0.value}),
            neighbors: { Set($0.connections.map { input[$0]! }) }
        )
        
        let maximumClique = maximalCliques.max { $0.count < $1.count }!
        let password = maximumClique.map(\.name).sorted(by: <).joined(separator: ",")
        
        return "\(password)"
    }
    
    static func bronKerboschAlgorithm<Node: Hashable & Equatable>(
        for graph: Set<Node>,
        neighbors: (Node) -> Set<Node>
    ) -> [Set<Node>] {
        var maximalCliques: [Set<Node>] = []
        
        func bronKerbosch(_ current:  Set<Node>, _ candidates: Set<Node>, _ exclusions: Set<Node>) {
            var candidates = candidates
            var exclusions = exclusions
            
            if candidates.isEmpty && exclusions.isEmpty {
                maximalCliques.append(current)
                return
            }
            
            for candidate in candidates {
                let neighborsOfCandidate = neighbors(candidate)
                bronKerbosch(
                    current.union([candidate]),
                    candidates.intersection(neighborsOfCandidate),
                    exclusions.intersection(neighborsOfCandidate)
                )
                candidates.remove(candidate)
                exclusions.insert(candidate)
            }
        }
        
        bronKerbosch([], graph, [])
        
        return maximalCliques
    }
}
