//
//  Day_12.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/12

enum Day_12_2015: Solvable {
    static var day: Input.Day = .Day_12
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","{","}","[","]","\""]
        var line = input.first!
        
        for c in letters {
            line = line.replacingOccurrences(of: c, with: "")
        }
        
        line = line.replacingOccurrences(of: ",", with: " ").replacingOccurrences(of: ":", with: " ")
        
        
        let characters = Array(line)
        var current = ""
        var sum = 0
        for c in characters {
            if c == " " && !current.isEmpty {
                sum += Int(current) ?? 0
                current = ""
            } else if c != " " {
                current.append(c)
            }
        }
        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        enum Art {
            case object, array, none
        }
        
        let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","\""]
        var line = input.first!
        
        line = line.replacingOccurrences(of: "red", with: "*")
        
        for c in letters {
            line = line.replacingOccurrences(of: c, with: "")
        }
        
        line = line.replacingOccurrences(of: ",", with: " ").replacingOccurrences(of: ":", with: " ")
        var characters = Array(line)
        var starIndex: [Int] = findAllStars(in: characters)
        
        while starIndex.count > 0 {
            let index = starIndex.first!
            var closingArrayPassed = 0
            var closingObjectPassed = 0
            var openingObjectsPassed = 0
            
        outerLoop: for i in (0..<index).reversed() {
                if characters[i] == "[" {
                    if closingArrayPassed > 0 {
                        closingArrayPassed -= 1
                        continue
                    } else {
                        characters[index] = " "
                        break outerLoop
                    }
                } else if characters[i] == "{" {
                    if closingObjectPassed > 0 {
                        closingObjectPassed -= 1
                        continue
                    } else {
                        for n in index..<characters.count {
                            if characters[n] == "}" {
                                if openingObjectsPassed > 0 {
                                    openingObjectsPassed -= 1
                                } else {
                                    for x in (i+1)..<n {
                                        characters[x] = " "
                                    }
                                    break outerLoop
                                }
                            } else if characters[n] == "{" {
                                openingObjectsPassed += 1
                            }
                        }
                    }
                } else if characters[i] == "]" {
                    closingArrayPassed += 1
                } else if characters[i] == "}" {
                    closingObjectPassed += 1
                }
            }
            
            starIndex = findAllStars(in: characters)
        }
        
        
        line = String(characters)
            .replacingOccurrences(of: "{", with: " ")
            .replacingOccurrences(of: "}", with: " ")
            .replacingOccurrences(of: "[", with: " ")
            .replacingOccurrences(of: "]", with: " ")
        characters = Array(line)
        var current = ""
        var sum = 0
        for c in characters {
            if c == " " && !current.isEmpty {
                sum += Int(current) ?? 0
                current = ""
            } else if c != " " {
                current.append(c)
            }
        }
        return "\(sum)"
    }
}

extension Day_12_2015 {
    static func findAllStars(in characters: [String.Element]) -> [Int] {
        var starIndex: [Int] = []
        for i in 0..<characters.count {
            if characters[i] == "*" {
                starIndex.append(i)
            }
        }
        return starIndex
    }
}
