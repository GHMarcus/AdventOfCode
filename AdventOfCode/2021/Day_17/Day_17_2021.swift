//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/17

enum Day_17_2021: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2021

    static func solvePart1(input: [String]) -> String {
        let comps = input[0]
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "x", with: "")
            .replacingOccurrences(of: "y", with: "")
            .replacingOccurrences(of: "=", with: "")
            .components(separatedBy: " ")
        let xRange = comps[2].components(separatedBy: "..")
        let yRange = comps[3].components(separatedBy: "..")

        let targetXRange = ClosedRange(uncheckedBounds: (lower: Int(xRange[0])!, upper: Int(xRange[1])!))
        let targetYRange = ClosedRange(uncheckedBounds: (lower: Int(yRange[0])!, upper: Int(yRange[1])!))

        let minVelocity = targetYRange.lowerBound
        let maxVelocity = targetXRange.upperBound

        var xVelocity = 0
        var yVelocity = 0

        var maxY = 0

        for x in minVelocity...maxVelocity {
            for y in minVelocity...maxVelocity {
                xVelocity = x
                yVelocity = y
                var xPos = 0
                var yPos = 0
                var currentMaxY = 0
                while true {
                    xPos += xVelocity
                    if xVelocity > 0 {
                        xVelocity -= 1
                    } else if xVelocity < 0 {
                        xVelocity += 1
                    }

                    yPos += yVelocity
                    yVelocity -= 1
                    currentMaxY = max(currentMaxY, yPos)

                    if xPos > maxVelocity || yPos < minVelocity {
                        break
                    }

                    if targetXRange.contains(xPos) && targetYRange.contains(yPos) {
                        maxY = max(maxY, currentMaxY)
                        break
                    }
                }
            }
        }

        return "\(maxY)"
    }

    static func solvePart2(input: [String]) -> String {
        //        let comps = input[0].components(separatedBy: " ")
        let comps = input[0]
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "x", with: "")
            .replacingOccurrences(of: "y", with: "")
            .replacingOccurrences(of: "=", with: "")
            .components(separatedBy: " ")
        let xRange = comps[2].components(separatedBy: "..")
        let yRange = comps[3].components(separatedBy: "..")

        let targetXRange = ClosedRange(uncheckedBounds: (lower: Int(xRange[0])!, upper: Int(xRange[1])!))
        let targetYRange = ClosedRange(uncheckedBounds: (lower: Int(yRange[0])!, upper: Int(yRange[1])!))

        let minVelocity = targetYRange.lowerBound
        let maxVelocity = targetXRange.upperBound

        var xVelocity = 0
        var yVelocity = 0

        var startingVelocities: [(Int,Int)] = []

        for x in -100...200 {
            for y in -200...200 {
                xVelocity = x
                yVelocity = y
                var xPos = 0
                var yPos = 0
                while true {
                    xPos += xVelocity
                    if xVelocity > 0 {
                        xVelocity -= 1
                    } else if xVelocity < 0 {
                        xVelocity += 1
                    }

                    yPos += yVelocity
                    yVelocity -= 1

                    if xPos > maxVelocity || yPos < minVelocity {
                        break
                    }

                    if targetXRange.contains(xPos) && targetYRange.contains(yPos) {
                        startingVelocities.append((x,y))
                        break
                    }
                }
            }
        }

        return "\(startingVelocities.count)"
    }
}
