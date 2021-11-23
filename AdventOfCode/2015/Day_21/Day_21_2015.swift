//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/21

enum Day_21_2015: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2015
    
    struct Inventory: Hashable {
        let weapon: Item
        let armor: Item?
        let leftRing: Item?
        let rightRing: Item?
        
        var description: String {
            "coasts: \(totalCoasts), weapon: \(weapon.name), armor: \(armor?.name ?? ""), leftRing: \(leftRing?.name ?? ""), rightRing: \(rightRing?.name ?? "")"
        }
        
        var totalCoasts: Int {
            weapon.coast + (armor?.coast ?? 0) + (leftRing?.coast ?? 0) + (rightRing?.coast ?? 0)
        }
        
        var totalDamage: Int {
            weapon.damage + (leftRing?.damage ?? 0) + (rightRing?.damage ?? 0)
        }
        
        var totalArmor: Int {
            (armor?.armor ?? 0) + (leftRing?.armor ?? 0) + (rightRing?.armor ?? 0)
        }
    }
    
    struct Item: Hashable {
        let name: String
        let coast: Int
        let damage: Int
        let armor: Int
    }
    
    struct Shop {
        let weapons = [
            Item(name: "Dagger", coast: 8, damage: 4, armor: 0),
            Item(name: "Shortsword", coast: 10, damage: 5, armor: 0),
            Item(name: "Warhammer", coast: 25, damage: 6, armor: 0),
            Item(name: "Longsword", coast: 40, damage: 7, armor: 0),
            Item(name: "Greataxe", coast: 74, damage: 8, armor: 0)
        ]
        let armors = [
            Item(name: "Leather", coast: 13, damage: 0, armor: 1),
            Item(name: "Chainmail", coast: 31, damage: 0, armor: 2),
            Item(name: "Splintmail", coast: 53, damage: 0, armor: 3),
            Item(name: "Bandedmail", coast: 75, damage: 0, armor: 4),
            Item(name: "Platemail", coast: 102, damage: 0, armor: 5),
            nil
        ]
        let rings = [
            Item(name: "Damage +1", coast: 25, damage: 1, armor: 0),
            Item(name: "Damage +2", coast: 50, damage: 2, armor: 0),
            Item(name: "Damage +3", coast: 100, damage: 3, armor: 0),
            Item(name: "Defense +1", coast: 20, damage: 0, armor: 1),
            Item(name: "Defense +2", coast: 40, damage: 0, armor: 2),
            Item(name: "Defense +3", coast: 80, damage: 0, armor: 3),
            nil,
            nil
        ]
        
        func generateAllPossibleInventories() -> [Inventory] {
            var inventories: Set<Inventory> = []
            
            for weapon in weapons {
                for armor in armors {
                    for left_ring in rings {
                        for right_ring in rings {
                            inventories.insert(Inventory(weapon: weapon, armor: armor, leftRing: left_ring, rightRing: right_ring))
                        }
                    }
                }
            }
            
            return inventories.unique()
                .filter { inventory in
                    guard let left = inventory.leftRing,
                          let right = inventory.rightRing
                    else { return true }

                    return left != right
                }
        }
    }
    
    class Player {
        let name = "The Player"
        let maxHitpoints = 100
        var hitPoints: Int
        var inventory: Inventory
        
        init() {
            hitPoints = maxHitpoints
            inventory = Inventory(
                weapon: Item(name: "ExampleWeapon", coast: 1, damage: 5, armor: 0),
                armor: Item(name: "ExampleArmor", coast: 1, damage: 0, armor: 5),
                leftRing: nil,
                rightRing: nil
            )
        }
        
        func resetLife() {
            hitPoints = maxHitpoints
        }
    }
    
    class Boss {
        let name = "The Boss"
        let maxHitpoints: Int
        var hitPoints: Int
        let damage: Int
        let armor: Int
        
        init(hitPoints: Int, damage: Int, armor: Int) {
            self.maxHitpoints = hitPoints
            self.hitPoints = hitPoints
            self.damage = damage
            self.armor = armor
        }
        
        func resetLife() {
            hitPoints = maxHitpoints
        }
    }

    static func solvePart1(input: [String]) -> String {
        var bossStats: [Int] = []
        for line in input {
            bossStats.append(Int(line.components(separatedBy: " ").last ?? "") ?? 0)
        }
        let boss = Boss(
            hitPoints: bossStats[0],
            damage: bossStats[1],
            armor: bossStats[2]
        )
        let shop = Shop()
        let player = Player()
        
        var coastsOfWinningInventory = 0
        
        for inventory in shop.generateAllPossibleInventories().sorted(by: { $0.totalCoasts < $1.totalCoasts }) {
            player.inventory = inventory
            if fight(player, against: boss) {
                coastsOfWinningInventory = inventory.totalCoasts
                break
            }
            player.resetLife()
            boss.resetLife()
        }
        
        return "\(coastsOfWinningInventory)"
    }

    static func solvePart2(input: [String]) -> String {
        var bossStats: [Int] = []
        for line in input {
            bossStats.append(Int(line.components(separatedBy: " ").last ?? "") ?? 0)
        }
        let boss = Boss(
            hitPoints: bossStats[0],
            damage: bossStats[1],
            armor: bossStats[2]
        )
        let shop = Shop()
        let player = Player()
        
        var coastsOfLosingInventory = 0
        
        for inventory in shop.generateAllPossibleInventories().sorted(by: { $0.totalCoasts > $1.totalCoasts }) {
            player.inventory = inventory
            if !fight(player, against: boss) {
                coastsOfLosingInventory = inventory.totalCoasts
                break
            }
            player.resetLife()
            boss.resetLife()
        }
        
        return "\(coastsOfLosingInventory)"
    }
}

extension Day_21_2015 {
    static func fight(_ player: Player, against boss: Boss) -> Bool {
        var playersTurn = true
        var playersDamage = player.inventory.totalDamage - boss.armor
        if playersDamage <= 0 {
            playersDamage = 1
        }
        var bossDamage = boss.damage - player.inventory.totalArmor
        if bossDamage <= 0 {
            bossDamage = 1
        }
        
        while player.hitPoints > 0 && boss.hitPoints > 0 {
            if playersTurn {
                boss.hitPoints -= playersDamage
                playersTurn = false
            } else {
                player.hitPoints -= bossDamage
                playersTurn = true
            }
        }
        return player.hitPoints > 0
    }
}
