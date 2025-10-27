//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/17

import Foundation
import CryptoKit

enum Day_17_2016: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2016
    
    struct Pos: Hashable {
        let x, y: Int
    }
    
    struct State: Hashable {
        let passcode: String
        let path: String
        let position: Pos
    }
    
    static func convert(input: [String]) -> String {
        input.first!
    }

    static func solvePart1(input: String) -> String {
        let start = Pos(x: 0, y: 0)
        let vault = Pos(x: 3, y: 3)
        
        let path = aStar(
            start: State(passcode: input, path: "", position: start),
            goal: { $0.position == vault },
            neighbors: { findNeighbors(of: $0) }
        ) ?? []
        
        let shortestPath = path.last?.path ?? ""
        
        return shortestPath
    }

    static func solvePart2(input: String) -> String {
        let start = Pos(x: 0, y: 0)
        let vault = Pos(x: 3, y: 3)
        let startNode = State(passcode: input, path: "", position: start)
        let goalNode = State(passcode: input, path: "", position: vault)
        
        let path = findLongestPath(from: startNode, to: goalNode)
        
        let longestPath = path.count - 1
        
        return "\(longestPath)"
    }

    static func findNeighbors(of state: State) -> [State] {
        var neighbors: [State] = []
        
        let openDoorStates: [Character] = ["b", "c", "d", "e", "f"]
        let doorSates: [Character] = Array(Array(MD5(string: state.passcode + state.path))[0..<4])
        
        // check up
        if openDoorStates.contains(doorSates[0]) {
            let newPos = Pos(x: state.position.x, y: state.position.y - 1)
            if newPos.x >= 0 && newPos.y >= 0 && newPos.x <= 3 && newPos.y <= 3 {
                neighbors.append(State(passcode: state.passcode, path: state.path+"U", position: newPos))
            }
        }
        
        // check down
        if openDoorStates.contains(doorSates[1]) {
            let newPos = Pos(x: state.position.x, y: state.position.y + 1)
            if newPos.x >= 0 && newPos.y >= 0 && newPos.x <= 3 && newPos.y <= 3 {
                neighbors.append(State(passcode: state.passcode, path: state.path+"D", position: newPos))
            }
        }
        
        // check left
        if openDoorStates.contains(doorSates[2]) {
            let newPos = Pos(x: state.position.x - 1, y: state.position.y)
            if newPos.x >= 0 && newPos.y >= 0 && newPos.x <= 3 && newPos.y <= 3 {
                neighbors.append(State(passcode: state.passcode, path: state.path+"L", position: newPos))
            }
        }
        
        // check right
        if openDoorStates.contains(doorSates[3]) {
            let newPos = Pos(x: state.position.x + 1, y: state.position.y)
            if newPos.x >= 0 && newPos.y >= 0 && newPos.x <= 3 && newPos.y <= 3 {
                neighbors.append(State(passcode: state.passcode, path: state.path+"R", position: newPos))
            }
        }
        
        return neighbors
    }
    
    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    static func longestPathDFS(
        current: State,
        goal: State,
        visited: inout Set<State>
    ) -> [State] {
        if current.position == goal.position {
            return [goal]
        }
        
        visited.insert(current)
        var bestPath: [State] = []
        
        for neighbor in findNeighbors(of: current) {
            if !visited.contains(neighbor) {
                let path = longestPathDFS(current: neighbor, goal: goal, visited: &visited)
                if !path.isEmpty && path.count + 1 > bestPath.count {
                    bestPath = [current] + path
                }
            }
        }
        
        visited.remove(current)
        return bestPath
    }

    static func findLongestPath(from start: State, to goal: State) -> [State] {
        var visited = Set<State>()
        return longestPathDFS(current: start, goal: goal, visited: &visited)
    }
}
