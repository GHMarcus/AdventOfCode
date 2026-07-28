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

/// BFS-Variante, die **alle** kürzesten Pfade von `start` zum Ziel zurückgibt.
///
/// Im Gegensatz zur einfachen BFS-Variante wird der Cache pro **Ebene** (Tiefe) verwaltet.
/// Dadurch können mehrere gleichlange Pfade zu einem Ziel-State verfolgt werden.
///
/// - Parameters:
///   - start: Der Startzustand.
///   - goal: Prädikat, das `true` zurückgibt, wenn der Zielzustand erreicht wurde.
///   - neighbours: Liefert alle Nachfolger eines Zustands.
/// - Returns: Alle kürzesten Pfade (inkl. Start- und Endzustand),
///            oder `nil` wenn kein Pfad existiert.
func resolveAllBFS<State: Hashable>(
    start: State,
    goal: (State) -> Bool,
    neighbors: (State) -> [State]
) -> [[State]]? {
    // Queue speichert Tupel (Zustand, Tiefe), um Ebenen unterscheiden zu können.
    var queue: Queue<(State, Int)> = .init()
    queue.enqueue((start, 0))

    // Cache speichert den frühesten Zeitpunkt (Tiefe), zu dem ein State besucht wurde.
    // Ein State darf auf gleicher Tiefe erneut besucht werden, damit alternative
    // gleichlange Pfade nicht abgeschnitten werden.
    var visitedAtDepth: [State: Int] = [start: 0]

    // Für state s enthält way[s] alle direkten Vorgänger auf einem kürzesten Pfad.
    var way: [State: [State]] = [:]
    // Memoization analog zu resolveAllDFS für teure Callback-Auswertungen.
    var goalCache: [State: Bool] = [:]
    var neighborsCache: [State: [State]] = [:]

    func cachedGoal(_ state: State) -> Bool {
        if let cached = goalCache[state] { return cached }
        let value = goal(state)
        goalCache[state] = value
        return value
    }

    func cachedNeighbors(_ state: State) -> [State] {
        if let cached = neighborsCache[state] { return cached }
        let value = neighbors(state)
        neighborsCache[state] = value
        return value
    }

    // Sobald der erste Ziel-State auf Tiefe `goalDepth` gefunden wird,
    // werden alle Goal-States auf derselben Tiefe gesammelt.
    var goalDepth: Int? = nil
    var goalStates: [State] = []

    while let (state, depth) = queue.dequeue() {
        // Wenn wir bereits Goal-States gefunden haben und tiefer gehen würden – abbrechen.
        if let gd = goalDepth, depth > gd { break }

        if cachedGoal(state) {
            goalDepth = depth
            goalStates.append(state)
            // Nachbarn dieses Zustands nicht mehr expandieren.
            continue
        }

        // Sobald die kürzeste Zieltiefe feststeht, keine weiteren Expansionen mehr.
        if goalDepth != nil { continue }

        for neighbor in cachedNeighbors(state) {
            let nextDepth = depth + 1

            if let visited = visitedAtDepth[neighbor] {
                // Neighbor wurde schon besucht.
                if visited == nextDepth {
                    // Gleiche Tiefe → alternativer Pfad gleicher Länge → Vorgänger ergänzen.
                    way[neighbor, default: []].append(state)
                }
                // Tiefe kleiner → dieser Pfad wäre länger → ignorieren.
            } else {
                // Noch nie besucht → normal einreihen.
                visitedAtDepth[neighbor] = nextDepth
                way[neighbor, default: []].append(state)
                queue.enqueue((neighbor, nextDepth))
            }
        }
    }

    guard !goalStates.isEmpty else { return nil }

    // Alle Pfade zu allen gefundenen Goal-States rekonstruieren.
    var pathCache: [State: [[State]]] = [:]
    func buildPaths(to current: State) -> [[State]] {
        if let cached = pathCache[current] { return cached }

        let paths: [[State]]
        if let predecessors = way[current] {
            paths = predecessors.flatMap { predecessor in
                buildPaths(to: predecessor).map { $0 + [current] }
            }
        } else {
            paths = [[current]]
        }

        pathCache[current] = paths
        return paths
    }

    let allPaths = goalStates.flatMap { buildPaths(to: $0) }
    return allPaths.isEmpty ? nil : allPaths
}
