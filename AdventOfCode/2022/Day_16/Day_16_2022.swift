//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/16

enum Day_16_2022: Solvable {
    // With help of: https://www.youtube.com/watch?v=bLMj50cpOug
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2022

    struct State: Equatable, Hashable {
        let time: Int
        let valve: String
        let bitmask: Int
    }

    static func solvePart1(input: [String]) -> String {
        var valves: [String: Int] = [:]
        var tunnels: [String: [String]] = [:]

        for line in input {
            // Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
            let cmp = line.replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
            let valve = cmp[1]
            let flow = Int(String(cmp[4].components(separatedBy: "=")[1].dropLast()))!
            let tunnel = Array(cmp[9..<cmp.count])

            valves[valve] = flow
            tunnels[valve] = tunnel
        }

        var dists: [String: [String: Int]] = [:]
        var nonEmpty: [String] = []

        for valve in valves {
            if valve.key != "AA" && valve.value == 0 {
                continue
            }

            if valve.key != "AA" {
                nonEmpty.append(valve.key)
            }

            var visited: Set<String> = []

            dists[valve.key] = [valve.key: 0]
            visited.insert(valve.key)

            var queue: [(distance: Int, position: String)] = [(0, valve.key)]

            while !queue.isEmpty {
                let current = queue.removeFirst()
                for neighbour in tunnels[current.position]! {
                    if visited.contains(neighbour) { continue }
                    visited.insert(neighbour)

                    if valves[neighbour]! != 0 {
                        dists[valve.key]![neighbour] = current.distance + 1
                    }
                    queue.append((current.distance + 1, neighbour))
                }
            }

            dists[valve.key]?.removeValue(forKey: valve.key)
            if valve.key != "AA" {
                dists[valve.key]?.removeValue(forKey: "AA")
            }
        }

        var indices: [String: Int] = [:]

        for (index, element) in nonEmpty.enumerated() {
            indices[element] = index
        }

        var cache: [State: Int] = [:]

        func dfs(state: State) -> Int{
            var maxVal = 0
            if let cacheValue = cache[state] {
                return cacheValue
            }
            for neighbour in dists[state.valve]! {
                let bit = 1 << indices[neighbour.key]!
                if (state.bitmask & bit) != 0 { continue }
                let remainingTime = state.time - neighbour.value - 1
                if remainingTime <= 0 { continue }
                maxVal = max(
                    maxVal,
                    dfs(state: State(
                        time: remainingTime,
                        valve: neighbour.key,
                        bitmask: state.bitmask | bit
                    )) + valves[neighbour.key]! * remainingTime
                )
            }

            cache[state] = maxVal
            return maxVal
        }

        let maxFlow = dfs(state: State(time: 30, valve: "AA", bitmask: 0))
        return "\(maxFlow)"
    }

    static func solvePart2(input: [String]) -> String {
        var valves: [String: Int] = [:]
        var tunnels: [String: [String]] = [:]

        for line in input {
            // Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
            let cmp = line.replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
            let valve = cmp[1]
            let flow = Int(String(cmp[4].components(separatedBy: "=")[1].dropLast()))!
            let tunnel = Array(cmp[9..<cmp.count])

            valves[valve] = flow
            tunnels[valve] = tunnel
        }

        var dists: [String: [String: Int]] = [:]
        var nonEmpty: [String] = []

        for valve in valves {
            if valve.key != "AA" && valve.value == 0 {
                continue
            }

            if valve.key != "AA" {
                nonEmpty.append(valve.key)
            }

            var visited: Set<String> = []

            dists[valve.key] = [valve.key: 0]
            visited.insert(valve.key)

            var queue: [(distance: Int, position: String)] = [(0, valve.key)]

            while !queue.isEmpty {
                let current = queue.removeFirst()
                for neighbour in tunnels[current.position]! {
                    if visited.contains(neighbour) { continue }
                    visited.insert(neighbour)

                    if valves[neighbour]! != 0 {
                        dists[valve.key]![neighbour] = current.distance + 1
                    }
                    queue.append((current.distance + 1, neighbour))
                }
            }

            dists[valve.key]?.removeValue(forKey: valve.key)
            if valve.key != "AA" {
                dists[valve.key]?.removeValue(forKey: "AA")
            }
        }

        var indices: [String: Int] = [:]

        for (index, element) in nonEmpty.enumerated() {
            indices[element] = index
        }

        var cache: [State: Int] = [:]

        func dfs(state: State) -> Int{
            var maxVal = 0
            if let cacheValue = cache[state] {
                return cacheValue
            }
            for neighbour in dists[state.valve]! {
                let bit = 1 << indices[neighbour.key]!
                if (state.bitmask & bit) != 0 { continue }
                let remainingTime = state.time - neighbour.value - 1
                if remainingTime <= 0 { continue }
                maxVal = max(
                    maxVal,
                    dfs(state: State(
                        time: remainingTime,
                        valve: neighbour.key,
                        bitmask: state.bitmask | bit
                    )) + valves[neighbour.key]! * remainingTime
                )
            }

            cache[state] = maxVal
            return maxVal
        }

        let b = (1 << nonEmpty.count) - 1
        var maxFlow = 0

        for i in 0..<(b/2) {
            maxFlow = max(
                maxFlow,
                dfs(state: State(time: 26, valve: "AA", bitmask: i)) + dfs(state: State(time: 26, valve: "AA", bitmask: b^i))
            )
        }

        return "\(maxFlow)"
    }
}
