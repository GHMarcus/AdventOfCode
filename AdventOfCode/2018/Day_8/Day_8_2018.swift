//
//  Day_8.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/8

enum Day_8_2018: Solvable {
    static var day: Input.Day = .Day_8
    static var year: Input.Year = .Year_2018
    
    class Node {
        var metadata: [Int]
        var children: [Node]
        
        init(metadata: [Int], children: [Node]) {
            self.metadata = metadata
            self.children = children
        }
    }
    
    static func convert(input: [String]) -> [Int] {
        input.first!.components(separatedBy: " ").map { Int(String($0))! }
    }

    static func solvePart1(input: [Int]) -> String {
        let (_, metaCount, _) = parseNode(file: input)
        
        return "\(metaCount)"
    }

    static func solvePart2(input: [Int]) -> String {
        let (rootNode, metaCount, _) = parseNode(file: input)
        let value = getNodeCount(rootNode)
        
        return "\(value)"
    }
    
    static func parseNode(file: [Int]) -> (node: Node, metaCount: Int, file: [Int]) {
        var file = file
        var metaCount = 0
        let childCount = file.removeFirst()
        let metadataCount = file.removeFirst()
        
        var children: [Node] = []
        for _ in 0..<childCount {
            let (child, childCount, restFile) = parseNode(file: file)
            children.append(child)
            metaCount += childCount
            file = restFile
        }
        
        var meta: [Int] = []
        for _ in 0..<metadataCount {
            let data = file.removeFirst()
            metaCount += data
            meta.append(data)
        }
        
        return (Node(metadata: meta, children: children), metaCount, file)
    }
    
    static func getNodeCount(_ node: Node) -> Int {
        if node.children.isEmpty {
            return node.metadata.reduce(0, +)
        } else {
            var total = 0
            for ref in node.metadata {
                let index = ref - 1
                if index < node.children.count && index >= 0 {
                    total += getNodeCount(node.children[index])
                }
            }
            return total
        }
    }
}
