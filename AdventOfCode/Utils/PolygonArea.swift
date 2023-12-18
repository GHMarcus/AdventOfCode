//
//  PolygonArea.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 18.12.23.
//

/// A function to apply the Shoelace algorithm, to calculate the area
/// inside of an polygon. The vertices must be in clockwise order along the border
/// of the polygon.
/// https://www.101computing.net/the-shoelace-algorithm/
///
func polygonInsideArea(vertices: [(x: Int, y: Int)]) -> Int {
    guard vertices.count >= 3 else { return 0 }
    
    let counterVertices = Array(vertices.reversed())
    
    var sum1 = 0
    var sum2 = 0
    
    for i in 0 ..< counterVertices.count - 1 {
        sum1 += counterVertices[i].x * counterVertices[i+1].y
        sum2 += counterVertices[i].y * counterVertices[i+1].x
    }
    
    // Add xn * y1
    sum1 += counterVertices.last!.x * counterVertices.first!.y
    // Add x1 * yn
    sum2 += counterVertices.first!.x * counterVertices.last!.y
    
    return abs(sum1 - sum2) / 2
}

// If this ⬆️ produces an overflow you can use this ⬇️

//func polygonArea(vertices: [(x: Int, y: Int)]) -> Int {
//    guard vertices.count >= 3 else { return 0 }
//
//    let counterVertices = Array(vertices.reversed())
//
//    var sum = 0
//
//    for i in 0 ..< counterVertices.count - 1 {
//        sum += counterVertices[i].x * counterVertices[i+1].y - counterVertices[i].y * counterVertices[i+1].x
//    }
//
//    sum += counterVertices.last!.x * counterVertices.first!.y - counterVertices.first!.x * counterVertices.last!.y
//
//    return abs(sum) / 2
//}


/// A function to use the `Pick's theorem` to calculate the hole area of an polygon.
/// The vertices must be in clockwise order along the border of the polygon.
/// For the borderElements only the number (with the vertices) is needed.
/// https://en.wikipedia.org/wiki/Pick%27s_theorem
///
func polygonArea(vertices: [(x: Int, y: Int)], borderElements: Int) -> Int {
    polygonInsideArea(vertices: vertices) + borderElements / 2 + 1
}
