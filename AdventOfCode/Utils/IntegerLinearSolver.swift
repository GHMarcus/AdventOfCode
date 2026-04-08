//
//  IntegerLinearSolver.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 08.04.26.
//

import Foundation

/// Solver für ganzzahlige lineare Gleichungssysteme (ILP):
///   Minimiere Σ x_j
///   unter:  A · x = b
///           x_j ≥ 0, x_j ∈ ℤ
///
/// Verwendet ganzzahlige Gauß-Elimination (euklidisch) + Backtracking.
struct IntegerLinearSolver {

    /// Ergebnis einer Lösung
    struct Solution {
        /// Die optimalen Werte der Variablen
        let values: [Int]
        /// Die minimale Summe aller Variablen
        let totalSum: Int
    }

    /// Löst das ILP: Minimiere Σ x_j, wobei A·x = b, x ≥ 0, x ganzzahlig.
    ///
    /// - Parameters:
    ///   - matrix: Die Koeffizientenmatrix A der Größe m × n (m Gleichungen, n Variablen).
    ///             `matrix[i][j]` ist der Koeffizient von Variable j in Gleichung i.
    ///   - rhs: Der Zielvektor b der Länge m.
    ///   - maxSearchBound: Maximaler Wert für freie Variablen im Backtracking (Default: 3 × max(rhs)).
    /// - Returns: Die optimale Lösung oder `nil` falls keine existiert.
    static func solve(
        matrix inputMatrix: [[Int]],
        rhs: [Int],
        maxSearchBound: Int? = nil
    ) -> Solution? {
        let m = rhs.count
        let n = inputMatrix.isEmpty ? 0 : inputMatrix[0].count

        guard m > 0, n > 0 else { return nil }
        guard inputMatrix.count == m else { return nil }
        guard inputMatrix.allSatisfy({ $0.count == n }) else { return nil }

        // Erweiterte Matrix [A | b]
        var aug = Array(repeating: Array(repeating: 0, count: n + 1), count: m)
        for i in 0..<m {
            for j in 0..<n {
                aug[i][j] = inputMatrix[i][j]
            }
            aug[i][n] = rhs[i]
        }

        // === Ganzzahlige Gauß-Elimination (euklidisch) ===
        var pivotRow = 0
        var pivotCols: [Int] = []

        for col in 0..<n {
            if pivotRow >= m { break }

            var changed = true
            while changed {
                changed = false

                var minRow = -1
                var minVal = Int.max
                for row in pivotRow..<m {
                    let v = abs(aug[row][col])
                    if v > 0 && v < minVal {
                        minVal = v
                        minRow = row
                    }
                }
                guard minRow >= 0 else { break }

                if minRow != pivotRow {
                    aug.swapAt(minRow, pivotRow)
                    changed = true
                }

                let sv = aug[pivotRow][col]
                if sv == 0 { break }

                for row in (pivotRow + 1)..<m {
                    let rv = aug[row][col]
                    if rv == 0 { continue }
                    let q = rv / sv
                    if q == 0 { continue }
                    for j in 0...n {
                        aug[row][j] -= q * aug[pivotRow][j]
                    }
                    reduceRow(&aug[row], cols: n + 1)
                    changed = true
                }
            }

            if aug[pivotRow][col] == 0 { continue }

            if aug[pivotRow][col] < 0 {
                for j in 0...n { aug[pivotRow][j] *= -1 }
            }
            reduceRow(&aug[pivotRow], cols: n + 1)

            // Obere Zeilen bereinigen
            let pv = aug[pivotRow][col]
            for row in 0..<pivotRow {
                let rv = aug[row][col]
                if rv == 0 { continue }
                if rv % pv == 0 {
                    let q = rv / pv
                    for j in 0...n { aug[row][j] -= q * aug[pivotRow][j] }
                } else {
                    let g = gcd(abs(pv), abs(rv))
                    let mRow = pv / g
                    let mPiv = rv / g
                    for j in 0...n {
                        aug[row][j] = mRow * aug[row][j] - mPiv * aug[pivotRow][j]
                    }
                }
                reduceRow(&aug[row], cols: n + 1)
            }

            pivotCols.append(col)
            pivotRow += 1
        }

        let rank = pivotCols.count

        // Konsistenzprüfung
        for row in rank..<m {
            if aug[row][n] != 0 { return nil }
        }

        // Freie Variablen
        let pivotColSet = Set(pivotCols)
        var freeVars: [Int] = []
        for j in 0..<n {
            if !pivotColSet.contains(j) { freeVars.append(j) }
        }

        // Sicherheitsschranke
        let defaultBound = maxSearchBound ?? max((rhs.max() ?? 0) * 3, 100)

        // === Backtracking ===
        var bestTotal = Int.max
        var bestValues: [Int]? = nil
        var currentFreeValues = Array(repeating: 0, count: freeVars.count)

        func evaluatePivotVars() -> (values: [Int], total: Int)? {
            var values = Array(repeating: 0, count: n)
            var total = 0

            // Freie Variablen eintragen
            for fi in 0..<freeVars.count {
                values[freeVars[fi]] = currentFreeValues[fi]
                total += currentFreeValues[fi]
            }

            // Pivot-Variablen berechnen
            for r in 0..<rank {
                let pc = pivotCols[r]
                let pv = aug[r][pc]
                if pv == 0 { return nil }

                var rhsVal = aug[r][n]
                for fi in 0..<freeVars.count {
                    rhsVal -= aug[r][freeVars[fi]] * currentFreeValues[fi]
                }

                if rhsVal % pv != 0 { return nil }
                let val = rhsVal / pv
                if val < 0 { return nil }

                values[pc] = val
                total += val
                if total >= bestTotal { return nil }
            }

            return (values, total)
        }

        func computeBounds(freeIdx: Int) -> (lower: Int, upper: Int) {
            var lb = 0
            var ub = defaultBound

            for r in 0..<rank {
                let coeff = aug[r][freeVars[freeIdx]]
                if coeff == 0 { continue }
                let pv = aug[r][pivotCols[r]]
                if pv == 0 { continue }

                // Skip rows that still have unassigned free variables
                var hasLaterFree = false
                for fi in (freeIdx + 1)..<freeVars.count {
                    if aug[r][freeVars[fi]] != 0 {
                        hasLaterFree = true
                        break
                    }
                }
                if hasLaterFree { continue }

                var rhsVal = aug[r][n]
                for fi in 0..<freeIdx {
                    rhsVal -= aug[r][freeVars[fi]] * currentFreeValues[fi]
                }

                // pivot_var = (rhsVal - coeff * x_free) / pv >= 0
                let signPv = pv > 0 ? 1 : -1
                let effRhs = rhsVal * signPv
                let effCoeff = coeff * signPv

                if effCoeff > 0 {
                    if effRhs < 0 { return (0, -1) }
                    ub = min(ub, effRhs / effCoeff)
                } else if effCoeff < 0 {
                    let absCoeff = -effCoeff
                    if effRhs < 0 {
                        let minVal = ((-effRhs) + absCoeff - 1) / absCoeff
                        lb = max(lb, minVal)
                    }
                }
            }

            return (lb, ub)
        }

        func backtrack(freeIdx: Int, currentSum: Int) {
            if currentSum >= bestTotal { return }

            if freeIdx == freeVars.count {
                if let result = evaluatePivotVars(), result.total < bestTotal {
                    bestTotal = result.total
                    bestValues = result.values
                }
                return
            }

            let bounds = computeBounds(freeIdx: freeIdx)
            if bounds.upper < bounds.lower { return }

            for val in bounds.lower...bounds.upper {
                currentFreeValues[freeIdx] = val
                let newSum = currentSum + val
                if newSum >= bestTotal { break }
                backtrack(freeIdx: freeIdx + 1, currentSum: newSum)
            }
        }

        if freeVars.isEmpty {
            if let result = evaluatePivotVars() {
                return Solution(values: result.values, totalSum: result.total)
            }
            return nil
        }

        backtrack(freeIdx: 0, currentSum: 0)

        if let values = bestValues {
            return Solution(values: values, totalSum: bestTotal)
        }
        return nil
    }

