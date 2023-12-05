//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/5

enum Day_5_2023: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2023
    
    struct Ranges {
        let destination: ClosedRange<Int>
        let source: ClosedRange<Int>
        
        init(_ str: String) {
            let cmp = str.components(separatedBy: " ")
            let destinationStart = Int(cmp[0])!
            let sourceStart = Int(cmp[1])!
            let length = Int(cmp[2])!
            destination = destinationStart ... destinationStart + length - 1
            source = sourceStart ... sourceStart + length - 1
        }
        
        func convert(_ seed: Int) -> Int? {
            guard source.contains(seed) else { return nil }
            let distance = seed - source.lowerBound
            return destination.lowerBound + distance
        }
    }
    
    struct Almanac {
        let seedsPart1: [Int]
        let seedsPart2: [ClosedRange<Int>]
        let maps: [[Ranges]]
        
        func convert(_ seed: Int) -> Int {
            var location = seed
            for map in maps {
                for range in map {
                    if let newLocation = range.convert(location) {
                        location = newLocation
                        break
                    }
                }
            }
            return location
        }
    }
    
    static func convert(input: [String]) -> Almanac {
        var lines = input
        
        var seedsPart1: [Int] = []
        var seedsPart2: [ClosedRange<Int>] = []
        var maps: [[Ranges]] = []
        var currentMap: [Ranges] = []
        
        let seedLine = lines.removeFirst()
        seedsPart1 = seedLine.components(separatedBy: ": ")[1].components(separatedBy: " ").map({ Int($0)! })
        seedsPart2 = seedsPart1.chunked(into: 2).map { $0.first!...$0.first!+$0.last!-1 }.sorted {$0.lowerBound < $1.lowerBound}
        
        var jumpOverNextLine = false
        for line in lines {
            if jumpOverNextLine {
                jumpOverNextLine = false
                continue
            }
            if line.isEmpty {
                maps.append(currentMap)
                currentMap = []
                jumpOverNextLine = true
                continue
            }
            
            currentMap.append(Ranges(line))
        }
        
        return Almanac(
            seedsPart1: seedsPart1,
            seedsPart2: seedsPart2,
            maps: maps
        )
    }

    static func solvePart1(input: Almanac) -> String {
        var minLocation = Int.max
        for seed in input.seedsPart1 {
            minLocation = min(input.convert(seed), minLocation)
        }
        
        return "\(minLocation)"
    }

    static func solvePart2(input: Almanac) -> String {
        var minLocation = Int.max
        for (index, seedRange) in input.seedsPart2.enumerated() {
            print("Range #\(index)")
            for seed in seedRange {
                minLocation = min(input.convert(seed), minLocation)
            }
        }
        
        return "\(minLocation)"
    }
}




//enum Day_5_2023: Solvable {
//    static var day: Input.Day = .Day_5
//    static var year: Input.Year = .Year_2023
//    
//    struct MapRange {
//        var destination: Int
//        var source: Int
//        var rangeLength: Int
//        
//        func Map(value: Int) -> Int? {
//            var result: Int?
//            if value >= source && value < source + rangeLength {
//                result = value - source + destination
//            }
//            return result
//        }
//        
//        init(str: String) {
//            let s = str.components(separatedBy: .whitespaces)
//            destination = Int(s[0])!
//            source = Int(s[1])!
//            rangeLength = Int(s[2])!
//        }
//    }
//
//    struct Map {
//        var mapRanges: [MapRange] = []
//        
//        func convert(value: Int) -> Int {
//            for map in mapRanges {
//                if let result = map.Map(value: value) {
//                    return result
//                }
//            }
//            return value
//        }
//    }
//    
//    static func convert(input: [String]) -> ([Int], [Map]) {
//        var maps: [Map] = []
//        var lineIndex = 0
//        
//        let seeds: [Int] = input[lineIndex].components(separatedBy: .whitespaces).dropFirst().map( { Int($0)! } )
//        lineIndex += 3
//        
//        while lineIndex < input.count {
//            var m = Map()
//            while lineIndex < input.count && input[lineIndex] != "" {
//                m.mapRanges.append(MapRange(str: input[lineIndex]))
//                lineIndex += 1
//            }
//            maps.append(m)
//            lineIndex += 2
//        }
//        return (seeds, maps)
//    }
//    
//    static func solvePart1(input: ([Int], [Map])) -> String {
//        var result = Int.max
//        var seeds: [Int] = input.0
//        var maps: [Map] = input.1
//        
//        for seed in seeds {
//            var x = seed
//            for map in maps {
//                x = map.convert(value: x)
//            }
//            result = min(result, x)
//        }
//        return "\(result)"
//    }
//    
//    static func solvePart2(input: ([Int], [Map])) -> String {
//        var result = Int.max
//        var seeds: [Int] = input.0
//        var maps: [Map] = input.1
//        
//        var seedIndex = 0
//        while seedIndex < seeds.count {
//            let start = seeds[seedIndex]
//            let range = seeds[seedIndex+1]
//            seedIndex += 2
//            for seed in (start...start+range-1) {
//                var x = seed
//                for map in maps {
//                    x = map.convert(value: x)
//                }
//                result = min(result, x)
//            }
//        }
//        
//        return "\(result)"
//    }
//}
