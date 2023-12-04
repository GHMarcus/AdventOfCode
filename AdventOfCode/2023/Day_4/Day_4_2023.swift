//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/4

enum Day_4_2023: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2023
    
    struct Card {
        let id: Int
        let winningNumbers: Set<Int>
        let numbers: Set<Int>
        
        var value: Int {
            let common = numbers.intersection(winningNumbers)
            return 2.pow(common.count-1)
        }
        
        var winningCards: Int {
            numbers.intersection(winningNumbers).count
        }
    }
    
    static func convert(input: [String]) -> [Card] {
        var cards: [Card] = []
        
        for line in input {
            let id = Int(line.components(separatedBy: ": ")[0].dropFirst(4).trimmingCharacters(in: [" "]))!
            let numbersStr = line.components(separatedBy: ": ")[1].components(separatedBy: " | ")
            let winningNumbers = numbersStr[0].components(separatedBy: " ").compactMap { Int($0) }
            let numbers = numbersStr[1].components(separatedBy: " ").compactMap { Int($0) }
            
            cards.append(Card(id: id, winningNumbers: Set(winningNumbers), numbers: Set(numbers)))
        }
        
        return cards
    }

    static func solvePart1(input: [Card]) -> String {
        let sum = input.reduce(0) { $0 + $1.value }
        return "\(sum)"
    }

    static func solvePart2(input: [Card]) -> String {
        var cardsAndCopies: [Int: Int] = [:]
        
        for card in input {
            guard card.winningCards > 0 else { continue }
            
            let wins = 1 + (cardsAndCopies[card.id] ?? 0)
            
            for winId in 1...card.winningCards {
                if let value = cardsAndCopies[card.id +  winId] {
                    cardsAndCopies[card.id +  winId] = value + wins
                } else {
                    cardsAndCopies[card.id +  winId] =  wins
                }
            }
        }
        
        let wonCards = cardsAndCopies.reduce(0) { $0 + $1.value }
        
        return "\(input.count + wonCards)"
    }
}
