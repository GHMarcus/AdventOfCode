//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/13

enum Day_13_2024: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Game]
    
    struct Button {
        let dx, dy, coast: Int
    }
    
    struct Game {
        let buttons: [Button]
        var goal: (Int, Int)
    }
    
    static func convert(input: [String]) -> ConvertedInput {
        var games: [Game] = []
        for game in input.filter({ !$0.isEmpty }).chunked(into: 3) {
            let game = game.map { $0.components(separatedBy: ": ")[1].components(separatedBy: ", ").map { $0.dropFirst(2) } }
            let buttonA = Button(dx: Int(game[0][0])!, dy: Int(game[0][1])!, coast: 3)
            let buttonB = Button(dx: Int(game[1][0])!, dy: Int(game[1][1])!, coast: 1)
            let goal = (Int(game[2][0])!, Int(game[2][1])!)
            
            games.append(Game(buttons: [buttonA, buttonB], goal: goal))
        }
        
        return games
    }
    
    
    
    static func solvePart1(input: ConvertedInput) -> String {
        var totalCoast = 0
        
        for g in 0..<input.count {
            let game = input[g]
            let presses = calcButtonPresses(game)
            let coast = zip(presses, game.buttons).reduce(into: 0) { $0 += $1.0 * $1.1.coast }
            totalCoast += coast
        }
        
        return "\(totalCoast)"
    }
    
    static func solvePart2(input: ConvertedInput) -> String {
        var totalCoast = 0
        
        for g in 0..<input.count {
            var game = input[g]
            game.goal = (game.goal.0 + 10000000000000, game.goal.1 + 10000000000000)
            let presses = calcButtonPresses(game)
            let coast = zip(presses, game.buttons).reduce(into: 0) { $0 += $1.0 * $1.1.coast }
            totalCoast += coast
        }
        
        return "\(totalCoast)"
    }
    
    
    // Use this to equations to calculate the button presses
    // I : a*dxa + b*dxb = gx
    // II: a*dya + b*dyb = gy
    // with:
    // a = button A presses
    // b = button B presses
    // dxa, dya = X,Y changes from button A
    // dxb, dyb = X,Y changes from button B
    // gx, gy = goal position
    // Note: We will get an result for every game, but because we have to count presses and we can not press se button 0.7 times
    //       we have to find the whole numbers
    static func calcButtonPresses(_ game: Game) -> [Int] {
        let b = calcBButtonPresses(game)
        let a = calcAButtonPresses(game, b: b)
        
        // This is needed because sth. like 20.00000000001 ist also 20 or 19.99999999998
        if a.round(to: 3).isInt && b.round(to: 3).isInt {
            return [Int(a.round(to: 0)), Int(b.round(to: 0))]
        } else {
            return []
        }
    }
    
    static func calcBButtonPresses(_ game: Game) -> Double {
        let dxa = Double(game.buttons[0].dx)
        let dya = Double(game.buttons[0].dy)
        let dxb = Double(game.buttons[1].dx)
        let dyb = Double(game.buttons[1].dy)
        let gx = Double(game.goal.0)
        let gy = Double(game.goal.1)
        
        return (gy - (gx*dya/dxa)) * (dxa/(dyb*dxa-dxb*dya))
    }
    
    static func calcAButtonPresses(_ game: Game, b: Double) -> Double {
        let dxa = Double(game.buttons[0].dx)
        let dxb = Double(game.buttons[1].dx)
        let gx = Double(game.goal.0)
        
        return (gx/dxa - b*dxb/dxa)
    }
}
