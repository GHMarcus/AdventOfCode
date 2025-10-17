//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/11

// Note: Run takes about 1059.7395499944687 seconds
enum Day_11_2016: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2016
    typealias State = [Set<String>]
    
    static func convert(input: [String]) -> (start: State, goal: Set<String>) {
        var goal: Set<String> = [".", "E"]
        var start: State = []
        var isFirst = true
        for line in input {
            var floor: Set<String> = isFirst ? ["E", "."] : ["."]
            isFirst = false
            
            if line.contains("nothing") {
                start.append(floor)
                continue
            }
            
            let cmp = line.components(separatedBy: ",")
            for c in cmp {
                let indexBeforeType = c.index(of: " a ")!
                let type = String(c[c.index(indexBeforeType, offsetBy: 3)])
                if c.contains("generator") {
                    goal.insert(type+"G")
                    floor.insert(type+"G")
                } else {
                    goal.insert(type+"M")
                    floor.insert(type+"M")
                }
            }
            start.append(floor)
        }
        return (start, goal)
    }

    static func solvePart1(input: (start: State, goal: Set<String>)) -> String {
        let steps = aStar(
            start: input.start,
            goal: { $0.last! == input.goal },
            neighbors: { getNeighbors(of: $0) }
        ) ?? []
        
        return "\(steps.count - 1)"
    }
    
    static func solvePart2(input: (start: State, goal: Set<String>)) -> String {
        let additionalEquipment = ["eG","eM","dG","dM"]
        var newStart = input.start
        newStart[0] = newStart[0].union(additionalEquipment)
        let newGoal = input.goal.union(additionalEquipment)
        
        let steps = aStar(
            start: newStart,
            goal: { $0.last! == newGoal },
            neighbors: { getNeighbors(of: $0) }
        ) ?? []
        
        return "\(steps.count - 1)"
    }
    
    static func getNeighbors(of state: State) -> [State] {
        var newStates: [State] = []
        let elevatorFloor = state.firstIndex(where: { $0.contains("E") })!
        let nextFloors: [(components: Set<String>, number: Int)]
        
        if elevatorFloor == 0 {
            nextFloors = [(state[elevatorFloor+1], elevatorFloor+1)]
        } else if elevatorFloor == state.count - 1 {
            nextFloors = [(state[elevatorFloor-1], elevatorFloor-1)]
        } else {
            nextFloors = [(state[elevatorFloor+1], elevatorFloor+1), (state[elevatorFloor-1], elevatorFloor-1)]
        }
        
        let elevatorPossibilities = state[elevatorFloor]
            .sorted()
            .uniqueCombinations(ofLength: 2)
            .filter { !$0.contains("E") }
            .map { $0.filter { $0 != "."} }
            .map { $0 + ["E"] }
        
        
        for nextFloor in nextFloors {
            for elevatorPossibility in elevatorPossibilities {
                let newNextFloor = nextFloor.components.union(elevatorPossibility)
                let newCurrentFloor = state[elevatorFloor].subtracting(elevatorPossibility)
                
                if isFloorValid(newCurrentFloor) && isFloorValid(newNextFloor) {
                    var newState = state
                    newState[elevatorFloor] = newCurrentFloor
                    newState[nextFloor.number] = newNextFloor
                    newStates.append(newState)
                }
            }
        }
        
        return newStates
    }
    
    static func isFloorValid(_ floor: Set<String>) -> Bool {
        let reducedFloor = floor.filter { $0 != "." && $0 != "E" }
        // If nothing is in floor or only one element its always valid
        if reducedFloor.count <= 1 { return true }
        // If only microchips are on the floor it is also always valid
        if reducedFloor.allSatisfy({ $0.contains("M") }) { return true }
        
        // Find generator microchip pairs
        var generatorMap: [String: String?] = [:]
        var chipsLeft: Set<String> = []
        reducedFloor.filter{ $0.contains("G")}.forEach { generatorMap[$0] = "" }
        reducedFloor.filter{ $0.contains("M")}.forEach {
            if let _ = generatorMap[$0.dropLast()+"G"] {
                generatorMap[$0.dropLast()+"G"] = $0
            } else {
                chipsLeft.insert($0)
            }
        }
    
        // If there are chips left without an generator they will be fried => not valid
        if !chipsLeft.isEmpty { return false }
        return true
    }
}
