//
//  Day_22.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/22

enum Day_22_2015: Solvable {
    static var day: Input.Day = .Day_22
    static var year: Input.Year = .Year_2015

    class Player {
        let name = "The Player"
        let maxHitpoints = 50
        let maxMana = 500
        var hitPoints: Int
        var mana: Int
        
        
        var usedMana = 0
        var armor = 0
        
        var poison = 0
        var recharge = 0
        var shield = 0

        init() {
            hitPoints = maxHitpoints
            mana = maxMana
        }

        func resetLife() {
            hitPoints = maxHitpoints
            mana = maxMana
            
            usedMana = 0
            armor = 0
            
            poison = 0
            recharge = 0
            shield = 0
        }
    }

    class Boss {
        let name = "The Boss"
        let maxHitpoints: Int
        var hitPoints: Int
        let damage: Int

        init(hitPoints: Int, damage: Int) {
            self.maxHitpoints = hitPoints
            self.hitPoints = hitPoints
            self.damage = damage
        }

        func resetLife() {
            hitPoints = maxHitpoints
        }
    }

    enum Spell: String, CaseIterable {
        case magicMissile, drain, shield, poison, recharge, nothing

        var coasts: Int {
            switch self {
            case .magicMissile:
                return 53
            case .drain:
                return 73
            case .shield:
                return 113
            case .poison:
                return 173
            case .recharge:
                return 229
            case .nothing:
                return 0
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        var bossStats: [Int] = []
        for line in input {
            bossStats.append(Int(line.components(separatedBy: " ").last ?? "") ?? 0)
        }
        let boss = Boss(
            hitPoints: bossStats[0],
            damage: bossStats[1]
        )
        let player = Player()

        var manaCoastsForWinning = Int.max

        
        for _ in 0...1000000 {
            if fight(player, against: boss) {
                manaCoastsForWinning = min(manaCoastsForWinning, player.usedMana)
            }
            
            player.resetLife()
            boss.resetLife()
        }

        return "\(manaCoastsForWinning)"
    }

    static func solvePart2(input: [String]) -> String {
        var bossStats: [Int] = []
        for line in input {
            bossStats.append(Int(line.components(separatedBy: " ").last ?? "") ?? 0)
        }
        let boss = Boss(
            hitPoints: bossStats[0],
            damage: bossStats[1]
        )
        let player = Player()

        var manaCoastsForWinning = Int.max

        
        for _ in 0...1000000 {
            if fight(player, against: boss, hardMode: true) {
                manaCoastsForWinning = min(manaCoastsForWinning, player.usedMana)
            }
            
            player.resetLife()
            boss.resetLife()
        }

        return "\(manaCoastsForWinning)"
    }
}

extension Day_22_2015 {
    static func chooseNextAttack(for player: Player) -> Spell {
        if player.mana < Spell.magicMissile.coasts {
            return.nothing
        }
        while true {
            let next = Int.random(in: 1...5)
            if next == 1 && player.mana >= Spell.magicMissile.coasts {
                return .magicMissile
            } else if next == 2 && player.mana >= Spell.drain.coasts {
                return .drain
            } else if next == 3 && player.mana >= Spell.shield.coasts && player.shield <= 1 {
                return .shield
            } else if next == 4 && player.mana >= Spell.poison.coasts && player.poison <= 1 {
                return .poison
            } else if next == 5 && player.mana >= Spell.recharge.coasts && player.recharge <= 1 {
                return .recharge
            }
        }
    }
    
    
    
    static func fight(_ player: Player, against boss: Boss, hardMode: Bool = false) -> Bool {
        var playersTurn = true
        var spell = Spell.nothing
        
        while true {
            if player.shield > 0 {
                player.shield -= 1
            }
            if player.shield == 0 {
                player.armor = 0
            }
            if player.poison > 0 {
                player.poison -= 1
                boss.hitPoints -= 3
            }
            if player.recharge > 0 {
                player.recharge -= 1
                player.mana += 101
            }
            if boss.hitPoints <= 0 {
                return true
            }
            if player.hitPoints <= 0 {
                return false
            }
            
            if playersTurn {
                if hardMode {
                    player.hitPoints -= 1
                    if player.hitPoints <= 0 {
                        return false
                    }
                }
                spell = chooseNextAttack(for: player)
                switch spell {
                case .magicMissile:
                    boss.hitPoints -= 4
                case .drain:
                    boss.hitPoints -= 2
                    player.hitPoints += 2
                case .shield:
                    player.shield = 6
                    player.armor = 7
                case .poison:
                    player.poison = 6
                case .recharge:
                    player.recharge = 5
                case .nothing:
                    return false
                }
                player.mana -= spell.coasts
                player.usedMana += spell.coasts
            } else {
                player.hitPoints -= max(1, (boss.damage - player.armor))
            }
            
            playersTurn.toggle()
        }
    }
        
}