    // MARK: - Helpers

    private static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 { let t = b; b = a % b; a = t }
        return a
    }

    private static func reduceRow(_ row: inout [Int], cols: Int) {
        var g = 0
        for j in 0..<cols { g = gcd(g, abs(row[j])) }
        if g > 1 { for j in 0..<cols { row[j] /= g } }
    }
}

extension IntegerLinearSolver {

    /// Baut die Koeffizientenmatrix aus Button-Zuordnungen.
    ///
    /// - Parameters:
    ///   - buttons: `buttons[j]` = Array der Indizes, die Button j beeinflusst.
    ///   - rowCount: Anzahl der Zeilen (Counter/Gleichungen). Wenn `nil`, wird der
    ///               höchste Index + 1 aus den Buttons abgeleitet.
    /// - Returns: Matrix A der Größe `rowCount × buttons.count`, wobei
    ///            `A[i][j] = 1` wenn Button j den Index i enthält, sonst `0`.
    static func buildMatrix(
        from buttons: [[Int]],
        rowCount: Int? = nil
    ) -> [[Int]] {
        let n = buttons.count
        let m = rowCount ?? (buttons.flatMap { $0 }.max().map { $0 + 1 } ?? 0)

        return (0..<m).map { i in
            (0..<n).map { j in
                buttons[j].contains(i) ? 1 : 0
            }
        }
    }
}

