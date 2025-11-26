//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/15

// Note: Took 28.813812017440796 seconds

enum Day_15_2018: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2018
    
    enum UnitType: String {
        case goblin, elf
    }
    
    struct Pos: Hashable {
        var x, y: Int
        
        func distance(to other: Pos) -> Int {
            abs(x - other.x) + abs(y - other.y)
        }
        
        var desc: String {
            "(\(x),\(y))"
        }
    }
    
    class Unit: Equatable {
        static func == (lhs: Day_15_2018.Unit, rhs: Day_15_2018.Unit) -> Bool {
            lhs.pos == rhs.pos && lhs.type == rhs.type
        }
        
        let type: UnitType
        let initialPos: Pos
        var attackPower: Int
        var pos: Pos
        var hp: Int
        
        init(pos: Pos, type: UnitType) {
            self.pos = pos
            self.initialPos = pos
            self.type = type
            attackPower = 3
            hp = 200
        }
        
        var desc: String {
            "\(type == .goblin ? "G" : "E") \(hp) \(pos.desc)"
        }
        
        func reset() {
            hp = 200
            attackPower = 3
            pos = initialPos
        }
        
        func attack(_ other: Unit) -> Bool {
            other.hp -= attackPower
            return other.hp <= 0
        }
        
        func move(to pos: Pos) {
            self.pos = pos
        }
        
        func enemyInRange(_ units: [Unit], walls: Set<Pos>) -> Unit? {
            let enemies = units.filter { $0.type != type }
            let adjustedPos = [
                Pos(x: pos.x, y: pos.y - 1),
                Pos(x: pos.x, y: pos.y + 1),
                Pos(x: pos.x - 1, y: pos.y),
                Pos(x: pos.x + 1, y: pos.y)
            ].filter { !walls.contains($0) }
            
            var potentialTargets: [Unit] = []
            for pos in adjustedPos {
                if let unit = enemies.first(where: { $0.pos == pos }) {
                    potentialTargets.append(unit)
                }
            }
            
            potentialTargets.sort { ($0.hp, $0.pos.y, $0.pos.x) < ($1.hp, $1.pos.y, $1.pos.x) }
            
            return potentialTargets.first
        }
        
        func nextPosition(for units: [Unit], walls: Set<Pos>) -> Pos? {
            let enemies = units.filter { $0.type != type }
            let unitPos = Set(units.map { $0.pos })
            
            
            var reachable: [Pos: Int] = [:]
            for enemy in enemies {
                let adjustedPos = [
                    Pos(x: enemy.pos.x, y: enemy.pos.y - 1),
                    Pos(x: enemy.pos.x, y: enemy.pos.y + 1),
                    Pos(x: enemy.pos.x - 1, y: enemy.pos.y),
                    Pos(x: enemy.pos.x + 1, y: enemy.pos.y)
                ].filter { !walls.contains($0) }.filter { !unitPos.contains($0) }
                
                for adjusted in adjustedPos {
                    let path = aStar(
                        start: pos,
                        goal: adjusted,
                        heuristic: { $0.distance(to: adjusted) }
                    ) { current in
                            return [
                                Pos(x: current.x, y: current.y - 1),
                                Pos(x: current.x, y: current.y + 1),
                                Pos(x: current.x - 1, y: current.y),
                                Pos(x: current.x + 1, y: current.y)
                            ].filter { !walls.contains($0) }.filter { !unitPos.contains($0) }
                        }
                    
                    if let path = path {
                        reachable[adjusted] = path.count
                    }
                }
            }
            
            guard !reachable.isEmpty else { return nil }
            
            let minDistance = reachable.min(by: { $0.value < $1.value })!.value
            let nearest = reachable.filter { $0.value == minDistance }
            let chosen = nearest.sorted{($0.key.y, $0.key.x) < ($1.key.y, $1.key.x)}.first!
            
            let adjustedPos = [
                Pos(x: pos.x, y: pos.y - 1),
                Pos(x: pos.x, y: pos.y + 1),
                Pos(x: pos.x - 1, y: pos.y),
                Pos(x: pos.x + 1, y: pos.y)
            ].filter { !walls.contains($0) }.filter { !unitPos.contains($0) }
            
            
            var nextSteps: [Pos] = []
            
            for adjusted in adjustedPos {
                let path = aStar(
                    start: adjusted,
                    goal: chosen.key,
                    heuristic: { $0.distance(to: chosen.key) }
                ) { current in
                        return [
                            Pos(x: current.x, y: current.y - 1),
                            Pos(x: current.x, y: current.y + 1),
                            Pos(x: current.x - 1, y: current.y),
                            Pos(x: current.x + 1, y: current.y)
                        ].filter { !walls.contains($0) }.filter { !unitPos.contains($0) }
                    }
                
                if let path = path, path.count + 1 == minDistance {
                    nextSteps.append(adjusted)
                }
            }
            
            nextSteps.sort { ($0.y, $0.x) < ($1.y, $1.x) }
            return nextSteps.first
        }
    }
    
    static func convert(input: [String]) -> (units: [Unit], walls: Set<Pos>) {
        var units: [Unit] = []
        var walls: Set<Pos> = []
        var tiles: Set<Pos> = []
        
        for (y, row) in input.enumerated() {
            for (x, char) in row.enumerated() {
                switch char {
                case "G":
                    units.append(.init(pos: .init(x: x, y: y), type: .goblin))
                case "E":
                    units.append(.init(pos: .init(x: x, y: y), type: .elf))
                case "#":
                    walls.insert(.init(x: x, y: y))
                case ".":
                    tiles.insert(.init(x: x, y: y))
                default:
                    break
                }
            }
        }
        
        return (units, walls)
    }

    
    static var preComputedSteps: [String: Pos] = [:]

    static func solvePart1(input: (units: [Unit], walls: Set<Pos>)) -> String {
        let (units, rounds) = battle(with: input.units, and: input.walls)!
        let outcome = units.reduce(0) { $0 + $1.hp } * rounds
        
        return "\(outcome)"
    }

    static func solvePart2(input: (units: [Unit], walls: Set<Pos>)) -> String {
        var minAttackPower = 4
        var maxAttackPower = 100
        var newAttackPower = (maxAttackPower - minAttackPower) / 2 + minAttackPower
        var outcome = 0
        
        var checkedPowers: Set<Int> = []
        
        while true {
            if !checkedPowers.insert(newAttackPower).inserted {
                break
            }
            let cheatedUnits = input.units.map { unit in
                if unit.type == .elf {
                    unit.attackPower = newAttackPower
                }
                
                return unit
            }
            
            if let (units, rounds) = battle(with: cheatedUnits, and: input.walls, isPart2: true) {
                outcome = units.reduce(0) { $0 + $1.hp } * rounds
                maxAttackPower = newAttackPower
                newAttackPower = (maxAttackPower - minAttackPower) / 2 + minAttackPower
            } else {
                minAttackPower = newAttackPower
                newAttackPower = (maxAttackPower - minAttackPower) / 2 + minAttackPower
            }
            
            input.units.forEach { $0.reset() }
        }
        
        
        return "\(outcome)"
    }
    
    static func battle(with units: [Unit], and walls: Set<Pos>, isPart2: Bool = false) -> (units: [Unit], rounds: Int)? {
        var rounds = 0
        var units = units.sorted{ ($0.pos.y, $0.pos.x) < ($1.pos.y, $1.pos.x) }
        
        let elfsCount = units.count(where: { $0.type == .elf })
        var elfIsDead = false
        
    battleLoop:
        while true {
            var remainingUnits = units
            
            while !units.isEmpty {
                let currentUnit = units.removeFirst()
                
                if let enemy = currentUnit.enemyInRange(remainingUnits, walls: walls) {
                    let defeatEnemy = currentUnit.attack(enemy)
                    if defeatEnemy {
                        if let index = units.firstIndex(of: enemy) {
                            units.remove(at: index)
                        }
                        
                        remainingUnits.remove(at: remainingUnits.firstIndex(of: enemy)!)
                    }
                } else if let newPos = currentUnit.nextPosition(for: remainingUnits, walls: walls) {
                    currentUnit.move(to: newPos)
                    if let enemy = currentUnit.enemyInRange(remainingUnits, walls: walls) {
                        let defeatEnemy = currentUnit.attack(enemy)
                        if defeatEnemy {
                            if isPart2, enemy.type == .elf {
                                elfIsDead = true
                                break battleLoop
                            }
                            if let index = units.firstIndex(of: enemy) {
                                units.remove(at: index)
                            }
                            
                            remainingUnits.remove(at: remainingUnits.firstIndex(of: enemy)!)
                        }
                    }
                } else {
                    let remainingEnemies = remainingUnits.filter { $0.type != currentUnit.type }
                    if remainingEnemies.isEmpty {
                        units = remainingUnits.sorted{ ($0.pos.y, $0.pos.x) < ($1.pos.y, $1.pos.x)}
                        break battleLoop
                    }
                }
            }
            
            if isPart2, remainingUnits.count(where: { $0.type == .elf }) < elfsCount {
                return nil
            }
            
            units = remainingUnits.sorted{ ($0.pos.y, $0.pos.x) < ($1.pos.y, $1.pos.x)}
            rounds += 1
        }
        
        if isPart2, elfIsDead {
            return nil
        } else {
            return (units, rounds)
        }
    }
}
