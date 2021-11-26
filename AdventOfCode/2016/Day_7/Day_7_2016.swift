//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/7

enum Day_7_2016: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2016

    static func solvePart1(input: [String]) -> String {
        var supernetSequences: [[String]] = []
        var hypernetSequences: [[String]] = []
        
        for line in input.map({Array($0)}) {
            var supernet: [String] = []
            var hypernet: [String] = []
            var str = ""
            for letter in line {
                if letter == "[" {
                    supernet.append(str)
                    str = ""
                } else if letter == "]" {
                    hypernet.append(str)
                    str = ""
                } else {
                    str.append(letter)
                }
            }
            supernet.append(str)
            supernetSequences.append(supernet)
            hypernetSequences.append(hypernet)
        }
        
        var numberOFTlsIps = 0
        
        for i in 0..<supernetSequences.count {
            var isTlsIp = false
            for string in supernetSequences[i] {
                if string.isSupportingABBA {
                    isTlsIp = true
                    break
                }
            }

            for string in hypernetSequences[i] {
                if string.isSupportingABBA {
                    isTlsIp = false
                    break
                }
            }

            if isTlsIp {
                numberOFTlsIps += 1
            }
        }
        
        
        return "\(numberOFTlsIps)"
    }

    static func solvePart2(input: [String]) -> String {
        var supernetSequences: [[String]] = []
        var hypernetSequences: [[String]] = []
        
        for line in input.map({Array($0)}) {
            var supernet: [String] = []
            var hypernet: [String] = []
            var str = ""
            for letter in line {
                if letter == "[" {
                    supernet.append(str)
                    str = ""
                } else if letter == "]" {
                    hypernet.append(str)
                    str = ""
                } else {
                    str.append(letter)
                }
            }
            supernet.append(str)
            supernetSequences.append(supernet)
            hypernetSequences.append(hypernet)
        }
        
        var numberOFSslIps = 0
        
        for i in 0..<supernetSequences.count {
            if supportSSL(supernetSequences[i], hypernetSequences[i]) {
                numberOFSslIps += 1
            }
        }
        
        
        return "\(numberOFSslIps)"
    }
}

extension Day_7_2016 {
    static func supportSSL(_ supernetSequences: [String], _ hypernetSequences: [String]) -> Bool {
        var babs: [String] = []
        
        for supernet in supernetSequences {
            let supernetString = Array(supernet)
            for i in 0..<supernetString.count-2 {
                if supernetString[i] == supernetString[i+2] && supernetString[i] != supernetString[i+1] {
                    let str = "\(supernetString[i+1])\(supernetString[i])\(supernetString[i+1])"
                    babs.append(str)
                }
            }
        }
        
        for hypernet in hypernetSequences {
            for bab in babs {
                if hypernet.contains(bab) {
                    return true
                }
            }
        }
        
        return false
    }
}

private extension String {
    var isSupportingABBA: Bool {
        let pairSet = ["aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz"]
        
        for pair in pairSet {
            let comps = self.components(separatedBy: pair)
            guard comps.count > 1 else { continue }
            for i in 0..<comps.count-1 {
                guard let left = comps[i].last,
                      let right = comps[i+1].first
                else { continue }
            
                if left == right && left != pair.first && right != "]" && left != "[" {
                    return true
                }
            }
        }
        
        return false
    }
}
