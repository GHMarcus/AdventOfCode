//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/10

enum Day_10_2015: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        let rounds = 40
        var digits = Array(input[0])
        for i in 1...rounds {
            
            var newDigits: [(amount: Int, number: String.Element)] = []
            var previousDigit: String.Element? = nil
            var digitAmount: Int = 0
            
            print("Round \(i)")
            
            for n in 0..<digits.count {
                let digit = digits[n]
                if previousDigit == nil {
                    previousDigit = digit
                    digitAmount += 1
                } else if previousDigit == digit {
                    digitAmount += 1
                } else {
                    newDigits.append((digitAmount,previousDigit!))
                    previousDigit = digit
                    digitAmount = 1
                }
                if n == digits.count - 1 {
                    newDigits.append((digitAmount,previousDigit!))
                }
            }
            
            digits = []
            for newDigit in newDigits {
                digits.append(String(newDigit.amount).first!)
                digits.append(newDigit.number)
            }
        }
        print("End")
        
        return "\(digits.count)"
    }

    static func solvePart2(input: [String]) -> String {
        let rounds = 50
        var digits = Array(input[0])
        for i in 1...rounds {
            
            var newDigits: [(amount: Int, number: String.Element)] = []
            var previousDigit: String.Element? = nil
            var digitAmount: Int = 0
            
            print("Round \(i)")
            
            for n in 0..<digits.count {
                let digit = digits[n]
                if previousDigit == nil {
                    previousDigit = digit
                    digitAmount += 1
                } else if previousDigit == digit {
                    digitAmount += 1
                } else {
                    newDigits.append((digitAmount,previousDigit!))
                    previousDigit = digit
                    digitAmount = 1
                }
                if n == digits.count - 1 {
                    newDigits.append((digitAmount,previousDigit!))
                }
            }
            
            digits = []
            for newDigit in newDigits {
                digits.append(String(newDigit.amount).first!)
                digits.append(newDigit.number)
            }
        }
        print("End")
        
        return "\(digits.count)"
    }
}
