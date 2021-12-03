//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/25

enum Day_25_2020: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [Int]) -> String {
        let cardPublicKey = input[0]
        let doorPublicKey = input[1]

        let subjectNumber = 7
        let magicValue = 20201227

        var cardLoop = 0
        var cardValue = 1
        while cardValue != cardPublicKey {
            cardValue = cardValue * subjectNumber
            cardValue = cardValue % magicValue
            cardLoop += 1
        }

        var doorLoop = 0
        var doorValue = 1
        while doorValue != doorPublicKey {
            doorValue = doorValue * subjectNumber
            doorValue = doorValue % magicValue
            doorLoop += 1
        }

        var cardEncryptionKey = 1
        for _ in 0..<doorLoop {
            cardEncryptionKey = cardEncryptionKey * cardPublicKey
            cardEncryptionKey = cardEncryptionKey % magicValue
        }

        var doorEncryptionKey = 1
        for _ in 0..<cardLoop {
            doorEncryptionKey = doorEncryptionKey * doorPublicKey
            doorEncryptionKey = doorEncryptionKey % magicValue
        }

        if cardEncryptionKey == doorEncryptionKey {
            return "\(cardEncryptionKey)"
        } else {
            return "Something went wrong"
        }
    }

    static func solvePart2(input: [Int]) -> String {
        "Add some Code here"
    }
}
