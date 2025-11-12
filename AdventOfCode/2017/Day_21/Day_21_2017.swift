//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/21

// Note: Took 28.687862038612366 seconds

enum Day_21_2017: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2017
    
    struct Rule {
        let size: Int
        let input: String
        let output: [String]
    }
    
    static func convert(input: [String]) -> [Rule] {
        var rules: [Rule] = []
        for line in input {
            let cmp = line.components(separatedBy: " => ")
            rules.append(Rule(
                size: cmp[0].count == 5 ? 2 : 3,
                input: cmp[0],
                output: cmp[1].components(separatedBy: "/")
            ))
        }
        return rules
    }

    static func solvePart1(input: [Rule]) -> String {
        let twoRules = input.filter{ $0.size == 2 }
        let threeRules = input.filter{ $0.size == 3 }
        
        var image: [[Character]] = [
            [".", "#", "."],
            [".", ".", "#"],
            ["#", "#", "#"]
        ]
        
        for _ in 0..<5 {
            image = getNewImage(for: image, twoRules: twoRules, threeRules: threeRules)
        }
        
        let onPixels = image.map { $0.map{ $0 == "#" ? 1 : 0 }.reduce(0, +) }.reduce(0, +)
        
        return "\(onPixels)"
    }

    static func solvePart2(input: [Rule]) -> String {
        let twoRules = input.filter{ $0.size == 2 }
        let threeRules = input.filter{ $0.size == 3 }
        
        var image: [[Character]] = [
            [".", "#", "."],
            [".", ".", "#"],
            ["#", "#", "#"]
        ]
        
        for _ in 0..<18 {
            image = getNewImage(for: image, twoRules: twoRules, threeRules: threeRules)
        }
        
        let onPixels = image.map { $0.map{ $0 == "#" ? 1 : 0 }.reduce(0, +) }.reduce(0, +)
        
        return "\(onPixels)"
    }
    
    static func getNewImage(for image: [[Character]], twoRules: [Rule], threeRules: [Rule]) -> [[Character]] {
        var image = image
        if image.count % 2 == 0 {
            let newSize = image.count + image.count / 2
            var newImage: [[Character]] = Array(repeating: [], count: newSize)
            var i = 0
            while image.count > 0 {
                let row1 = image.removeFirst().chunked(into: 2)
                let row2 = image.removeFirst().chunked(into: 2)
                
                for n in 0..<row1.count {
                    let patterns = getAllInputPatterns(for: [row1[n], row2[n]])
                    let rule = twoRules.first { patterns.contains($0.input) }!
                    newImage[i] = newImage[i] + Array(rule.output[0])
                    newImage[i+1] = newImage[i+1] + Array(rule.output[1])
                    newImage[i+2] = newImage[i+2] + Array(rule.output[2])
                }
                i += 3
            }
            image = newImage
        } else if image.count % 3 == 0 {
            let newSize = image.count + image.count / 3
            var newImage: [[Character]] = Array(repeating: [], count: newSize)
            var i = 0
            while image.count > 0 {
                let row1 = image.removeFirst().chunked(into: 3)
                let row2 = image.removeFirst().chunked(into: 3)
                let row3 = image.removeFirst().chunked(into: 3)
                
                for n in 0..<row1.count {
                    let patterns = getAllInputPatterns(for: [row1[n], row2[n], row3[n]])
                    let rule = threeRules.first { patterns.contains($0.input) }!
                    newImage[i] = newImage[i] + Array(rule.output[0])
                    newImage[i+1] = newImage[i+1] + Array(rule.output[1])
                    newImage[i+2] = newImage[i+2] + Array(rule.output[2])
                    newImage[i+3] = newImage[i+3] + Array(rule.output[3])
                }
                i += 4
            }
            image = newImage
        } else {
            fatalError()
        }
        
        return image
    }
    
    static func getAllInputPatterns(for mat: [[Character]]) -> Set<String> {
        var patterns = Set<String>()
        
        var mat = mat
        patterns.formUnion(doubleFlip(mat))
        mat = rotateRight(mat)
        patterns.formUnion(doubleFlip(mat))
        mat = rotateRight(mat)
        patterns.formUnion(doubleFlip(mat))
        mat = rotateRight(mat)
        patterns.formUnion(doubleFlip(mat))
        
        return patterns
    }
    
    static func doubleFlip(_ mat: [[Character]]) -> Set<String> {
        var normal = ""
        var vFlip = ""
        var hFlip = ""
        for n in 0..<mat.count {
            normal += String(mat[n]) + "/"
            vFlip += String(mat[n].reversed()) + "/"
        }
        
        for n in (0..<mat.count).reversed() {
            hFlip += String(mat[n]) + "/"
        }
        
        return [
            String(normal.dropLast()),
            String(vFlip.dropLast()),
            String(hFlip.dropLast())
        ]
    }
}
