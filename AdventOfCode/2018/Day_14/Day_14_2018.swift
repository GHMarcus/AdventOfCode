//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/14

enum Day_14_2018: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2018

    static func solvePart1(input: [String]) -> String {
        let rounds = Int(input.first!)!
        var scoreBoard = [3, 7]
        var firstElf = 0
        var secondElf = 1
        
        var recipesMade = 0
        while recipesMade < rounds * 2 {
            let newScore = scoreBoard[firstElf] + scoreBoard[secondElf]
            let firstScore = newScore / 10
            let secondScore = newScore % 10
            
            if firstScore > 0 {
                recipesMade += 1
                scoreBoard.append(firstScore)
            }
            recipesMade += 1
            scoreBoard.append(secondScore)
            
            let numberOfScores = scoreBoard.count
            
            let newFirstElf = 1 + scoreBoard[firstElf] + firstElf
            if newFirstElf >= numberOfScores {
                firstElf = newFirstElf % numberOfScores
            } else {
                firstElf = newFirstElf
            }
            
            let newSecondElf = 1 + scoreBoard[secondElf] + secondElf
            if newSecondElf >= numberOfScores {
                secondElf = newSecondElf % numberOfScores
            } else {
                secondElf = newSecondElf
            }
            
//            var scoreBoardString = ""
//            for (index, score) in scoreBoard.enumerated() {
//                if index == firstElf {
//                    scoreBoardString += "(\(score))"
//                } else  if index == secondElf {
//                    scoreBoardString += "[\(score)]"
//                } else {
//                    scoreBoardString += " \(score) "
//                }
//            }
//            print(scoreBoardString)
        }
        
        var nextTen = ""
        let numberOfScores = scoreBoard.count
        for i in 0 ..< 10 {
            var nextTenIndex = rounds + i
            
            if nextTenIndex >= numberOfScores {
                nextTenIndex = nextTenIndex % numberOfScores
            }
            
            nextTen += "\(scoreBoard[nextTenIndex])"
        }
        
        
        return nextTen
    }
    
    // Use speed optimization -> average time ~84 sec
    static func solvePart2(input: [String]) -> String {
        let rounds = Array(input.first!)
        var scoreBoard = [3, 7]
        var firstElf = 0
        var secondElf = 1
        
        let roundsCount = rounds.count - 1
        let inputSequence = rounds.compactMap({ Int(String($0)) }).prefix(roundsCount+1)
        
        var isAfterFirstRecipe = false
        
        while true {
            let newScore = scoreBoard[firstElf] + scoreBoard[secondElf]
            let firstScore = newScore / 10
            let secondScore = newScore % 10

            if firstScore > 0 {
                scoreBoard.append(firstScore)
            }
            scoreBoard.append(secondScore)

            let numberOfScores = scoreBoard.count

            let newFirstElf = 1 + scoreBoard[firstElf] + firstElf
            if newFirstElf >= numberOfScores {
                firstElf = newFirstElf % numberOfScores
            } else {
                firstElf = newFirstElf
            }

            let newSecondElf = 1 + scoreBoard[secondElf] + secondElf
            if newSecondElf >= numberOfScores {
                secondElf = newSecondElf % numberOfScores
            } else {
                secondElf = newSecondElf
            }


            let scoreBoardCount = scoreBoard.count - 1
            
            if scoreBoardCount > roundsCount {
                let currentSequenceFirst = scoreBoard[scoreBoardCount-roundsCount-1 ... scoreBoardCount-1]
                let currentSequenceSecond = scoreBoard[scoreBoardCount-roundsCount ... scoreBoardCount]
                
                if currentSequenceFirst == inputSequence {
                    isAfterFirstRecipe = true
                    break
                } else if currentSequenceSecond == inputSequence {
                    break
                }
            }
        }

        return "\(scoreBoard.count - rounds.count - (isAfterFirstRecipe ? 1 : 0))"
    }
}
