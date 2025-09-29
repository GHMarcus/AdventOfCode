//
//  Day_24.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/24

enum Day_24_2024: Solvable {
    static var day: Input.Day = .Day_24
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (wires: [String: Bool], gates: [Gate])
    
    struct Gate {
        enum Operator: String {
            case and = "AND"
            case or = "OR"
            case xor = "XOR"
        }
        
        var i1: String
        var i2: String
        var out: String
        let op: Operator
        
        init(i1: String, i2: String, out: String, op: Operator) {
            self.i1 = i1
            self.i2 = i2
            self.out = out
            self.op = op
        }
        
        func operate(with wires: inout [String: Bool]) -> Bool {
            guard  let i1 = wires[i1], let i2 = wires[i2] else { return false }
            
            switch op {
            case .and: wires[out] = i1 && i2
            case .or: wires[out] = i1 || i2
            case .xor: wires[out] = i1 != i2
            }
            
            return true
        }
    }

    static func convert(input: [String]) -> ConvertedInput {
        let cmp = input.split(separator: "")
        var wires: [String: Bool] = [:]
        var gates: [Gate] = []
        for wire in cmp[0] {
            let cmp2 = wire.components(separatedBy: ": ")
            wires.updateValue(cmp2[1] == "1", forKey: cmp2[0])
        }
        for gate in cmp[1] {
            let cmp2 = gate.components(separatedBy: " ")
            let gate = Gate(
                i1: cmp2[0],
                i2: cmp2[2],
                out: cmp2[4],
                op: Gate.Operator(rawValue: cmp2[1])!
            )
            gates.append(gate)
        }
        return (wires, gates)
    }
    
    static func operateSystem(wires: [String: Bool], gates: [Gate]) -> [Bool] {
        var wires = wires
        var newRound = true
        var round = 0
        while newRound {
            round += 1
            if round > wires.count {
                return []
            }
            newRound = false
            for gate in gates {
                let didOperate = gate.operate(with: &wires)
                if !didOperate {
                    newRound = true
                }
            }
        }
        return wires.filter { $0.key.starts(with: "z") }.sorted { $0.key < $1.key }.reversed().map { $0.value }
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let outputWires = operateSystem(wires: input.wires, gates: input.gates)
        let outputValue = Int(outputWires.map { $0 ? "1" : "0" }.joined(), radix: 2)!
        
        return "\(outputValue)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        // Important note:
        // This solution only works, because the real input works like a full adder combined from two half adder
        // To understand the conditions check out the scheme for an full adder https://de.wikipedia.org/wiki/Volladdierer#/media/Datei:Volladdierer_Aufbau_DIN40900.svg
        let xyGates = input.gates.filter { $0.i1.contains("x") || $0.i2.contains("x") || $0.i1.contains("y") || $0.i2.contains("y")}
        var otherGates = input.gates.filter { !$0.i1.contains("x") || !$0.i2.contains("x") || !$0.i1.contains("y") || !$0.i2.contains("y")}
        let adderNumbers = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44"]
        
        var currentCout: String? = nil
        
        var swappingGates: [String] = []
        
        for (index, currentAdder) in adderNumbers.enumerated() {
            let currentXYGates = xyGates.filter { $0.i1.contains("\(currentAdder)") || $0.i2.contains("\(currentAdder)")}
            
            if index > 0 {
                let (check, nextCout, failingGates) = checkAdder(
                    currentAdder,
                    currentXYGates: currentXYGates,
                    otherGates: otherGates,
                    cIn: currentCout
                )
                
                if !check {
                    let sortedFailingGates = failingGates.sorted()
                    
                outerLoop:
                    for fg1 in sortedFailingGates {
                        for fg2 in sortedFailingGates where fg1 != fg2 {
                            var first = otherGates.first { $0.out == fg1 }!
                            var second = otherGates.first { $0.out == fg2 }!
                            
                            var newOtherGates = otherGates.filter{ ![fg1, fg2].contains($0.out) }
                            
                            first.out = sortedFailingGates.last!
                            second.out = sortedFailingGates.first!
                            
                            let inputChangingGates = newOtherGates.filter { [fg1, fg2].contains($0.i1) || [fg1, fg2].contains($0.i2) }
                            newOtherGates = newOtherGates.filter { ![fg1, fg2].contains($0.i1) || ![fg1, fg2].contains($0.i2) }
                            
                            newOtherGates.append(contentsOf: [first, second])
                            for gate in inputChangingGates {
                                var newGate = gate
                                if newGate.i1 == fg1 {
                                    newGate.i1 = fg2
                                }
                                if newGate.i1 == fg2 {
                                    newGate.i1 = fg1
                                }
                                if newGate.i2 == fg1 {
                                    newGate.i2 = fg2
                                }
                                if newGate.i2 == fg1 {
                                    newGate.i2 = fg2
                                }
                                newOtherGates.append(newGate)
                            }
                            
                            let (check, nextCout, _) = checkAdder(
                                currentAdder,
                                currentXYGates: currentXYGates,
                                otherGates: newOtherGates,
                                cIn: currentCout
                            )
                            
                            
                            if check {
                                otherGates = newOtherGates
                                swappingGates += [fg1, fg2]
                                currentCout = nextCout
                                break outerLoop
                            }
                        }
                    }
                } else {
                    currentCout = nextCout
                }
            } else {
                if let xyAnd = currentXYGates.first(where: { $0.op == .and }), let xyXor = currentXYGates.first(where: { $0.op == .xor }) {
                    if xyXor.out == "z\(currentAdder)" {
                        currentCout = xyAnd.out
                    } else {
                        fatalError()
                    }
                } else {
                    fatalError()
                }
            }
        }
        
        return "\(swappingGates.sorted().joined(separator: ","))"
    }
    
