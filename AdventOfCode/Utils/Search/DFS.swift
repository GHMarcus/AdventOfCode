//
//  DFS.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 09.04.26.
//

/// DFS, die den **ersten** gefundenen Pfad von `start` zum Ziel zurückgibt.
///
/// - Parameters:
///   - start: Der Startzustand.
///   - goal: Prädikat, das `true` zurückgibt, wenn der Zielzustand erreicht wurde.
///   - neighbors: Liefert alle Nachfolger eines Zustands.
/// - Returns: Den ersten gefundenen Pfad (inkl. Start- und Endzustand),
///            oder `nil` wenn kein Pfad existiert.
func resolveDFS<State: Hashable>(
    start: State,
    goal: (State) -> Bool,
    neighbors: (State) -> [State]
) -> [State]? {
    var currentPath: [State] = []
    var onPath: Set<State> = []

    func dfs(_ state: State) -> Bool {
        currentPath.append(state)
        onPath.insert(state)

        if goal(state) {
            return true
        }

        for neighbor in neighbors(state) {
            guard !onPath.contains(neighbor) else { continue }
            if dfs(neighbor) { return true }
        }

        // Backtracking
        currentPath.removeLast()
        onPath.remove(state)
        return false
    }

    return dfs(start) ? currentPath : nil
}

/// DFS mit Backtracking, die **alle** Pfade von `start` zum Ziel zurückgibt.
///
/// Im Gegensatz zur BFS werden auch längere Pfade gefunden.
/// ⚠️ Kann bei großen/zyklischen Graphen sehr viele Ergebnisse liefern!
///
/// - Parameters:
///   - start: Der Startzustand.
///   - goal: Prädikat, das `true` zurückgibt, wenn der Zielzustand erreicht wurde.
///   - neighbors: Liefert alle Nachfolger eines Zustands.
///   - maxResults: Optionales Limit – bricht ab, sobald so viele Pfade gefunden wurden.
/// - Returns: Alle Pfade (inkl. Start- und Endzustand), oder `nil` wenn kein Pfad existiert.
func resolveAllDFS<State: Hashable>(
    start: State,
    goal: (State) -> Bool,
    neighbors: (State) -> [State],
    maxResults: Int = .max
) -> [[State]]? {
    guard maxResults > 0 else { return nil }
    if maxResults == 1 {
        return resolveDFS(start: start, goal: goal, neighbors: neighbors).map { [$0] }
    }

    var results: [[State]] = []
    // Nur States auf dem aktuellen Pfad sind gesperrt → verhindert Zyklen,
    // erlaubt aber denselben State auf anderen Pfaden.
    var onPath: Set<State> = []
    // Memoization:
    // - Cache für teure Callback-Auswertung (`goal`, `neighbors`)
    // - Erreichbarkeits-Pruning: Wenn ein State grundsätzlich kein Ziel erreichen kann,
    //   müssen wir ihn in keinem DFS-Zweig erneut expandieren.
    var goalCache: [State: Bool] = [:]
    var neighborsCache: [State: [State]] = [:]
    var canReachGoalCache: [State: Bool] = [:]
    var reachabilityVisiting: Set<State> = []

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

    func canReachGoal(_ state: State) -> Bool {
        if let cached = canReachGoalCache[state] { return cached }
        if cachedGoal(state) {
            canReachGoalCache[state] = true
            return true
        }

        if reachabilityVisiting.contains(state) {
            return false
        }

        reachabilityVisiting.insert(state)
        defer { reachabilityVisiting.remove(state) }

        for neighbor in cachedNeighbors(state) {
            if canReachGoal(neighbor) {
                canReachGoalCache[state] = true
                return true
            }
        }

        canReachGoalCache[state] = false
        return false
    }

    // currentPath wird als inout weitergereicht, um Array-Kopien zu vermeiden.
    @discardableResult
    func dfs(_ state: State, _ currentPath: inout [State]) -> Bool {
        currentPath.append(state)
        onPath.insert(state)

        defer {
            // Backtracking
            currentPath.removeLast()
            onPath.remove(state)
        }

        if !canReachGoal(state) {
            return false
        }

        if cachedGoal(state) {
            results.append(currentPath)
            return true
        }

        var foundPath = false
        if results.count < maxResults {
            for neighbor in cachedNeighbors(state) {
                guard !onPath.contains(neighbor) else { continue }
                guard results.count < maxResults else { break }
                if dfs(neighbor, &currentPath) {
                    foundPath = true
                }
            }
        }

        return foundPath
    }

    var path: [State] = []
    _ = dfs(start, &path)
    return results.isEmpty ? nil : results
}
