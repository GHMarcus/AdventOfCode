//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/24

// Note: Took 35.953027963638306 seconds

enum Day_24_2017: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2017
    
    struct Component: Hashable {
        let inputPins: Int
        let outputPins: Int
        
        var desc: String {
            "\(inputPins)/\(outputPins)"
        }
    }
    
    static func convert(input: [String]) -> Set<Component> {
        var components: Set<Component> = []
        for line in input {
            let parts = line.components(separatedBy: "/")
            components.insert(Component(inputPins: Int(parts[0])!, outputPins: Int(parts[1])!))
        }
        return components
    }

    static func solvePart1(input: Set<Component>) -> String {
        var bridges: Set<[Component]> = []
        
        var components = input
        
        var startingComponents: [Component] = []
        for component in input {
            if component.inputPins == 0 || component.outputPins == 0 {
                startingComponents.append(component)
                components.remove(component)
            }
        }
        for start in startingComponents {
            let restComponents = components
            let bridge: [Component] = [start]
            let lastUsedPins = start.outputPins
            bridges.insert(bridge)
            bridges.formUnion(addNextComponent(to: bridge, from: restComponents, with: lastUsedPins))
        }
        
//        bridges.forEach {
//            print($0.map{ $0.desc }.joined(separator: " -> "))
//        }
        
        let strengths = bridges.map {
            $0.reduce(into: 0) { partialResult, component in
                partialResult += component.inputPins + component.outputPins
            }
        }
        
//        print(strengths)
        
        return "\(strengths.max()!)"
    }

    static func solvePart2(input: Set<Component>) -> String {
        var bridges: Set<[Component]> = []
        
        var components = input
        
        var startingComponents: [Component] = []
        for component in input {
            if component.inputPins == 0 || component.outputPins == 0 {
                startingComponents.append(component)
                components.remove(component)
            }
        }
        for start in startingComponents {
            let restComponents = components
            let bridge: [Component] = [start]
            let lastUsedPins = start.outputPins
            bridges.insert(bridge)
            bridges.formUnion(addNextComponent(to: bridge, from: restComponents, with: lastUsedPins))
        }
        
//        bridges.forEach {
//            print($0.map{ $0.desc }.joined(separator: " -> "))
//        }
        
        let maxLength = bridges.map {
            $0.count
        }.max()!
        
        let strengths = bridges
            .filter{ $0.count == maxLength }
            .map {
                $0.reduce(into: 0) { partialResult, component in
                    partialResult += component.inputPins + component.outputPins
                }
            }
        
        
//        print(strengths)
        
        return "\(strengths.max()!)"
    }
    
    static func addNextComponent(to bridge: [Component], from components: Set<Component>, with lastUsed: Int) -> Set<[Component]> {
        var bridges = Set<[Component]>()
        for next in components.filter({ $0.inputPins == lastUsed || $0.outputPins == lastUsed }) {
            let newBridge = bridge + [next]
            bridges.insert(newBridge)
            var newComponents = components
            newComponents.remove(next)
            let newLastUsed = next.outputPins == lastUsed ? next.inputPins : next.outputPins
            bridges.formUnion(addNextComponent(to: newBridge, from: newComponents, with: newLastUsed))
        }
        return bridges
    }
}
