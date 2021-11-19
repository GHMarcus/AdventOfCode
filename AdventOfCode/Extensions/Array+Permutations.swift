//
//  Array+Permutations.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 19.11.21.
//

// https://gist.github.com/proxpero/9fd3c4726d19242365d6

extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

// let example = between(0, [1, 2, 3])
// example = [[0, 1, 2, 3], [1, 0, 2, 3], [1, 2, 0, 3], [1, 2, 3, 0]]
func between<T>(x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x: x, tail).map { [head] + $0 }
}

// let p = permutations([1, 2, 3])
// p = [[1, 2, 3], [2, 1, 3], [2, 3, 1], [1, 3, 2], [3, 1, 2], [3, 2, 1]]
func permutations<T>(xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(xs: tail).flatMap { between(x: head, $0) }
}
