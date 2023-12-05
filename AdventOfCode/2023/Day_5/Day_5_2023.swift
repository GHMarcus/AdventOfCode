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
        let offset: Int
        let source: ClosedRange<Int>
        
        init(_ str: String) {
            let cmp = str.components(separatedBy: " ")
            let destinationStart = Int(cmp[0])!
            let sourceStart = Int(cmp[1])!
            let length = Int(cmp[2])!
            source = sourceStart ... sourceStart + length - 1
            offset = destinationStart - sourceStart
        }
        
        init(source: ClosedRange<Int>, offset: Int) {
            self.source = source
            self.offset = offset
        }
        
        func convert(_ seed: Int) -> Int? {
            guard source.contains(seed) else { return nil }
            return seed+offset
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
        
        func findLocations(for initialSeedRange: ClosedRange<Int>) -> ClosedRange<Int> {
            var seedRanges: Set<ClosedRange<Int>> = [initialSeedRange]
            
            for section in maps {
                seedRanges = convert(seedRanges, in: section)
            }
            
            return seedRanges.sorted { $0.lowerBound < $1.lowerBound }.first!
        }
        
        func convert(_ seedRanges: Set<ClosedRange<Int>>, in section: [Ranges]) -> Set<ClosedRange<Int>> {
            
            var newSeedRanges: Set<ClosedRange<Int>> = []
            
            for seedRange in seedRanges {
                var convertedRanges: [Ranges] = []
                let fittingRanges = section.filter { seedRange.overlaps($0.source) }
                
                for fittingRange in fittingRanges {
                    let range = fittingRange.source.clamped(to: seedRange)
                    convertedRanges.append(Ranges(source: range, offset: fittingRange.offset))
                }
                
                convertedRanges.sort { $0.source.lowerBound < $1.source.lowerBound }
                if convertedRanges.isEmpty {
                    convertedRanges = [Ranges(source: seedRange, offset: 0)]
                } else if seedRange.lowerBound < convertedRanges.first!.source.lowerBound {
                    convertedRanges.insert(Ranges(source: seedRange.lowerBound ... convertedRanges.first!.source.lowerBound-1, offset: 0), at: 0)
                } else  if seedRange.upperBound > convertedRanges.last!.source.upperBound {
                    convertedRanges.append(Ranges(source: convertedRanges.last!.source.upperBound+1 ... seedRange.upperBound, offset: 0))
                }
                
                let tmp = convertedRanges.map { ($0.source.lowerBound+$0.offset) ... ($0.source.upperBound+$0.offset) }
                tmp.forEach { newSeedRanges.insert($0)}
            }
            
            return newSeedRanges
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
        lines.removeFirst()
        var jumpOverNextLine = true
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
        
        for seedRange in input.seedsPart2 {
            let locations = input.findLocations(for: seedRange)
            minLocation = min(minLocation, locations.lowerBound)
        }
        
        return "\(minLocation)"
    }
}
