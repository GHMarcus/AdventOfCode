//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/23

// Note: Runs in about 72.02030301094055 seconds for both parts
enum Day_23_2021: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2021
    
    struct Pos: Hashable {
        let x, y: Int
    }
    
    struct State: Hashable {
        var a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4: Pos
        var currentCost: Int
        
        var allPos: Set<Pos> {
            [a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4]
        }
        
        init(a1: Pos, a2: Pos, a3: Pos, a4: Pos, b1: Pos, b2: Pos, b3: Pos, b4: Pos, c1: Pos, c2: Pos, c3: Pos, c4: Pos, d1: Pos, d2: Pos, d3: Pos, d4: Pos, currentCost: Int) {
            self.a1 = a1
            self.a2 = a2
            self.a3 = a3
            self.a4 = a4
            self.b1 = b1
            self.b2 = b2
            self.b3 = b3
            self.b4 = b4
            self.c1 = c1
            self.c2 = c2
            self.c3 = c3
            self.c4 = c4
            self.d1 = d1
            self.d2 = d2
            self.d3 = d3
            self.d4 = d4
            self.currentCost = currentCost
        }
        
        init(a1: Pos, a2: Pos, b1: Pos, b2: Pos, c1: Pos, c2: Pos, d1: Pos, d2: Pos, currentCost: Int) {
            let zero = Pos(x: 0, y: 0)
            self.a1 = a1
            self.a2 = a2
            self.b1 = b1
            self.b2 = b2
            self.c1 = c1
            self.c2 = c2
            self.d1 = d1
            self.d2 = d2
            
            a3 = zero
            a4 = zero
            b3 = zero
            b4 = zero
            c3 = zero
            c4 = zero
            d3 = zero
            d4 = zero
            self.currentCost = currentCost
        }
    }
    
    static let movableHallwaySpaces: Set<Pos> = [
        .init(x: 1, y: 1),
        .init(x: 2, y: 1),
        .init(x: 4, y: 1),
        .init(x: 6, y: 1),
        .init(x: 8, y: 1),
        .init(x: 10, y: 1),
        .init(x: 11, y: 1)
    ]
    
    static let doorHallwaySpaces: Set<Pos> = [
        .init(x: 3, y: 1),
        .init(x: 5, y: 1),
        .init(x: 7, y: 1),
        .init(x: 9, y: 1)
    ]
    
    static var roomA: Set<Pos> = []
    static var roomB: Set<Pos> = []
    static var roomC: Set<Pos> = []
    static var roomD: Set<Pos> = []
    static var rooms: Set<Pos> = []
    
    static func solvePart1(input: [String]) -> String {
        roomA = [
            Pos(x: 3, y: 2),
            Pos(x: 3, y: 3)
        ]
        
        roomB = [
            Pos(x: 5, y: 2),
            Pos(x: 5, y: 3)
        ]
        
        roomC = [
            Pos(x: 7, y: 2),
            Pos(x: 7, y: 3)
        ]
        
        roomD = [
            Pos(x: 9, y: 2),
            Pos(x: 9, y: 3)
        ]
        
        rooms = roomA.union(roomB).union(roomC).union(roomD)
        
        let a1 = Pos(x: 5, y: 3)
        let a2 = Pos(x: 9, y: 2)
        let b1 = Pos(x: 7, y: 2)
        let b2 = Pos(x: 7, y: 3)
        let c1 = Pos(x: 3, y: 3)
        let c2 = Pos(x: 9, y: 3)
        let d1 = Pos(x: 3, y: 2)
        let d2 = Pos(x: 5, y: 2)
        
        let start = State(
            a1: a1,
            a2: a2,
            b1: b1,
            b2: b2,
            c1: c1,
            c2: c2,
            d1: d1,
            d2: d2,
            currentCost: 0
        )
        
        let coast = aStar(
            start: start,
            goal: { checkGoal(for: $0, isPart2: false) },
            cost: { getCostFor($0, $1) },
            neighbors: { getNeighbors(of: $0, isPart2: false) }
        ) ?? []
        
        return "\(coast.last?.currentCost ?? -1)"
    }

    static func solvePart2(input: [String]) -> String {
        roomA = [
            Pos(x: 3, y: 2),
            Pos(x: 3, y: 3),
            Pos(x: 3, y: 4),
            Pos(x: 3, y: 5)
        ]
        
        roomB = [
            Pos(x: 5, y: 2),
            Pos(x: 5, y: 3),
            Pos(x: 5, y: 4),
            Pos(x: 5, y: 5)
        ]
        
        roomC = [
            Pos(x: 7, y: 2),
            Pos(x: 7, y: 3),
            Pos(x: 7, y: 4),
            Pos(x: 7, y: 5)
        ]
        
        roomD = [
            Pos(x: 9, y: 2),
            Pos(x: 9, y: 3),
            Pos(x: 9, y: 4),
            Pos(x: 9, y: 5)
        ]
        
        rooms = roomA.union(roomB).union(roomC).union(roomD)
        
        let a1 = Pos(x: 5, y: 5)
        let a2 = Pos(x: 9, y: 2)
        let b1 = Pos(x: 7, y: 2)
        let b2 = Pos(x: 7, y: 5)
        let c1 = Pos(x: 3, y: 5)
        let c2 = Pos(x: 9, y: 5)
        let d1 = Pos(x: 3, y: 2)
        let d2 = Pos(x: 5, y: 2)
        
        let a3 = Pos(x: 7, y: 4)
        let a4 = Pos(x: 9, y: 3)
        let b3 = Pos(x: 5, y: 4)
        let b4 = Pos(x: 7, y: 3)
        let c3 = Pos(x: 5, y: 3)
        let c4 = Pos(x: 9, y: 4)
        let d3 = Pos(x: 3, y: 3)
        let d4 = Pos(x: 3, y: 4)
        
        let start = State(
            a1: a1,
            a2: a2,
            a3: a3,
            a4: a4,
            b1: b1,
            b2: b2,
            b3: b3,
            b4: b4,
            c1: c1,
            c2: c2,
            c3: c3,
            c4: c4,
            d1: d1,
            d2: d2,
            d3: d3,
            d4: d4,
            currentCost: 0
        )
        
        let coast = aStar(
            start: start,
            goal: { checkGoal(for: $0, isPart2: true) },
            cost: { getCostFor($0, $1) },
            neighbors: { getNeighbors(of: $0, isPart2: true) }
        ) ?? []
        
        return "\(coast.last?.currentCost ?? -1)"
    }
    
    static func getAllowedAmphipods(for type: String, in state: State, isPart2: Bool) -> Set<Pos> {
        let allowedAmphipod: Set<Pos>
        switch type {
        case "A1":
            allowedAmphipod = isPart2 ? [state.a2, state.a3, state.a4] : [state.a2]
        case "A2":
            allowedAmphipod = isPart2 ? [state.a1, state.a3, state.a4] : [state.a1]
        case "A3":
            allowedAmphipod = [state.a1, state.a2, state.a4]
        case "A4":
            allowedAmphipod = [state.a1, state.a2, state.a3]
        case "B1":
            allowedAmphipod = isPart2 ? [state.b2, state.b3, state.b4] : [state.b2]
        case "B2":
            allowedAmphipod = isPart2 ? [state.b1, state.b3, state.b4] : [state.b1]
        case "B3":
            allowedAmphipod = [state.b1, state.b2, state.b4]
        case "B4":
            allowedAmphipod = [state.b1, state.b2, state.b3]
        case "C1":
            allowedAmphipod = isPart2 ? [state.c2, state.c3, state.c4] : [state.c2]
        case "C2":
            allowedAmphipod = isPart2 ? [state.c1, state.c3, state.c4] : [state.c1]
        case "C3":
            allowedAmphipod = [state.c1, state.c2, state.c4]
        case "C4":
            allowedAmphipod = [state.c1, state.c2, state.c3]
        case "D1":
            allowedAmphipod = isPart2 ? [state.d2, state.d3, state.d4] : [state.d2]
        case "D2":
            allowedAmphipod = isPart2 ? [state.d1, state.d3, state.d4] : [state.d1]
        case "D3":
            allowedAmphipod = [state.d1, state.d2, state.d4]
        case "D4":
            allowedAmphipod = [state.d1, state.d2, state.d3]
        default:
            fatalError()
        }
        return allowedAmphipod
    }
    
    static func getNewState(for current: (dest: Pos, path: Set<Pos>), in state: State, type: String, startPosCorrectionValue: Int) -> State {
        var newState = state
        let costPerSpace: Int
        switch type {
        case "A1":
            newState.a1 = current.dest
            costPerSpace = 1
        case "A2":
            newState.a2 = current.dest
            costPerSpace = 1
        case "A3":
            newState.a3 = current.dest
            costPerSpace = 1
        case "A4":
            newState.a4 = current.dest
            costPerSpace = 1
        case "B1":
            newState.b1 = current.dest
            costPerSpace = 10
        case "B2":
            newState.b2 = current.dest
            costPerSpace = 10
        case "B3":
            newState.b3 = current.dest
            costPerSpace = 10
        case "B4":
            newState.b4 = current.dest
            costPerSpace = 10
        case "C1":
            newState.c1 = current.dest
            costPerSpace = 100
        case "C2":
            newState.c2 = current.dest
            costPerSpace = 100
        case "C3":
            newState.c3 = current.dest
            costPerSpace = 100
        case "C4":
            newState.c4 = current.dest
            costPerSpace = 100
        case "D1":
            newState.d1 = current.dest
            costPerSpace = 1000
        case "D2":
            newState.d2 = current.dest
            costPerSpace = 1000
        case "D3":
            newState.d3 = current.dest
            costPerSpace = 1000
        case "D4":
            newState.d4 = current.dest
            costPerSpace = 1000
        default:
            fatalError()
        }
        newState.currentCost += costPerSpace * (current.path.count + startPosCorrectionValue)
        return newState
    }
    
    static func checkGoal(for state: State, isPart2: Bool) -> Bool {
        if isPart2 {
            roomA == [state.a1, state.a2, state.a3, state.a4]
            && roomB == [state.b1, state.b2, state.b3, state.b4]
            && roomC == [state.c1, state.c2, state.c3, state.c4]
            && roomD == [state.d1, state.d2, state.d3, state.d4]
        } else {
            roomA == [state.a1, state.a2]
            && roomB == [state.b1, state.b2]
            && roomC == [state.c1, state.c2]
            && roomD == [state.d1, state.d2]
        }
    }
    
    static func getCostFor(_ s1: State, _ s2: State) -> Int {
        s2.currentCost - s1.currentCost
    }
    
    static func getNeighbors(of state: State, isPart2: Bool) -> [State] {
        var newStates: [State] = []
        
        newStates.append(contentsOf: getNewStates(for: state.a1, with: state, room: roomA, type: "A1", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.a2, with: state, room: roomA, type: "A2", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.b1, with: state, room: roomB, type: "B1", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.b2, with: state, room: roomB, type: "B2", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.c1, with: state, room: roomC, type: "C1", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.c2, with: state, room: roomC, type: "C2", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.d1, with: state, room: roomD, type: "D1", isPart2: isPart2))
        newStates.append(contentsOf: getNewStates(for: state.d2, with: state, room: roomD, type: "D2", isPart2: isPart2))
        
        if isPart2 {
            newStates.append(contentsOf: getNewStates(for: state.a3, with: state, room: roomA, type: "A3", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.a4, with: state, room: roomA, type: "A4", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.b3, with: state, room: roomB, type: "B3", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.b4, with: state, room: roomB, type: "B4", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.c3, with: state, room: roomC, type: "C3", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.c4, with: state, room: roomC, type: "C4", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.d3, with: state, room: roomD, type: "D3", isPart2: isPart2))
            newStates.append(contentsOf: getNewStates(for: state.d4, with: state, room: roomD, type: "D4", isPart2: isPart2))
        }
        
        return newStates
    }
    
    static func getNewStates(for pos: Pos, with state: State, room: Set<Pos>, type: String, isPart2: Bool) -> [State] {
        var newStates: [State] = []
        
        let allowedAmphipod = getAllowedAmphipods(for: type, in: state, isPart2: isPart2)
        
        if room.contains(pos) && (pos.y + 1 ..< room.count + 2).allSatisfy({ allowedAmphipod.contains(Pos(x: pos.x, y: $0))}) {
            return []
        }
        
        let otherPods = state.allPos.subtracting([pos])
        let othersInDestinationRoom = otherPods.filter { room.contains($0) }
        
        var toMoveSpaces: [(dest: Pos, path: Set<Pos>)] = []
        var canMoveInDestinationRoom = false

        // Destination room is empty or only pods in room is same pod on the lowest pos -> fill room
        let otherPodsAreLinedUpFromBottom = othersInDestinationRoom.isEmpty ? false : othersInDestinationRoom.min(by: {$0.y < $1.y})!.y == room.count + 2 - othersInDestinationRoom.count
        if othersInDestinationRoom.isEmpty || (othersInDestinationRoom.isSubset(of: allowedAmphipod) && otherPodsAreLinedUpFromBottom ) {
            let upperSpaceInRoom = room.first { $0.y == 2 }!
            
            var toMove: Set<Pos> = []
            if upperSpaceInRoom.x > pos.x {
                toMove = movableHallwaySpaces.union(doorHallwaySpaces).filter { $0.x >= pos.x && $0.x <= upperSpaceInRoom.x }
            } else {
                toMove = movableHallwaySpaces.union(doorHallwaySpaces).filter { $0.x >= upperSpaceInRoom.x && $0.x <= pos.x }
            }
            
            // Fill all positions down to the lowest possible position in room
            for dy in 0 ..< (room.count - othersInDestinationRoom.count) {
                toMove.insert(Pos(x: upperSpaceInRoom.x, y: upperSpaceInRoom.y + dy))
            }
            
            // Check if someone is standing right above the in the room, with filling all positions above current into the path
            if rooms.contains(pos) {
                for y in 2 ..< pos.y {
                    toMove.insert(Pos(x: pos.x, y: y))
                }
            }
            
            // If one pod is standing on the path we can not move there
            if toMove.intersection(otherPods).isEmpty {
                let dest = room.subtracting(othersInDestinationRoom).max { $0.y < $1.y }!
                toMoveSpaces.append((dest, toMove))
                canMoveInDestinationRoom = true
            }
        }
        
        if !canMoveInDestinationRoom && !movableHallwaySpaces.contains(pos) {
            // Destination room is not empty, a wrong pod is in there or we can not move there -> go to hallway
            for possibleHallwaySpace in movableHallwaySpaces {
                var toMove: Set<Pos> = []
                if possibleHallwaySpace.x > pos.x {
                    toMove = movableHallwaySpaces.union(doorHallwaySpaces).filter { $0.x >= pos.x && $0.x <= possibleHallwaySpace.x }
                } else {
                    toMove = movableHallwaySpaces.union(doorHallwaySpaces).filter { $0.x >= possibleHallwaySpace.x && $0.x <= pos.x }
                }
                
                // Check if someone is standing right above the in the room
                if rooms.contains(pos) {
                    for y in 2 ..< pos.y {
                        toMove.insert(Pos(x: pos.x, y: y))
                    }
                }
                
                // If one pod is standing on the path we can not move there
                if toMove.intersection(otherPods).isEmpty {
                    toMoveSpaces.append((possibleHallwaySpace, toMove))
                }
            }
        }
        
        var startPosCorrectionValue = 0
        
        // Remove one when pos is in the hallway
        if !rooms.contains(pos) {
            startPosCorrectionValue = -1
        }
        
        for current in toMoveSpaces {
            newStates.append(getNewState(for: current, in: state, type: type, startPosCorrectionValue: startPosCorrectionValue))
        }
        
        return newStates
    }
}
