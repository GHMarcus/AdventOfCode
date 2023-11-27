//
//  BFS.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 27.11.23.
//

func resolveBFS<State: Hashable>(
    start: State,
    goal: (State) -> Bool,
    neighbours: (State) -> [State]
) -> [State]? {
    var queue: Queue<State> = .init()
    queue.enqueue(start)
    var cache: Set<State> = [start]

    // For state s, way[s] is the state immediately preceding it
    // on the cheapest path from start to state currently known.
    var way: [State: State] = [:]

    while let state = queue.dequeue() {
        guard !goal(state) else {
            return way.reconstructPath(to: state)
        }

        for neighbour in neighbours(state) {
            guard !cache.contains(neighbour)
            else { continue }
            cache.insert(neighbour)
            way[neighbour] = state

            queue.enqueue(neighbour)
        }
    }

    return nil
}

extension Dictionary where Key == Value {
    func reconstructPath(to value: Value) -> [Value] {
       var current = value
       var totalPath = [current]
       while let value = self[current] {
           current = value
           totalPath.append(value)
       }
       return totalPath.reversed()
   }
}
