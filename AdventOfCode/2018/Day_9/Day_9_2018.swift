//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/9

enum Day_9_2018: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2018
    
    class Marble: Equatable {
        let value: Int
        var next: Marble?
        var previous: Marble?
        
        init(value: Int, next: Marble? = nil, previous: Marble? = nil) {
            self.value = value
            self.next = next
            self.previous = previous
        }
        
        static func == (lhs: Day_9_2018.Marble, rhs: Day_9_2018.Marble) -> Bool {
            lhs.value == rhs.value
        }
    }

    static func solvePart1(input: [String]) -> String {
        let firstLine = input.first!.components(separatedBy: " ")
        
        let players = Int(firstLine[0])!
        let lastMarbleValue = Int(firstLine[6])!
        
        var currentMarble = Marble(value: 0)
        currentMarble.next = currentMarble
        currentMarble.previous = currentMarble
        var playerScores = Array(repeating: 0, count: players)
        var currentPlayerIndex = 0
        for newValue in 1...lastMarbleValue {
            if newValue % 23 == 0 {
                var removedMarble = currentMarble
                for _ in 1...7 {
                    removedMarble = removedMarble.previous!
                }
                
                playerScores[currentPlayerIndex] += newValue + removedMarble.value
                
                let previousMarble = removedMarble.previous!
                let nextMarble = removedMarble.next!
                
                previousMarble.next = nextMarble
                nextMarble.previous = previousMarble
                currentMarble = nextMarble
            } else {
                let newMarble = Marble(value: newValue)
                let previousMarble = currentMarble.next!
                let nextMarble = previousMarble.next!
                
                previousMarble.next = newMarble
                newMarble.previous = previousMarble
                
                newMarble.next = nextMarble
                nextMarble.previous = newMarble
                
                currentMarble = newMarble
            }
            currentPlayerIndex += 1
            if currentPlayerIndex == playerScores.count {
                currentPlayerIndex = 0
            }
        }

        return "\(playerScores.max() ?? 0)"
    }

    static func solvePart2(input: [String]) -> String {
        let firstLine = input.first!.components(separatedBy: " ")
        
        let players = Int(firstLine[0])!
        let lastMarbleValue = Int(firstLine[6])! * 100
        
        var currentMarble = Marble(value: 0)
        currentMarble.next = currentMarble
        currentMarble.previous = currentMarble
        var playerScores = Array(repeating: 0, count: players)
        var currentPlayerIndex = 0
        for newValue in 1...lastMarbleValue {
            if newValue % 23 == 0 {
                var removedMarble = currentMarble
                for _ in 1...7 {
                    removedMarble = removedMarble.previous!
                }
                
                playerScores[currentPlayerIndex] += newValue + removedMarble.value
                
                let previousMarble = removedMarble.previous!
                let nextMarble = removedMarble.next!
                
                previousMarble.next = nextMarble
                nextMarble.previous = previousMarble
                currentMarble = nextMarble
            } else {
                let newMarble = Marble(value: newValue)
                let previousMarble = currentMarble.next!
                let nextMarble = previousMarble.next!
                
                previousMarble.next = newMarble
                newMarble.previous = previousMarble
                
                newMarble.next = nextMarble
                nextMarble.previous = newMarble
                
                currentMarble = newMarble
            }
            currentPlayerIndex += 1
            if currentPlayerIndex == playerScores.count {
                currentPlayerIndex = 0
            }
        }
        
        return "\(playerScores.max() ?? 0)"
    }
    
    static func printMarbles(from marble: Marble) {
        var currentMarble = marble.next
        var circle = "(\(marble.value)) - "
        while currentMarble != marble {
            guard let current = currentMarble else {
                break
            }
            circle += "\(current.value) - "
            currentMarble = current.next
        }
        print(circle)
    }
}
