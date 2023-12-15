//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/15

enum Day_15_2023: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2023
    
    struct Step {
        let str: String
        let initialValue: Int = 0
        
        var convertedValue: Int {
            getHASHValue(from: str)
        }
        
        var hasDash: Bool {
            str.contains("-")
        }
        
        var label: String {
            if hasDash {
                return String(str.dropLast())
            } else {
                return String(str).components(separatedBy: "=")[0]
            }
        }
        
        var focalLength: Int {
            Int(String(str).components(separatedBy: "=")[1])!
        }
        
        var boxNumber: Int {
            getHASHValue(from: label)
        }
        
        private func getHASHValue(from string: String) -> Int {
            var currentValue = initialValue
            for c in Array(string) {
                let ascii = c.asciiValue!
                currentValue += Int(ascii)
                currentValue *= 17
                currentValue %= 256
            }
            return currentValue
        }
    }
    
    struct Box {
        var lens: [(label: String, focalLength: Int)] = []
        
        mutating func add(step: Step) {
            if let index = lens.firstIndex(where: { $0.label == step.label }) {
                lens[index] = (step.label, step.focalLength)
            } else {
                lens.append((step.label, step.focalLength))
            }
        }
        
        mutating func remove(step: Step) {
            lens.removeAll { $0.label == step.label }
        }
        
        func getFocusingPower(with index: Int) -> Int {
            var value = 0
            for (li, l) in lens.enumerated() {
                var lensValue = 1
                lensValue *= index + 1
                lensValue *= li + 1
                lensValue *= l.focalLength
                value += lensValue
            }
            return value
        }
    }
    
    static func convert(input: [String]) -> [Step] {
        input[0].components(separatedBy: ",").map { Step(str: $0) }
    }

    static func solvePart1(input: [Step]) -> String {
        let sum = input.reduce(0) { $0 + $1.convertedValue }
        return "\(sum)"
    }

    static func solvePart2(input: [Step]) -> String {
        var boxes = Array(repeating: Box(), count: 256)
        
        for step in input {
            if step.hasDash {
                boxes[step.boxNumber].remove(step: step)
            } else {
                boxes[step.boxNumber].add(step: step)
            }
        }
        
        var sum = 0
        for (index, box) in boxes.enumerated() {
            sum += box.getFocusingPower(with: index)
        }
        
        return "\(sum)"
    }
}
