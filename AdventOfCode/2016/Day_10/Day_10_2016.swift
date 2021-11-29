//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/10

enum Day_10_2016: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2016
    
    enum NextType: String {
        case bot, output
    }
    
    class Bot {
        let number: String
        var chips: [Int] = []
        var low: (NextType, String)
        var high: (NextType, String)
        
        init(number: String) {
            self.number = number
            low = (.bot, number)
            high = (.bot, number)
        }
        
        func describe() {
            print("Bot #\(number)")
            print("Chips: \(chips)")
            print("Low -> \(low.0.rawValue) #\(low.1)")
            print("High -> \(high.0.rawValue) #\(high.1)")
            print()
        }
    }

    static func solvePart1(input: [String]) -> String {
        var bots: [Bot] = []
        for line in input {
            let comps = line.components(separatedBy: " ")
            
            // value 5 goes to bot 2
            if comps[0] == "value" {
                if let bot = bots.first(where: { $0.number == comps[5] }) {
                    bot.chips.append(Int(comps[1])!)
                } else {
                    let newBot = Bot(number: comps[5])
                    newBot.chips.append(Int(comps[1])!)
                    bots.append(newBot)
                }
            } else {
                // bot 2 gives low to bot 1 and high to bot 0
                // bot 1 gives low to output 1 and high to bot 0
                if let bot = bots.first(where: { $0.number == comps[1] }) {
                    if comps[5] == "bot" {
                        bot.low = (.bot, comps[6])
                    } else {
                        bot.low = (.output, comps[6])
                    }
                    
                    if comps[10] == "bot" {
                        bot.high = (.bot, comps[11])
                    } else {
                        bot.high = (.output, comps[11])
                    }
                } else {
                    let newBot = Bot(number: comps[1])
                    if comps[5] == "bot" {
                        newBot.low = (.bot, comps[6])
                    } else {
                        newBot.low = (.output, comps[6])
                    }
                    
                    if comps[10] == "bot" {
                        newBot.high = (.bot, comps[11])
                    } else {
                        newBot.high = (.output, comps[11])
                    }
                    bots.append(newBot)
                }
            }
        }
        
        var number = ""
    program: while true {
        for bot in bots {
            if bot.chips.sorted(by: <) == [17,61] {
                number = bot.number
                break program
            }
            
        }
        for bot in bots {
            if bot.chips.count == 2 {
                bot.chips.sort(by: <)
                if bot.low.0 == .bot {
                    let chip = bot.chips.removeFirst()
                    bots.first { $0.number == bot.low.1}!.chips.append(chip)
                } else {
                    bot.chips.removeFirst()
                }
                if bot.high.0 == .bot {
                    let chip = bot.chips.removeLast()
                    bots.first { $0.number == bot.high.1}!.chips.append(chip)
                } else {
                    bot.chips.removeLast()
                }
            }
        }
    }
        
        return number
    }
    
    static func solvePart2(input: [String]) -> String {
        var bots: [Bot] = []
        for line in input {
            let comps = line.components(separatedBy: " ")
            
            // value 5 goes to bot 2
            if comps[0] == "value" {
                if let bot = bots.first(where: { $0.number == comps[5] }) {
                    bot.chips.append(Int(comps[1])!)
                } else {
                    let newBot = Bot(number: comps[5])
                    newBot.chips.append(Int(comps[1])!)
                    bots.append(newBot)
                }
            } else {
                // bot 2 gives low to bot 1 and high to bot 0
                // bot 1 gives low to output 1 and high to bot 0
                if let bot = bots.first(where: { $0.number == comps[1] }) {
                    if comps[5] == "bot" {
                        bot.low = (.bot, comps[6])
                    } else {
                        bot.low = (.output, comps[6])
                    }
                    
                    if comps[10] == "bot" {
                        bot.high = (.bot, comps[11])
                    } else {
                        bot.high = (.output, comps[11])
                    }
                } else {
                    let newBot = Bot(number: comps[1])
                    if comps[5] == "bot" {
                        newBot.low = (.bot, comps[6])
                    } else {
                        newBot.low = (.output, comps[6])
                    }
                    
                    if comps[10] == "bot" {
                        newBot.high = (.bot, comps[11])
                    } else {
                        newBot.high = (.output, comps[11])
                    }
                    bots.append(newBot)
                }
            }
        }
        
        var sum = 1
        
        var output_0: Int?
        var output_1: Int?
        var output_2: Int?
        
        
        
    program: while true {
            if output_0 != nil && output_1 != nil && output_2 != nil {
                sum = output_0! * output_1! * output_2!
                break program
            }
    
        for bot in bots {
            if bot.chips.count == 2 {
                bot.chips.sort(by: <)
                let lowChip = bot.chips.removeFirst()
                let highChip = bot.chips.removeLast()
                
                if bot.low.0 == .bot {
                    bots.first { $0.number == bot.low.1}!.chips.append(lowChip)
                } else {
                    if bot.low.1 == "0" {
                        output_0 = lowChip
                    } else if bot.low.1 == "1" {
                        output_1 = lowChip
                    } else if bot.low.1 == "2" {
                        output_2 = lowChip
                    }
                }
                if bot.high.0 == .bot {
                    bots.first { $0.number == bot.high.1}!.chips.append(highChip)
                } else {
                    if bot.high.1 == "0" {
                        output_0 = highChip
                    } else if bot.high.1 == "1" {
                        output_1 = highChip
                    } else if bot.high.1 == "2" {
                        output_2 = highChip
                    }
                }
            }
        }
    }
        
        return "\(sum)"
    }
}
