//
//  Day_5.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/5

enum Day_5_2018: Solvable {
    static var day: Input.Day = .Day_5
    static var year: Input.Year = .Year_2018
    
    static func solvePart1(input: [Character]) -> String {
        
        let resultingPolymer = reduction(of: input)
        return "\(resultingPolymer.count)"
    }
    
    static func solvePart2(input: [Character]) -> String {
        let letters: [Character] = ["a","b","c","d","e","f","g","h","j","k","m","n","p","q","r","s","t","u","v","w","x","y","z"]
        
        var minimalPolymer: [Character] = input
        
        for letter in letters {
            let reducedPolymer = String(input)
                .replacingOccurrences(of: String(letter), with: "")
                .replacingOccurrences(of: String(letter.uppercased()), with: "")
            
            let resultingPolymer = reduction(of: Array(reducedPolymer))
            
            if resultingPolymer.count < minimalPolymer.count {
                minimalPolymer = resultingPolymer
            }
        }

        return "\(minimalPolymer.count)"
    }
    
    static func reduction(of polymer: [Character]) -> [Character] {
        var resultingPolymer = polymer
        //print(resultingPolymer)
        var isReacting = true
        while isReacting {
            var newPolymer: [Character] = []
            let maxIndex = resultingPolymer.count-1
            var c = 0
            while c < maxIndex {
                let firstLetter = resultingPolymer[c]
                let secondLetter = resultingPolymer[c+1]
                
                if firstLetter.isLowercase, secondLetter.isUppercase, String(firstLetter) == secondLetter.lowercased() {
                    c += 2
                } else if firstLetter.isUppercase, secondLetter.isLowercase, String(firstLetter) == secondLetter.uppercased() {
                    c += 2
                } else {
                    newPolymer.append(firstLetter)
                    c += 1
                }
            }
            newPolymer.append(resultingPolymer[maxIndex])
            //print(newPolymer)
            isReacting = newPolymer.count != resultingPolymer.count
            resultingPolymer = newPolymer
        }
        
        return resultingPolymer
    }
}
