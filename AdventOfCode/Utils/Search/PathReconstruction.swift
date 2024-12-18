//
//  PathReconstruction.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 18.12.24.
//

extension Dictionary where Key == Value {
    func reconstructPath(to value: Value) -> [Value] {
        var current = value
        var totalPath = [current]
        while let value = self[current] {
            current = value
            totalPath.append(value)
        }
        return totalPath.reversed()
    }
}

extension Dictionary where Value == [Key] {
    func reconstructPath(to current: Key) -> [[Key]] {
        guard let value = self[current] else { return [[current]] }
        let paths = Set(value)
        var newPaths: [[Key]] = []
        paths.forEach { next in
            newPaths.append(contentsOf: reconstructPath(to: next)
                .map { path in
                    path + [current]
                }
            )
        }
        
        return newPaths
    }
}
