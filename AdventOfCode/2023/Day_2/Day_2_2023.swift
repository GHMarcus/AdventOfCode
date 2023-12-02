//
//  Day_2.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/2

enum Day_2_2023: Solvable {
    static var day: Input.Day = .Day_2
    static var year: Input.Year = .Year_2023
    
    class Game {
        var id: Int
        var red: [Int]
        var green: [Int]
        var blue: [Int]
        
        init(id: Int, red: [Int] = [], green: [Int] = [], blue: [Int] = []) {
            self.id = id
            self.red = red
            self.green = green
            self.blue = blue
        }
        
        func addDice(_ dice: String) {
            let comp = dice.components(separatedBy: " ")
            let number = Int(comp[0])!
            switch comp[1] {
            case "red":
                red.append(number)
            case "green":
                green.append(number)
            case "blue":
                blue.append(number)
            default:
                fatalError("Color \(comp[1]) does not exist!")
            }
        }
        
        var power: Int {
            red.max()! * green.max()! * blue.max()!
        }
    }
    
    static func convert(input: [String]) -> [Game] {
        var games: [Game] = []
        
        for line in input {
            let comp1 = line.components(separatedBy: ": ")
            let id = Int(comp1[0].dropFirst(5))!
            let rounds = comp1[1].components(separatedBy: "; ")
            let game = Game(id: id)
            for round in rounds {
                let dices = round.components(separatedBy: ", ")
                for dice in dices {
                    game.addDice(dice)
                }
            }
            games.append(game)
            
        }
        return games
    }

    static func solvePart1(input: [Game]) -> String {
        let maxRed = 12
        let maxGreen = 13
        let maxBlue = 14
        
        let possibleGames = input
            .filter {
                $0.red.max()! <= maxRed
            }
            .filter {
                $0.green.max()! <= maxGreen
            }
            .filter {
                $0.blue.max()! <= maxBlue
            }
        
        var sum = 0
        for game in possibleGames {
            sum += game.id
        }
        
        return "\(sum)"
    }
    
    static func solvePart2(input: [Game]) -> String {
        var sum = 0
        
        for game in input {
            sum += game.power
        }
        
        return "\(sum)"
    }
}
