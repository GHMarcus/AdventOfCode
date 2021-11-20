//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/14

enum Day_14_2015: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2015
    
    class Reindeer {
        let name: String
        let speedPerSek: Int
        let speedTime: Int
        let restTime: Int
        var points = 0
        var position = 0
        
        init(name: String, speedPerSek: Int, speedTime: Int, restTime: Int) {
            self.name = name
            self.speedPerSek = speedPerSek
            self.speedTime = speedTime
            self.restTime = restTime
        }
        
        func getPoint() {
            points += 1
        }
        
        func run(_ sek: Int) {
            let oneCircle = speedTime + restTime
            let rest: Int = sek % oneCircle
            if rest < speedTime {
                position += speedPerSek
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        let reindeers = convertInputToReindeer(input)
        
        let endTime = 2503
        var endPositions: [Int] = []
        
        for reindeer in reindeers {
            let oneCircle = reindeer.speedTime + reindeer.restTime
            let fullCircles: Int = endTime / oneCircle
            let rest: Int = endTime % oneCircle
            
            var position = reindeer.speedPerSek * reindeer.speedTime * fullCircles
            
            if rest >= reindeer.speedTime {
                position += reindeer.speedTime * reindeer.speedPerSek
            } else {
                position += rest * reindeer.speedPerSek
            }
            
            endPositions.append(position)
        }
        
        return "\(endPositions.max() ?? 0)"
    }

    static func solvePart2(input: [String]) -> String {
        let reindeers = convertInputToReindeer(input)
        
        let endTime = 2503
        
        for sek in 0..<endTime {
            for reindeer in reindeers {
                reindeer.run(sek)
            }
            
            let maxPosition = reindeers.map({$0.position}).max() ?? 0
            for reindeer in reindeers {
                if reindeer.position == maxPosition {
                    reindeer.getPoint()
                }
            }
        }
        
        
        return "\(reindeers.map({ $0.points}).max() ?? 0)"
    }
}

extension Day_14_2015 {
    static func convertInputToReindeer(_ input: [String]) -> [Reindeer] {
        var reindeers: [Reindeer] = []
        for line in input {
            let components = line.components(separatedBy: " ")
            reindeers.append(Reindeer(
                name: components[0],
                speedPerSek: Int(components[3]) ?? 0,
                speedTime: Int(components[6]) ?? 0,
                restTime: Int(components[13]) ?? 0)
            )
        }
        
        return reindeers
    }
}

