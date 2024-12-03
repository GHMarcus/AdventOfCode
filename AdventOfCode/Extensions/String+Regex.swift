//
//  String+Regex.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 03.12.24.
//

import Foundation

extension String {
    /// Find all matches for given regex
    func matches(for regex: String) -> [String] {
        ranges(for: regex).map{self[$0.lowerBound..<$0.upperBound]}.map{String($0)}
    }
    
    /// Find all ranges for given regex
    func ranges(for regex: String) -> [Range<String.Index>] {
        do {
            let atSearch = try Regex(regex)
            return self.ranges(of: atSearch)
        } catch {
            assertionFailure("Failed to create regex")
            return []
        }
    }
}