    static func checkAdder(_ currentAdder: String, currentXYGates: [Gate], otherGates: [Gate], cIn: String?) -> (isOK: Bool, cOut: String?, failedOutputs: Set<String>) {
        
        var failedOutputs: Set<String> = []
        
        if let xyAnd = currentXYGates.first(where: { $0.op == .and }), let xyXor = currentXYGates.first(where: { $0.op == .xor }) {
            
            let cInGates = otherGates.filter { $0.i1 == cIn || $0.i2 == cIn }
            
            if let cInAnd = cInGates.first(where: { $0.op == .and }), let cInXor = cInGates.first(where: { $0.op == .xor }) {

                var adderOk = true
                
                if !(cInXor.out == "z\(currentAdder)") {
                    adderOk = false
                }
                
                if !(cInXor.i1 == xyXor.out || cInXor.i2 == xyXor.out) {
                    adderOk = false
                }
                
                if !(cInAnd.i1 == xyXor.out || cInAnd.i2 == xyXor.out) {
                    adderOk = false
                }
                
                if let cOutOr = otherGates.first(where: { ($0.i1 == xyAnd.out || $0.i1 == cInAnd.out) && ($0.i2 == xyAnd.out || $0.i2 == cInAnd.out) }) {
                    if cOutOr.op == .or && cOutOr.out != "z\(currentAdder)" {
                        return (true, cOutOr.out, failedOutputs)
                    } else {
                        failedOutputs.insert(cOutOr.out)
                        adderOk = false
                    }
                } else {
                    adderOk = false
                }
                
                
                if !adderOk {
                    failedOutputs.insert(xyAnd.out)
                    failedOutputs.insert(xyXor.out)
                    failedOutputs.insert(cInAnd.out)
                    failedOutputs.insert(cInXor.out)
                    return (false, nil, failedOutputs)
                }
                
            } else {
                return (false, nil, failedOutputs)
            }
        } else {
            return (false, nil, failedOutputs)
        }
        
        return (false, nil, failedOutputs)
    }
}
