//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/13

enum Day_13_2015: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2015
    
    struct Person {
        let name: String
        var neighbours: [Neighbour] = []
        
        mutating func addNeighbour(_ neighbour: Neighbour) {
            neighbours.append(neighbour)
        }
    }
    
    struct Neighbour {
        let name: String
        let happiness: Int
    }

    static func solvePart1(input: [String]) -> String {
        let persons = convertInputToPersons(input)
        
        let possibleSittingOrders = permutations(xs: persons.map({ $0.name }))
    
        var happinessPerSittingOrder: [Int] = []
        
        for order in possibleSittingOrders {
            var happiness = 0
            for i in 0..<order.count {
                let person = persons.first { $0.name == order[i] }
                if i == 0 {
                    happiness += person?.neighbours.first(where: { $0.name == order[1] })?.happiness ?? 0
                    happiness += person?.neighbours.first(where: { $0.name == order[order.count - 1] })?.happiness ?? 0
                } else if i == order.count - 1 {
                    happiness += person?.neighbours.first(where: { $0.name == order[0] })?.happiness ?? 0
                    happiness += person?.neighbours.first(where: { $0.name == order[i - 1] })?.happiness ?? 0
                } else {
                    happiness += person?.neighbours.first(where: { $0.name == order[i + 1] })?.happiness ?? 0
                    happiness += person?.neighbours.first(where: { $0.name == order[i - 1] })?.happiness ?? 0
                }
            }
            happinessPerSittingOrder.append(happiness)
        }
        
        return "\(happinessPerSittingOrder.max() ?? 0)"
    }

    static func solvePart2(input: [String]) -> String {
        var persons = convertInputToPersons(input)
        
        var myself = Person(name: "Myself")
        
        for person in persons {
            myself.addNeighbour(Neighbour(name: person.name, happiness: 0))
        }
        
        persons.append(myself)

        let possibleSittingOrders = permutations(xs: persons.map({ $0.name }))
    
        var happinessPerSittingOrder: [Int] = []
        
        for order in possibleSittingOrders {
            var happiness = 0
            for i in 0..<order.count {
                let person = persons.first { $0.name == order[i] }
                if i == 0 {
                    happiness += person?.neighbours.first(where: { $0.name == order[1] })?.happiness ?? 0
                    happiness += person?.neighbours.first(where: { $0.name == order[order.count - 1] })?.happiness ?? 0
                } else if i == order.count - 1 {
                    happiness += person?.neighbours.first(where: { $0.name == order[0] })?.happiness ?? 0
                    happiness += person?.neighbours.first(where: { $0.name == order[i - 1] })?.happiness ?? 0
                } else {
                    happiness += person?.neighbours.first(where: { $0.name == order[i + 1] })?.happiness ?? 0
                    happiness += person?.neighbours.first(where: { $0.name == order[i - 1] })?.happiness ?? 0
                }
            }
            happinessPerSittingOrder.append(happiness)
        }
        
        return "\(happinessPerSittingOrder.max() ?? 0)"
    }
}

extension Day_13_2015 {
    static func convertInputToPersons(_ input: [String]) -> [Person] {
        var persons: [Person] = []
        var currentPerson = ""
        for line in input {
            let components = line.replacingOccurrences(of: ".", with: "").components(separatedBy: " ")
            let name = components[0]
            if currentPerson != name {
                currentPerson = name
                var person = Person(name: name)

                let happiness = Int(components[3])!
                let isPositive = components[2] == "gain"
                
                let neighbour = Neighbour(
                    name: components.last!,
                    happiness: isPositive ? happiness : (-1 * happiness)
                )
                person.addNeighbour(neighbour)
                persons.append(person)
            } else {
                let index = persons.firstIndex { $0.name == name }!
                var person = persons[index]
                let happiness = Int(components[3])!
                let isPositive = components[2] == "gain"
                
                let neighbour = Neighbour(
                    name: components.last!,
                    happiness: isPositive ? happiness : (-1 * happiness)
                )
                person.addNeighbour(neighbour)
                persons[index] = person
            }
        }
        
        return persons
    }
}
