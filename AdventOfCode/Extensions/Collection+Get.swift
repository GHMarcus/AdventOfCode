//
//  Collection+Get.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 05.12.22.
//

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    func get(_ index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
