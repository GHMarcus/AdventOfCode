//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/16

enum Day_16_2018: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2018
    
    static var registers = [0,0,0,0]
    
    enum Opcode: String, CaseIterable {
        case addr
        case addi
        case mulr
        case muli
        case banr
        case bani
        case borr
        case bori
        case setr
        case seti
        case gtir
        case gtri
        case gtrr
        case eqir
        case eqri
        case eqrr
    }
    
    static func solve(_ opcode: Opcode, a: Int, b: Int, c: Int) -> [Int]? {
        var output = registers
        
        
        func checkBounds(_ index: Int) -> Bool {
            return index >= 0 && index < 4
        }
        
        switch opcode {
        case .addr:
            guard checkBounds(c), checkBounds(a), checkBounds(b) else { return nil }
            output[c] = output[a] + output[b]
        case .addi:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a] + b
        case .mulr:
            guard checkBounds(c), checkBounds(a), checkBounds(b) else { return nil }
            output[c] = output[a] * output[b]
        case .muli:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a] * b
        case .banr:
            guard checkBounds(c), checkBounds(a), checkBounds(b) else { return nil }
            output[c] = output[a] & output[b]
        case .bani:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a] & b
        case .borr:
            guard checkBounds(c), checkBounds(a), checkBounds(b) else { return nil }
            output[c] = output[a] | output[b]
        case .bori:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a] | b
        case .setr:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a]
        case .seti:
            guard checkBounds(c) else { return nil }
            output[c] = a
        case .gtir:
            guard checkBounds(c), checkBounds(b) else { return nil }
            output[c] = a > output[b] ? 1 : 0
        case .gtri:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a] > b ? 1 : 0
        case .gtrr:
            guard checkBounds(c), checkBounds(a), checkBounds(b) else { return nil }
            output[c] = output[a] > output[b] ? 1 : 0
        case .eqir:
            guard checkBounds(c), checkBounds(b) else { return nil }
            output[c] = a == output[b] ? 1 : 0
        case .eqri:
            guard checkBounds(c), checkBounds(a) else { return nil }
            output[c] = output[a] == b ? 1 : 0
        case .eqrr:
            guard checkBounds(c), checkBounds(a), checkBounds(b) else { return nil }
            output[c] = output[a] == output[b] ? 1 : 0
        }
            return output
    }

    static func solvePart1(input: [String]) -> String {
        
        var i = 0
        
        var samplesWithThreeOrMoreCodes = 0
        
        while i < input.count {
            let beforeLine = input[i]
            let codeLine = input[i+1]
            let afterLine = input[i+2]
            
            if beforeLine.isEmpty {
                break
            }
            
            registers = beforeLine
                .suffix(from: beforeLine.firstIndex(of: "[")!)
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .components(separatedBy: ",")
                .map{ Int($0)! }
            
            let operation = codeLine
                .components(separatedBy: " ")
                .map{ Int($0)! }
            
            let expectedRegister = afterLine
                .suffix(from: afterLine.firstIndex(of: "[")!)
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .components(separatedBy: ",")
                .map{ Int($0)! }
            
            var opcodeCounter = 0
            
            for code in Opcode.allCases {
                if let newRegister = solve(code, a: operation[1], b: operation[2], c: operation[3]),
                   newRegister == expectedRegister {
                    opcodeCounter += 1
                }
            }
            
            if opcodeCounter >= 3 {
                samplesWithThreeOrMoreCodes += 1
            }
            
            i += 4
        }
        
        return "\(samplesWithThreeOrMoreCodes)"
    }

    static func solvePart2(input: [String]) -> String {
        var i = 0
    
        var numberCodeMap: [Int: Set<Opcode>] = [:]
        
        while i < input.count {
            let beforeLine = input[i]
            let codeLine = input[i+1]
            let afterLine = input[i+2]
            
            if beforeLine.isEmpty {
                break
            }
            
            registers = beforeLine
                .suffix(from: beforeLine.firstIndex(of: "[")!)
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .components(separatedBy: ",")
                .map{ Int($0)! }
            
            let operation = codeLine
                .components(separatedBy: " ")
                .map{ Int($0)! }
            
            let expectedRegister = afterLine
                .suffix(from: afterLine.firstIndex(of: "[")!)
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .components(separatedBy: ",")
                .map{ Int($0)! }
            
            let number = operation[0]
            var codeSet = numberCodeMap[number] ?? []
            
            for code in Opcode.allCases {
                if let newRegister = solve(code, a: operation[1], b: operation[2], c: operation[3]),
                   newRegister == expectedRegister {
                    codeSet.insert(code)
                }
            }
            
            numberCodeMap[number] = codeSet
            
            i += 4
        }
        
        var fixedNumberCodes: [Int: Opcode] = numberCodeMap
            .filter { $0.value.count == 1 }
            .reduce(into: [:]) { partialResult, entry in
                partialResult[entry.key] = entry.value.first!
            }
        
        for fixedNumber in fixedNumberCodes {
            numberCodeMap.removeValue(forKey: fixedNumber.key)
        }
        
        while numberCodeMap.count > 0 {
            for fixedNumber in fixedNumberCodes {
                for numberCode in numberCodeMap {
                    var newCodes = numberCode.value
                    newCodes.remove(fixedNumber.value)
                    numberCodeMap.updateValue(newCodes, forKey: numberCode.key)
                }
            }

            let newFixedNumberCodes: [Int: Opcode] = numberCodeMap
                .filter { $0.value.count == 1 }
                .reduce(into: [:]) { partialResult, entry in
                    partialResult[entry.key] = entry.value.first!
                }
            
            for fixedNumber in newFixedNumberCodes {
                numberCodeMap.removeValue(forKey: fixedNumber.key)
            }
            
            fixedNumberCodes.merge(newFixedNumberCodes) { (current, _) in current }
            
        }
        
        // Jump over the empty lines
        i += 2
        registers = [0,0,0,0]
        while i < input.count {
            
            let operation = input[i]
                .components(separatedBy: " ")
                .map{ Int($0)! }
            
            registers = solve(fixedNumberCodes[operation[0]]!, a: operation[1], b: operation[2], c: operation[3])!
            i += 1
        }
        
        return "\(registers[0])"
    }
}
