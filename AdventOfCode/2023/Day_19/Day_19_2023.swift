//
//  Day_19.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/19

enum Day_19_2023: Solvable {
    static var day: Input.Day = .Day_19
    static var year: Input.Year = .Year_2023
    
    struct Workflow {
        let name: String
        let rules: [Rule]
        let jump: String
        
        func applyRules(with part: Part) -> String {
            var jump = jump
            
            for rule in rules {
                if let ruleJump = rule.apply(to: part) {
                    jump = ruleJump
                    break
                }
            }
            
            return jump
        }
        
        func applyRules(with rangePart: RangePart) -> [(key: String, range: RangePart)] {
            var result: [(key: String, range: RangePart)] = []
            
            var remainingPart: RangePart? = rangePart
            
            for rule in rules {
                
                var ruleJumps = rule.apply(to: remainingPart!)
                
                if ruleJumps.count == 2 {
                    remainingPart = ruleJumps.first(where: { $0.key == ""})!.range
                    result.append(ruleJumps.first(where: { $0.key != ""})!)
                } else if ruleJumps[0].key == "" {
                    remainingPart = ruleJumps[0].range
                    continue
                } else {
                    remainingPart = nil
                    result.append(ruleJumps[0])
                    break
                }
            }
            
            if let remainingPart = remainingPart {
                result.append((jump, remainingPart))
            }
            
            return result
        }
    }
    
    struct Rule {
        enum Category: Character {
            case x = "x"
            case m = "m"
            case a = "a"
            case s = "s"
        }
        
        enum Comparator: Character {
            case isLower = "<"
            case isGrater = ">"
        }
        
        let category: Category
        let comparator: Comparator
        let value: Int
        let jump: String
        
        init(ruleStr: String) {
            let cmp = ruleStr.components(separatedBy: ":")
            var catCompValueStr = cmp[0]
            category = Category(rawValue: catCompValueStr.removeFirst())!
            comparator = Comparator(rawValue: catCompValueStr.removeFirst())!
            value = Int(catCompValueStr)!
            jump = cmp[1]
        }
        
        func apply(to part: Part) -> String? {
            var ruleIsApplied = false
            
            switch category {
            case .x:
                switch comparator {
                case .isLower:
                    ruleIsApplied = part.x < value
                case .isGrater:
                    ruleIsApplied = part.x > value
                }
            case .m:
                switch comparator {
                case .isLower:
                    ruleIsApplied = part.m < value
                case .isGrater:
                    ruleIsApplied = part.m > value
                }
            case .a:
                switch comparator {
                case .isLower:
                    ruleIsApplied = part.a < value
                case .isGrater:
                    ruleIsApplied = part.a > value
                }
            case .s:
                switch comparator {
                case .isLower:
                    ruleIsApplied = part.s < value
                case .isGrater:
                    ruleIsApplied = part.s > value
                }
            }
            
            return ruleIsApplied ? jump : nil
        }
        
        func apply(to rangePart: RangePart) -> [(key: String, range: RangePart)] {
            let range: ClosedRange<Int>
            switch category {
            case .x:
                range = rangePart.x
            case .m:
                range = rangePart.m
            case .a:
                range = rangePart.a
            case .s:
                range = rangePart.s
            }
            
            switch comparator {
            case .isLower:
                if range.contains(value-1) {
                    var firstNewPart = rangePart
                    var secondNewPart = rangePart
                    
                    let firstNewRange = range.lowerBound...value-1
                    let secondNewRange = value...range.upperBound
                    
                    switch category {
                    case .x:
                        firstNewPart.x = firstNewRange
                        secondNewPart.x = secondNewRange
                    case .m:
                        firstNewPart.m = firstNewRange
                        secondNewPart.m = secondNewRange
                    case .a:
                        firstNewPart.a = firstNewRange
                        secondNewPart.a = secondNewRange
                    case .s:
                        firstNewPart.s = firstNewRange
                        secondNewPart.s = secondNewRange
                    }
                    
                    return [(jump, firstNewPart), ("", secondNewPart)]
                } else {
                    if value-1 > range.upperBound {
                        return [(jump, rangePart)]
                    } else {
                        return [("", rangePart)]
                    }
                }
            case .isGrater:
                if range.contains(value+1) {
                    var firstNewPart = rangePart
                    var secondNewPart = rangePart
                    
                    let firstNewRange = range.lowerBound...value
                    let secondNewRange = value+1...range.upperBound
                    
                    switch category {
                    case .x:
                        firstNewPart.x = firstNewRange
                        secondNewPart.x = secondNewRange
                    case .m:
                        firstNewPart.m = firstNewRange
                        secondNewPart.m = secondNewRange
                    case .a:
                        firstNewPart.a = firstNewRange
                        secondNewPart.a = secondNewRange
                    case .s:
                        firstNewPart.s = firstNewRange
                        secondNewPart.s = secondNewRange
                    }
                    
                    return [("", firstNewPart), (jump, secondNewPart)]
                } else {
                    if value+1 < range.lowerBound {
                        return [(jump, rangePart)]
                    } else {
                        return [("", rangePart)]
                    }
                }
            }
        }
    }
    
