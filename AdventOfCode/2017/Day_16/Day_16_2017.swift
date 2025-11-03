//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/16

enum Day_16_2017: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2017
    
    
    enum DanceMove {
        case spin(Int)
        case exchange(Int, Int)
        case partner(String, String)
        
        func dance(at state: [String]) -> [String] {
            var state = state
            switch self {
            case .spin(let n):
                for _ in 0..<n {
                    state.insert(state.removeLast(), at: 0)
                }
            case .exchange(let x, let y):
                let tmp = state[x]
                state[x] = state[y]
                state[y] = tmp
            case .partner(let a, let b):
                let x = state.firstIndex(of: a)!
                let y = state.firstIndex(of: b)!
                let tmp = state[x]
                state[x] = state[y]
                state[y] = tmp
            }
            return state
        }
    }
    
    static func convert(input: [String]) -> [DanceMove] {
        var moves: [DanceMove] = []
        for var move in input.first!.components(separatedBy: ",") {
            let type = move.removeFirst()
            switch type {
            case "s":
                moves.append(.spin(Int(move)!))
            case "x":
                let parts = move.components(separatedBy: "/")
                moves.append(.exchange(Int(parts[0])!, Int(parts[1])!))
            case "p":
                let parts = move.components(separatedBy: "/")
                moves.append(.partner(parts[0], parts[1]))
            default:
                fatalError()
            }
        }
        
        return moves
    }

    static func solvePart1(input: [DanceMove]) -> String {
        var party = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
        
        for move in input {
            party = move.dance(at: party)
        }
        
        return party.joined()
    }

    static func solvePart2(input: [DanceMove]) -> String {
        let maxRounds = 1_000_000_000
        var initialParty = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
        var party = initialParty
        
        var prevParties: Set<String> = []
        
        for _ in 0..<maxRounds {
            if !prevParties.insert(party.joined()).inserted {
                break
            }
            for move in input {
                party = move.dance(at: party)
            }
        }
        
        for _ in 0..<(maxRounds % prevParties.count) {
            for move in input {
                initialParty = move.dance(at: initialParty)
            }
        }
        
        return initialParty.joined()
    }
}
