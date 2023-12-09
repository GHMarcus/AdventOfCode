//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/8

enum Day_8_2023: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2023
    
    class Node {
        let name: String
        var left: String?
        var right: String?
        
        init(name: String, left: String?, right: String?) {
            self.name = name
            self.left = left
            self.right = right
        }
        
        func next(for instruction: Character) -> String {
            switch instruction {
            case "R":
                return right!
            case "L":
                return left!
            default:
                fatalError()
            }
        }
    }

    static func convert(input: [String]) -> (String, [String: Node]) {
        var lines = input
        let instructions = lines.removeFirst()
        lines.removeFirst()
        
        var nodes: [String: Node] = [:]
        
        for line in lines {
            let cmp = line.components(separatedBy: " = ")
            let name = cmp[0]
            let left = String(cmp[1].components(separatedBy: ", ")[0].dropFirst())
            let right = String(cmp[1].components(separatedBy: ", ")[1].dropLast())
            
            let node: Node
            let leftNode: Node
            let rightNode: Node
            
            
            if let l = nodes[left] {
                leftNode = l
            } else {
                leftNode = Node(name: left, left: nil, right: nil)
            }
            
            if let r = nodes[right] {
                rightNode = r
            } else {
                rightNode = Node(name: right, left: nil, right: nil)
            }
            
            if let n = nodes[name] {
                n.left = left
                n.right = right
                node = n
            } else {
                node = Node(name: name, left: left, right: right)
            }
            
            nodes[name] = node
            nodes[left] = leftNode
            nodes[right] = rightNode
        }
        
        return (instructions, nodes)
    }
    
    static func solvePart1(input: (String, [String: Node])) -> String {
        var steps = 0
        let instructions = Array(input.0)
        let nodes = input.1
        var current = nodes["AAA"]!
        var running = true
        while running {
            for instruction in instructions {
                current = nodes[current.next(for: instruction)]!
                steps += 1
                
                if current.name == "ZZZ" {
                    running = false
                    break
                }
            }
        }
        
        return "\(steps)"
    }

    static func solvePart2(input: (String, [String: Node])) -> String {
        let instructions = Array(input.0)
        let nodes = input.1
        let currents = nodes.filter { $0.value.name.last == "A"}.map { $0.value }
        
        var allSteps: [Int] = []
        for current in currents {
            var current = current
            var steps = 0
            var running = true
            
            while running {
                for instruction in instructions {
                    current = nodes[current.next(for: instruction)]!
                    steps += 1
                    
                    if current.name.last == "Z" {
                        allSteps.append(steps)
                        running = false
                        break
                    }
                }
            }
        }
        
        let stepsLCM = allSteps.reduce(1) { lcm($0, $1) }
        
        return "\(stepsLCM)"
    }
}
