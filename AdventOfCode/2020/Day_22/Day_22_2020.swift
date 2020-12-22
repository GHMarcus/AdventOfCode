//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/22

enum Day_22_2020: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        var playerOne = true
        var playerOneCards: [Int] = []
        var playerTwoCards: [Int] = []
        for line in input {
            if line.count > 2 {
                continue
            }
            if line.isEmpty {
                playerOne = false
                continue
            }
            if playerOne {
                playerOneCards.append(Int(line)!)
            } else {
                playerTwoCards.append(Int(line)!)
            }
        }

        while !playerOneCards.isEmpty && !playerTwoCards.isEmpty {
            let playerOneCard = playerOneCards.removeFirst()
            let playerTwoCard = playerTwoCards.removeFirst()

            if playerOneCard > playerTwoCard {
                playerOneCards.append(playerOneCard)
                playerOneCards.append(playerTwoCard)
            } else {
                playerTwoCards.append(playerTwoCard)
                playerTwoCards.append(playerOneCard)
            }
        }
        
        let playerOneWins = !playerOneCards.isEmpty
        var sum = 0
        if playerOneWins {
            for (index, card) in playerOneCards.reversed().enumerated() {
                sum += (index + 1) * card
            }
        } else {
            for (index, card) in playerTwoCards.reversed().enumerated() {
                sum += (index + 1) * card
            }
        }

        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        var playerOne = true
        var playerOneCards: [Int] = []
        var playerTwoCards: [Int] = []
        for line in input {
            if line.count > 2 {
                continue
            }
            if line.isEmpty {
                playerOne = false
                continue
            }
            if playerOne {
                playerOneCards.append(Int(line)!)
            } else {
                playerTwoCards.append(Int(line)!)
            }
        }

        var playerStates: Set<[String]> = []
        while !playerOneCards.isEmpty && !playerTwoCards.isEmpty {
            let p1Str = playerOneCards.reduce("") {$0 + String($1)}
            let p2Str = playerOneCards.reduce("") {$0 + String($1)}
            if !playerStates.insert([p1Str, p2Str]).inserted {
                break
            }
            let playerOneCard = playerOneCards.removeFirst()
            let playerTwoCard = playerTwoCards.removeFirst()

            let p1SameCards = playerOneCards.count >= playerOneCard
            let p2SameCards = playerTwoCards.count >= playerTwoCard
            if p1SameCards && p2SameCards {
                let playerOneWins = playingSubGame(
                    playerOneCards.dropLast(playerOneCards.count-playerOneCard),
                    playerTwoCards.dropLast(playerTwoCards.count-playerTwoCard)
                )
                if playerOneWins {
                    playerOneCards.append(playerOneCard)
                    playerOneCards.append(playerTwoCard)
                } else {
                    playerTwoCards.append(playerTwoCard)
                    playerTwoCards.append(playerOneCard)
                }
            } else if playerOneCard > playerTwoCard {
                playerOneCards.append(playerOneCard)
                playerOneCards.append(playerTwoCard)
            } else {
                playerTwoCards.append(playerTwoCard)
                playerTwoCards.append(playerOneCard)
            }
        }

        let playerOneWins = !playerOneCards.isEmpty
        var sum = 0
        if playerOneWins {
            for (index, card) in playerOneCards.reversed().enumerated() {
                sum += (index + 1) * card
            }
        } else {
            for (index, card) in playerTwoCards.reversed().enumerated() {
                sum += (index + 1) * card
            }
        }

        return "\(sum)"
    }

    static func playingSubGame(_ playerOneCards: [Int], _ playerTwoCards: [Int]) -> Bool {
        var playerStates: Set<[String]> = []
        var p1Cards = playerOneCards
        var p2Cards = playerTwoCards
        while !p1Cards.isEmpty && !p2Cards.isEmpty {

            let p1Str = p1Cards.reduce("") {$0 + String($1)}
            let p2Str = p2Cards.reduce("") {$0 + String($1)}
            if !playerStates.insert([p1Str, p2Str]).inserted {
                p1Cards = [1]
                break
            }
            let p1Card = p1Cards.removeFirst()
            let p2Card = p2Cards.removeFirst()

            let p1SameCards = p1Cards.count >= p1Card
            let p2SameCards = p2Cards.count >= p2Card
            if p1SameCards && p2SameCards {
                let playerOneWins = playingSubGame(
                    p1Cards.dropLast(p1Cards.count-p1Card),
                    p2Cards.dropLast(p2Cards.count-p2Card)
                )
                if playerOneWins {
                    p1Cards.append(p1Card)
                    p1Cards.append(p2Card)
                } else {
                    p2Cards.append(p2Card)
                    p2Cards.append(p1Card)
                }
            } else if p1Card > p2Card {
                p1Cards.append(p1Card)
                p1Cards.append(p2Card)
            } else {
                p2Cards.append(p2Card)
                p2Cards.append(p1Card)
            }
        }
        return !p1Cards.isEmpty
    }
}

