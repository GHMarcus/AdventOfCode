//
//  FunctionZeros.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 06.12.23.
//

/// Midnight formula to calculate the zeros of an second-degree function
/// 0 = ax^2 + bx + c
func findFunctionZeros(a: Int, b: Int, c: Int) -> [Double] {
    let root = (Double(b.pow(2)) - Double(4 * a * c)).squareRoot()
    let denominator = Double(2 * a)
    return [
        (-1 * Double(b) - root) / denominator,
        (-1 * Double(b) + root) / denominator
    ]
}
