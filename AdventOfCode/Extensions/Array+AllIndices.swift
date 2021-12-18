//
//  Array+AllIndices.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 18.12.21.
//

extension Array where Element: Equatable {
  func allIndices(of value: Element) -> [Index] {
    indices.filter { self[$0] == value }
  }
}
