//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/21

enum Day_21_2021: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2021

    class Player {
        var position: Int
        var score: Int

        init(position: Int) {
            self.position = position
            score = 0
        }
    }

    static func solvePart1(input: [String]) -> String {
        let player1 = Player(position: Int(input[0].components(separatedBy: " ")[4])!)
        let player2 = Player(position: Int(input[1].components(separatedBy: " ")[4])!)

        var player1Turn = true
        var dice = 0
        var diceRolled = 0


        while true {
            var turns = 0
            for _ in 0...2 {
                dice += 1
                if dice > 100 {
                    dice -= 100
                }
                turns += dice
                diceRolled += 1
            }
            turns = turns % 10



            if player1Turn {
                player1.position += turns
                if player1.position > 10 {
                    player1.position -= 10
                }
                player1.score += player1.position
                if player1.score >= 1000 {
                    break
                }
                player1Turn.toggle()
            } else {
                player2.position += turns
                if player2.position > 10 {
                    player2.position -= 10
                }
                player2.score += player2.position
                if player2.score >= 1000 {
                    break
                }
                player1Turn.toggle()
            }
        }

        let loserScore: Int
        if player1Turn {
            loserScore = player2.score * diceRolled
        } else {
            loserScore = player1.score * diceRolled
        }

        return "\(loserScore)"
    }

    static var count1 = 0
    static var count2 = 0

    static func solvePart2(input: [String]) -> String {
        let result = playRound(
            player1: (Int(input[0].components(separatedBy: " ")[4])!, 0),
            player2: (Int(input[1].components(separatedBy: " ")[4])!, 0),
            player1Turn: true
        )

        return "\(max(result.0, result.1))"

    }

    static func playRound(player1: (Int, Int), player2: (Int,Int), wins: (Int,Int) = (0,0), player1Turn: Bool) -> (Int,Int) {
        let diceRolls = [(3,1),(4,3),(5,6),(6,7),(7,6),(8,3),(9,1)]

        if player1.1 >= 21 {
            return (1,0)
        }
        if player2.1 >= 21 {
            return (0,1)
        }
        var newWins = wins
        for roll in diceRolls {
            var newPos = player1Turn ? player1.0 + roll.0 : player2.0 + roll.0
            if newPos > 10 {
                newPos -= 10
            }
            let score = player1Turn ?  player1.1 + newPos : player2.1 + newPos
            let result = playRound(
                player1: player1Turn ? (newPos, score) : player1,
                player2: player1Turn ? player2 : (newPos, score),
                player1Turn: !player1Turn
            )
            newWins.0 += result.0 * roll.1
            newWins.1 += result.1 * roll.1
        }

        return newWins
    }
}
