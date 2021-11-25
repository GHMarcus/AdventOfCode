//
//  StringExtensions.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 18.11.21.
//

// https://stackoverflow.com/a/45073012
extension String {
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
    
    /*
     https://stackoverflow.com/a/34371637
     let str = "aabbcsdfaewdsrsfdeewraewd"
     print(str.getCountedCharacters) // ["b": 2, "a": 4, "w": 3, "r": 2, "c": 1, "s": 3, "f": 2, "e": 4, "d": 4]
     */
    
    var getCountedCharacters: Dictionary<Character,Int> {
        self.reduce([:]) { (d, c) -> Dictionary<Character,Int> in
            var d = d
            let i = d[c] ?? 0
            d[c] = i+1
            return d
        }
    }
}

/*
 https://stackoverflow.com/a/32306142
 
 let str = "Hello, playground, playground, playground"
 str.index(of: "play")      // 7
 str.endIndex(of: "play")   // 11
 str.indices(of: "play")    // [7, 19, 31]
 str.ranges(of: "play")     // [{lowerBound 7, upperBound 11}, {lowerBound 19, upperBound 23}, {lowerBound 31, upperBound 35}]
 */

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
