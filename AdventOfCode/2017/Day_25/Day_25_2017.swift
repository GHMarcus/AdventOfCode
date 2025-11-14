//
//  Day_25.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/25

// Note: Took 183.9089399576187 seconds

enum Day_25_2017: Solvable {
    static var day: Input.Day = .Day_25
    static var year: Input.Year = .Year_2017
    
    struct StateCondition {
        let value: Int
        let diffPos: Int
        let nextState: String
    }
    
    struct State {
        let onZero: StateCondition
        let onOne: StateCondition
        
        func step(tape: [Int: Int], cursor: Int) -> (nextState: String, tape: [Int: Int], cursor: Int) {
            var nextTape = tape
            
            let value = tape[cursor, default: 0]
            let next = value == 0 ? onZero : onOne
            nextTape.updateValue(next.value, forKey: cursor)
            let nextCursor = cursor + next.diffPos
            
            return (next.nextState, nextTape, nextCursor)
        }
    }
    
    static func convert(input: [String]) -> (states: [String: State], steps: Int, startState: String) {
        var states = [String: State]()
        
        var lines = input.map { $0.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ":", with: "")}
        
        let startState = lines.removeFirst().components(separatedBy: " ").last!
        let steps = Int(lines.removeFirst().components(separatedBy: " ").dropLast().last!)!
        
        lines.removeFirst()
        
        while !lines.isEmpty {
            let name = lines.removeFirst().components(separatedBy: " ").last!
            // Zero
            lines.removeFirst() // removes lines with if value is 0
            let onZeroValue = Int(lines.removeFirst().components(separatedBy: " ").last!)!
            let oneZeroDir = lines.removeFirst().components(separatedBy: " ").last!
            let onZeroDiffPos = oneZeroDir == "right" ? 1 : -1
            let onZeroNextState = lines.removeFirst().components(separatedBy: " ").last!
            
            // One
            lines.removeFirst() // removes lines with if value is 1
            let onOneValue = Int(lines.removeFirst().components(separatedBy: " ").last!)!
            let oneOneDir = lines.removeFirst().components(separatedBy: " ").last!
            let onOneDiffPos = oneOneDir == "right" ? 1 : -1
            let onOneNextState = lines.removeFirst().components(separatedBy: " ").last!
            
            states[name] = State(
                onZero: StateCondition(
                    value: onZeroValue,
                    diffPos: onZeroDiffPos,
                    nextState: onZeroNextState
                ),
                onOne: StateCondition(
                    value: onOneValue,
                    diffPos: onOneDiffPos,
                    nextState: onOneNextState
                )
            )
            
            if lines.count > 0 {
                lines.removeFirst()
            }
        }
        
        
        
        return (states, steps, startState)
    }

    static func solvePart1(input: (states: [String: State], steps: Int, startState: String)) -> String {
        
        var currentState = input.states[input.startState]!
        var tape = [Int: Int]()
        var cursor = 0
        
        for i in 0..<input.steps {
            if i % 10000 == 0 { print("\(i)/\(input.steps)") }
            let next = currentState.step(tape: tape, cursor: cursor)
            tape = next.tape
            currentState = input.states[next.nextState]!
            cursor = next.cursor
        }
        
        let result = tape.reduce(0) { $0 + ($1.value == 1 ? 1 : 0) }
        
        
        return "\(result)"
    }

    static func solvePart2(input: (states: [String: State], steps: Int, startState: String)) -> String {
        "Nothing to do here"
    }
}
