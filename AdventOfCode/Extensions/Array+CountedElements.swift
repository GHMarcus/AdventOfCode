//
//  Array+CountedElements.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 27.07.22.
//


/// Returns a dictionary with the counted elements of the given array
/// E.g [1,2,3,1,1] -> [1:3, 2:1, 3:1]
extension Array where Element: Hashable {
    var countedElements: Dictionary<Element,Int> {
        var counts: [Element: Int] = [:]

        for item in self {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        return counts
    }
}
