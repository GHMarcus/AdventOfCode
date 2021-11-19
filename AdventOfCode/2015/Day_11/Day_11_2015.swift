//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/11

enum Day_11_2015: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2015
    static let letters: [String.Element] = ["a","b","c","d","e","f","g","h","j","k","m","n","p","q","r","s","t","u","v","w","x","y","z"]
    static var newPassword = ""

    static func solvePart1(input: [String]) -> String {
        var pwd = Array(Array(input.first!).reversed())
        
        for i in 0..<pwd.count {
            let letter = pwd[i]
            if letter == "i" {
                pwd[i] = "j"
            } else if letter == "l" {
                pwd[i] = "m"
            } else if letter == "o" {
                pwd[i] = "p"
            }
        }
        
        while !applyRules(on: pwd) {
            var n = 0
            var changed = false
            while !changed {
                if pwd[n] == letters.last {
                    for i in 0...n {
                        pwd[i] = letters[0]
                    }
                    n += 1
                } else {
                    guard let index = letters.firstIndex(of: pwd[n]) else {
                        fatalError("Can not find letter: \(pwd[n])")
                    }

                    pwd[n] = letters[index+1]
                    changed = true
                }
            }
        }
        let newPwd = String(pwd.reversed())
        newPassword = newPwd
        return newPwd
    }

    static func solvePart2(input: [String]) -> String {
        var pwd = Array(Array(newPassword).reversed())
        
        var first = true
        
        while first || !applyRules(on: pwd) {
            first = false
            var n = 0
            var changed = false
            while !changed {
                if pwd[n] == letters.last {
                    for i in 0...n {
                        pwd[i] = letters[0]
                    }
                    n += 1
                } else {
                    guard let index = letters.firstIndex(of: pwd[n]) else {
                        fatalError("Can not find letter: \(pwd[n])")
                    }

                    pwd[n] = letters[index+1]
                    changed = true
                }
            }
        }
        let newPwd = String(pwd.reversed())
        newPassword = newPwd
        return newPwd
    }
}

extension Day_11_2015 {
    static func applyRules(on pwd: [String.Element]) -> Bool {
        let ruleOneApplied = applyRuleOne(on: pwd)
        let ruleTwoApplied = applyRuleTwo(on: pwd)
        let ruleThreeApplied = applyRuleThree(on: pwd)
        
        return ruleOneApplied && ruleTwoApplied && ruleThreeApplied
    }
    
    private static func applyRuleOne(on pwd: [String.Element]) -> Bool {
        let triplets = ["cba", "dcb", "edc", "fed", "gfe", "hgf", "rqp", "srq", "tsr", "uts", "vut", "wvu", "xwv", "yxw", "zyx"]
        
        let pwdStr = String(pwd)
        
        for triplet in triplets {
            if pwdStr.contains(triplet) {
                return true
            }
        }
        
        return false
    }
    private static func applyRuleTwo(on pwd: [String.Element]) -> Bool {
        !pwd.contains { $0 == "i" || $0 == "o" || $0 == "l" }
    }
    private static func applyRuleThree(on pwd: [String.Element]) -> Bool {
        let pairSet = ["aa","bb","cc","dd","ee","ff","gg","hh","jj","kk","mm","nn","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz"]
        
        let pwdStr = String(pwd)
        var pairs = 0
        
        for pair in pairSet {
            if pwdStr.contains(pair) {
                pairs += 1            }
        }
        
        return pairs >= 2
    }
}
