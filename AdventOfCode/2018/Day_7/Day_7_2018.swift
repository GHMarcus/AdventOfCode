//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/7

enum Day_7_2018: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2018
    
    class Step {
        let id: String
        let finishTime: Int
        var workedTime: Int
        var previous: [Step]
        var next: [Step]
        
        var isDone: Bool {
            workedTime >= finishTime
        }
        
        init(id: String, finishTime: Int) {
            self.id = id
            self.finishTime = finishTime
            previous = []
            next = []
            workedTime = 0
        }
        
        func setDone() {
            workedTime = finishTime
        }
    }
    
    static func solvePart1(input: [String]) -> String {
        
        var steps = convertInputToSteps(input)
        
        steps.sort { $0.id < $1.id }
        
        var sequence = ""
        while !steps.allSatisfy(\.isDone) {
            for step in steps where !step.isDone {
                if execute(step: step) {
                    sequence += step.id
                    break
                }
            }
        }
        
        return sequence
    }

    static func solvePart2(input: [String]) -> String {
        
        var steps = convertInputToSteps(input)
        
        steps.sort { $0.id < $1.id }
        
        var time = 0
        var workers = [".", ".", ".", ".", "."]
        while !steps.allSatisfy(\.isDone) {
            
            for w in 0..<workers.count {
                if workers[w] == "." {
                    if let step = steps.first(where: { !$0.isDone && $0.previous.allSatisfy(\.isDone) && !workers.contains($0.id) }) {
                        workers[w] = step.id
                    }
                }
            }
            
            for w in 0..<workers.count {
                if let step = steps.first(where:{ $0.id == workers[w] }) {
                    step.workedTime += 1
                    if step.isDone {
                        workers[w] = "."
                    }
                }
            }
            
            time += 1
        }
        
        return "\(time)"
    }
    
    static func convertInputToSteps(_ input: [String]) -> [Step] {
        var steps: [Step] = []
        let offset = 60
        
        for line in input {
            let components = line.components(separatedBy: " ")
            let currentId = components[7]
            let previousId = components[1]
            
            var currentStep = steps.first { $0.id == currentId }
            var previousStep = steps.first { $0.id == previousId }

            switch (currentStep, previousStep) {
                
            case (nil, nil):
                currentStep = Step(id: currentId, finishTime: currentId.wordValue + offset)
                previousStep = Step(id: previousId, finishTime: previousId.wordValue + offset)
                
                currentStep?.previous.append(previousStep!)
                previousStep?.next.append(currentStep!)
                
                steps.append(previousStep!)
                steps.append(currentStep!)
            case (let current, nil):
                previousStep = Step(id: previousId, finishTime: previousId.wordValue + offset)
                
                current?.previous.append(previousStep!)
                previousStep?.next.append(current!)
                
                steps.append(previousStep!)
            case (nil, let previous):
                currentStep = Step(id: currentId, finishTime: currentId.wordValue + offset)
                
                currentStep?.previous.append(previous!)
                previous?.next.append(currentStep!)
                
                steps.append(currentStep!)
            case (let current, let previous):
                current?.previous.append(previous!)
                previous?.next.append(current!)
            }
        }
        
        return steps
    }
    
    static func execute(step: Step) -> Bool {
        if step.previous.allSatisfy(\.isDone) || step.previous.isEmpty {
            step.setDone()
            return true
        } else {
            return false
        }
    }
}
