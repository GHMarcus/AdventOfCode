//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/16

enum Day_16_2015: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2015
    
    class AuntSue {
        let number: Int
        var matches: Int = 0
        var compounds: [String: Int?] = [:]
        
        init(number: Int, matches: Int = 0, compounds: [String : Int?] = [:]) {
            self.number = number
            self.matches = matches
            self.compounds = compounds
        }
        
        func addCompound(_ compound: String, value: Int) {
            compounds[compound] = value
        }
        
        func match() {
            matches += 1
        }
    }
    
    static func solvePart1(input: [String]) -> String {
        var aunts = convertInputToAntSues(input)
        
        let searchingAunt = AuntSue(
            number: 0,
            matches: 0,
            compounds: [
                "children": 3,
                "cats": 7,
                "samoyeds": 2,
                "pomeranians": 3,
                "akitas": 0,
                "vizslas": 0,
                "goldfish": 5,
                "trees": 3,
                "cars": 2,
                "perfumes": 1
            ])
        
        for aunt in aunts {
            for compound in aunt.compounds {
                guard let searchedValue = searchingAunt.compounds[compound.key] else { continue }
                if searchedValue == compound.value {
                    aunt.match()
                }
            }
        }
        
        aunts.sort { $0.matches > $1.matches }
        
        return "\(aunts[0].number)"
    }

    static func solvePart2(input: [String]) -> String {
        var aunts = convertInputToAntSues(input)
        
        let searchingAunt = AuntSue(
            number: 0,
            matches: 0,
            compounds: [
                "children": 3,
                "cats": 7,
                "samoyeds": 2,
                "pomeranians": 3,
                "akitas": 0,
                "vizslas": 0,
                "goldfish": 5,
                "trees": 3,
                "cars": 2,
                "perfumes": 1
            ])
        
        for aunt in aunts {
            for compound in aunt.compounds {
                guard let searchedValue = searchingAunt.compounds[compound.key] else { continue }
                
                switch compound.key {
                case "cats", "trees":
                    if searchedValue ?? 0 < compound.value ?? 0 {
                        aunt.match()
                    }
                case "pomeranians", "goldfish":
                    if searchedValue ?? 0 > compound.value ?? 0 {
                        aunt.match()
                    }
                default:
                    if searchedValue == compound.value {
                        aunt.match()
                    }
                }
            }
        }
        
        aunts.sort { $0.matches > $1.matches }
        
        return "\(aunts[0].number)"
    }
}

extension Day_16_2015 {
        static func convertInputToAntSues(_ input: [String]) -> [AuntSue] {
            var aunts: [AuntSue] = []
            
            // Sue 1: goldfish: 9, cars: 0, samoyeds: 9
            // Sue 1 goldfish 9 cars 0 samoyeds 9
            for line in input {
                let components = line
                    .replacingOccurrences(of: ":", with: "")
                    .replacingOccurrences(of: ",", with: "")
                    .components(separatedBy: " ")
                
                let aunt = AuntSue(number: Int(components[1]) ?? 0)
                
                let numberOfCompounds = (components.count - 2) / 2
                
                for i in 1...numberOfCompounds {
                    aunt.addCompound(components[i*2], value: Int(components[i*2+1]) ?? 0)
                }
                
                aunts.append(aunt)
                
            }
            
            return aunts
        }
}
