//
//  Array+Chunks.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 25.11.21.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
