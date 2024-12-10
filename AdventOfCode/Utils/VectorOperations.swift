//
//  VectorOperations.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 10.12.24.
//

func crossProdukt<T: Numeric & Comparable>(a: [T], b: [T]) -> [T] {
    guard a.count == b.count else { fatalError("Arrays must have same length") }
    let max = a.count
    var result: [T] = []
    for i in 0..<max {
        let first = (i+1) % max
        let second = (i+2) % max
        
        result.append(a[first] * b[second] - a[second] * b[first])
    }
    return result
}

func scalarProduct<T: Numeric & Comparable>(a: [T], b: [T]) -> T {
    guard a.count == b.count else { fatalError("Arrays must have same length") }
    return zip(a, b).map { $0 * $1}.reduce(0, +)
}

func subtract<T: Numeric & Comparable>(a: [T], b: [T]) -> [T] {
    guard a.count == b.count else { fatalError("Arrays must have same length") }
    return zip(a, b).map{$0 - $1}
}

func add<T: Numeric & Comparable>(a: [T], b: [T]) -> [T] {
    guard a.count == b.count else { fatalError("Arrays must have same length") }
    return zip(a, b).map{$0 + $1}
}

func multiply<T: Numeric & Comparable>(a: [T], b: T) -> [T] {
    a.map{$0 * b}
}

func divide<T: Numeric & Comparable & FloatingPoint>(a: [T], b: T) -> [T] {
    a.map{$0 / b}
}