    struct Part {
        let x,m,a,s: Int
        
        init(partStr: String) {
            let cmp = partStr.dropLast().dropFirst().components(separatedBy: ",")
            x = Int(cmp[0].components(separatedBy: "=")[1])!
            m = Int(cmp[1].components(separatedBy: "=")[1])!
            a = Int(cmp[2].components(separatedBy: "=")[1])!
            s = Int(cmp[3].components(separatedBy: "=")[1])!
        }
        
        var sum: Int {
            x + m + a + s
        }
    }
    
    struct RangePart {
        var x,m,a,s: ClosedRange<Int>
        
        init() {
            x = 1...4000
            m = 1...4000
            a = 1...4000
            s = 1...4000
        }
        
        var ranges: [Int] {
            [
                x.count,
                m.count,
                a.count,
                s.count
            ]
        }
    }
    
    static func convert(input: [String]) -> (workflows: [String: Workflow], parts: [Part]) {
        var workflows: [String: Workflow] = [:]
        var parts: [Part] = []
        
        var isWorkflow = true
        
        for line in input {
            if line.isEmpty {
                isWorkflow = false
                continue
            }
            
            if isWorkflow {
                // px{a<2006:qkq,m>2090:A,rfg}
                let cmp = line.dropLast().components(separatedBy: "{")
                let name = cmp[0]
                var ruleStrs = cmp[1].components(separatedBy: ",")
                let lastJump = ruleStrs.removeLast()
                let rules = ruleStrs.map { Rule(ruleStr: $0) }
                
                workflows[name] = Workflow(name: name, rules: rules, jump: lastJump)
            } else {
                // {x=787,m=2655,a=1222,s=2876}
                parts.append(Part(partStr: line))
            }
        }
        
        return (workflows, parts)
    }

    static func solvePart1(input: (workflows: [String: Workflow], parts: [Part])) -> String {
        var acceptedParts: [Part] = []
        
        for part in input.parts {
            var workflow = input.workflows["in"]!
            
            while true {
                let jump = workflow.applyRules(with: part)
                
                if jump == "A" {
                    acceptedParts.append(part)
                    break
                } else if jump == "R" {
                    break
                }
                
                workflow = input.workflows[jump]!
            }
            
        }
        
        let sum = acceptedParts.reduce(0) { $0 + $1.sum }
        
        return "\(sum)"
    }

    static func solvePart2(input: (workflows: [String: Workflow], parts: [Part])) -> String {
        
        let workflow = input.workflows["in"]!
        let acceptedParts = findAcceptedParts(for: RangePart(), at: workflow, workflows: input.workflows)
        
        var sum = 0
        for acceptedPart in acceptedParts {
            sum += acceptedPart.ranges.reduce(1) { $0 * $1 }
        }
        
        print(sum == 130090458884662)
        return "\(sum)"
    }
    
    static func findAcceptedParts(for rangePart: RangePart, at workflow: Workflow, workflows: [String: Workflow]) -> [RangePart] {
        var acceptedParts: [RangePart] = []
        
        let jumps = workflow.applyRules(with: rangePart)
        
        let accepted = jumps.filter { $0.key == "A"  }
        let remaining = jumps.filter { $0.key != "R" }.filter { $0.key != "A" }
        
        if !accepted.isEmpty {
            accepted.forEach { acceptedParts.append($0.range) }
        }
        
        if remaining.isEmpty {
            return acceptedParts
        }
        
        remaining.forEach {
            acceptedParts.append(contentsOf: findAcceptedParts(for: $0.range, at: workflows[$0.key]!, workflows: workflows))
        }
        
        return acceptedParts
    }
}
