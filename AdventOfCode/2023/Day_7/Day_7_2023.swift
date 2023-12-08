//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/7

enum Day_7_2023: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2023
    
    enum Card: Character {
        case cA = "A"
        case cK = "K"
        case cQ = "Q"
        case cJ = "J"
        case cT = "T"
        case c9 = "9"
        case c8 = "8"
        case c7 = "7"
        case c6 = "6"
        case c5 = "5"
        case c4 = "4"
        case c3 = "3"
        case c2 = "2"
        
        var value: Int {
            switch self {
            case .c2:
                return 2
            case .c3:
                return 3
            case .c4:
                return 4
            case .c5:
                return 5
            case .c6:
                return 6
            case .c7:
                return 7
            case .c8:
                return 8
            case .c9:
                return 9
            case .cT:
                return 10
            case .cJ:
                return 11
            case .cQ:
                return 12
            case .cK:
                return 13
            case .cA:
                return 14
            }
        }
        
        var valueWithJoker: Int {
            switch self {
            case .cJ:
                return 1
            case .c2:
                return 2
            case .c3:
                return 3
            case .c4:
                return 4
            case .c5:
                return 5
            case .c6:
                return 6
            case .c7:
                return 7
            case .c8:
                return 8
            case .c9:
                return 9
            case .cT:
                return 10
            case .cQ:
                return 11
            case .cK:
                return 12
            case .cA:
                return 13
            }
        }
    }
    
    enum Value: Int {
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind
        
        static func getValue(of cards: [Card], haveJoker: Bool) -> Value {
            let sortedCards: [(key: Card, value: Int)]
            
            if haveJoker {
                sortedCards = cards.filter { $0 != .cJ }.countedElements.sorted { $0.value > $1.value }
            } else {
                sortedCards = cards.countedElements.sorted { $0.value > $1.value }
            }

            var regularValue: Value = .highCard
            if !sortedCards.isEmpty {
                if sortedCards[0].value == 5 {
                    regularValue = .fiveOfAKind
                } else if sortedCards[0].value == 4 {
                    regularValue = .fourOfAKind
                } else if sortedCards[0].value == 3 && sortedCards.count > 1 && sortedCards[1].value == 2 {
                    regularValue = .fullHouse
                } else if sortedCards[0].value == 3 {
                    regularValue = .threeOfAKind
                } else if sortedCards[0].value == 2 && sortedCards.count > 1 && sortedCards[1].value == 2 {
                    regularValue = .twoPair
                } else  if sortedCards[0].value == 2 {
                    regularValue = .onePair
                } else {
                    regularValue = .highCard
                }
            }
            
            if haveJoker {
                let jokers = cards.filter { $0 == .cJ }
                regularValue = regularValue.convert(with: jokers)
            }
            
            return regularValue
        }
        
        func convert(with jokers: [Card]) -> Value {
            if jokers.isEmpty {
                return self
            } else if jokers.count == 5 {
                return .fiveOfAKind
            } else {
                switch self {
                case .highCard:
                    switch jokers.count {
                    case 1: return .onePair
                    case 2: return .threeOfAKind
                    case 3: return .fourOfAKind
                    case 4: return .fiveOfAKind
                    default: fatalError()
                    }
                case .onePair:
                    switch jokers.count {
                    case 1: return .threeOfAKind
                    case 2: return .fourOfAKind
                    case 3: return .fiveOfAKind
                    default: fatalError()
                    }
                case .twoPair:
                    switch jokers.count {
                    case 1: return .fullHouse
                    default: fatalError()
                    }
                case .threeOfAKind:
                    switch jokers.count {
                    case 1: return .fourOfAKind
                    case 2: return .fiveOfAKind
                    default: fatalError()
                    }
                case .fullHouse:
                    fatalError()
                case .fourOfAKind:
                    switch jokers.count {
                    case 1: return .fiveOfAKind
                    default: fatalError()
                    }
                case .fiveOfAKind:
                    fatalError()
                }
            }
        }
    }
    
    struct Hand {
        let bit: Int
        let cards: [Card]
        
        func getStrength(withJokers: Bool = false) -> Int {
            var value = Value.getValue(of: cards, haveJoker: withJokers).rawValue * 10000000000
            value += cards[0].value                                               *   100000000
            value += cards[1].value                                               *     1000000
            value += cards[2].value                                               *       10000
            value += cards[3].value                                               *         100
            value += cards[4].value
            return value
        }
    }
    
    static func convert(input: [String]) -> [Hand] {
        var hands: [Hand] = []
        for line in input {
            let cmp = line.components(separatedBy: " ")
            let cards = Array(cmp[0]).compactMap { Card(rawValue: $0) }
            hands.append(Hand(bit: Int(cmp[1])!, cards: cards))
        }
        
        return hands
    }

    static func solvePart1(input: [Hand]) -> String {
        let rankedHands = input.sorted { $0.getStrength() < $1.getStrength() }
        
        var sum = 0
        for (index, hand) in rankedHands.enumerated() {
            sum += hand.bit * (index + 1)
        }
        
        return "\(sum)"
    }

    static func solvePart2(input: [Hand]) -> String {
        let rankedHands = input.sorted { $0.getStrength(withJokers: true) < $1.getStrength(withJokers: true) }
        
        var sum = 0
        for (index, hand) in rankedHands.enumerated() {
            sum += hand.bit * (index + 1)
        }
        
        return "\(sum)"
    }
}
