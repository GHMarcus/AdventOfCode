//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/17

import AppKit

enum Day_17_2018: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2018
    
    typealias Grid = [Pos: Cell]
    
    enum Cell {
        case clay, settled, flowing, open
    }

    struct Pos: Hashable {
        let x, y: Int
    }
    
    static func convert(input: [String]) -> Grid {
        var clays: [Pos: Cell] = [:]
        for line in input {
            let cmp = line.components(separatedBy: ", ")
            if cmp[0].contains("x") {
                let x = Int(cmp[0].dropFirst(2))!
                let yRange = cmp[1].dropFirst(2).components(separatedBy: "..").map { Int($0)! }
                
                for y in yRange[0]...yRange[1] {
                    clays.updateValue(.clay, forKey: Pos(x: x, y: y))
                }
            } else {
                let y = Int(cmp[0].dropFirst(2))!
                let xRange = cmp[1].dropFirst(2).components(separatedBy: "..").map { Int($0)! }
                for x in xRange[0]...xRange[1] {
                    clays.updateValue(.clay, forKey: Pos(x: x, y: y))
                }
            }
        }
        return clays
    }
    
    static var max = 0
    
    static func solvePart1(input: Grid) -> String {
        var grid = input
        
        let minY = grid.map { $0.key.y }.min()!
        let maxY = grid.map { $0.key.y }.max()!
        
        // We do not want do add the spring itself so we start at the first water falling down
        let spring = Pos(x: 500, y: 1)
        max = maxY

        pour(&grid, at: spring)
    
        let result = grid
            .filter { $0.value != .clay }
            .filter { minY <= $0.key.y && $0.key.y <= maxY }
            .count
        
        return "\(result)"
    }

    static func solvePart2(input: Grid) -> String {
        var grid = input
        
        let minY = grid.map { $0.key.y }.min()!
        let maxY = grid.map { $0.key.y }.max()!
        
        // We do not want do add the spring itself so we start at the first water falling down
        let spring = Pos(x: 500, y: 1)
        max = maxY

        pour(&grid, at: spring)
    
        let result = grid
            .filter { $0.value == .settled }
            .filter { minY <= $0.key.y && $0.key.y <= maxY }
            .count
        
        return "\(result)"
    }
    
    static func pour(_ grid: inout Grid, at pos: Pos) {
        if pos.y > max { return }
        
        let cell = grid[pos]
        if cell == nil {
            grid.updateValue(.flowing, forKey: pos)
            pour(&grid, at: Pos(x: pos.x, y: pos.y + 1))
        } else if cell == .clay || cell == .settled {
            fill(&grid, at: Pos(x: pos.x, y: pos.y - 1))
        }
    }
    
    static func fill(_ grid: inout Grid, at pos: Pos) {
        let left = findDrop(grid, from: pos, with: -1)
        let right = findDrop(grid, from: pos, with: 1)
        
        if left == nil && right == nil {
            settleLevel(&grid, at: pos)
            fill(&grid, at: Pos(x: pos.x, y: pos.y - 1))
            return
        }
        
        if let left = left {
            flowing(&grid, lesser: left+1, greater: pos.x, y: pos.y)
            pour(&grid, at: Pos(x: left, y: pos.y))
        } else {
            var x = pos.x - 1
            while true {
                let newPos = Pos(x: x, y: pos.y)
                let cell = get(grid, at: newPos)
                
                if cell == .clay { break }
                if cell == .open {
                    grid.updateValue(.flowing, forKey: newPos)
                }
                x -= 1
            }
        }
        
        if let right = right {
            flowing(&grid, lesser: pos.x, greater: right-1, y: pos.y)
            pour(&grid, at: Pos(x: right, y: pos.y))
        } else {
            var x = pos.x + 1
            while true {
                let newPos = Pos(x: x, y: pos.y)
                let cell = get(grid, at: newPos)
                
                if cell == .clay { break }
                if cell == .open {
                    grid.updateValue(.flowing, forKey: newPos)
                }
                x += 1
            }
        }
    }
    
    static func findDrop(_ grid: Grid, from pos: Pos, with step: Int) -> Int? {
        let x = pos.x + step
        let cell = get(grid, at: Pos(x: x, y: pos.y))
        let cellBelow = get(grid, at: Pos(x: x, y: pos.y + 1))
        
        if cell == .clay { return nil }
        if cell == .flowing && cellBelow == .flowing {
            return x
        }
        if cell == .open && cellBelow == .open {
            return x
        }
        
        return findDrop(grid, from: Pos(x: x, y: pos.y), with: step)
    }
    
    static func settleLevel(_ grid: inout Grid, at pos: Pos) {
        var x = pos.x - 1
        while true {
            let pos = Pos(x: x, y: pos.y)
            let cell = get(grid, at: pos)
            if cell == .clay { break }
            grid.updateValue(.settled, forKey: pos)
            x -= 1
        }
        
        x = pos.x
        while true {
            let pos = Pos(x: x, y: pos.y)
            let cell = get(grid, at: pos)
            if cell == .clay { break }
            grid.updateValue(.settled, forKey: pos)
            x += 1
        }
    }
    
    static func flowing(_ grid: inout Grid, lesser: Int, greater: Int, y: Int) {
        var lesser = lesser
        while lesser <= greater {
            let pos = Pos(x: lesser, y: y)
            let cell = get(grid, at: pos)
            
            if cell == .clay { return }
            if cell == .open {
                grid[pos] = .flowing
            }
            lesser += 1
        }
    }
    
    static func get(_ grid: Grid, at pos: Pos) -> Cell {
        grid[pos] ?? .open
    }
}

/*
 26803 -> low
 27206 -> right
 */



/*
 static func solvePart1(input: (clays: Set<Pos>, maxClayWidth: Int)) -> String {
     let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
     var destinationURL = desktopURL.appendingPathComponent("Images")
     try? FileManager.default.removeItem(at: destinationURL)
     try? FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
     
     
     let spring = Pos(x: 500, y: 0)
     let maxY = input.clays.map { $0.y }.max()!
     let minX = input.clays.map { $0.x }.min()!
     let maxX = input.clays.map { $0.x }.max()!
     
     var reachedPos: Set<Pos> = []
     var downWaterPos: Set<Pos> = []
     var water: Set<Pos> = [spring]
     var inClayWaterLeft: Set<Pos> = []
     var inClayWaterRight: Set<Pos> = []
     var inClayWater: Set<Pos> = []
     
     func isInsideClay(_ pos: Pos, left: Bool) -> Bool {
         for diff in 1...input.maxClayWidth {
             let next: Pos
             if left {
                 next = Pos(x: pos.x - diff, y: pos.y)
             } else {
                 next = Pos(x: pos.x + diff, y: pos.y)
             }
             
             if downWaterPos.contains(next) {
                 return false
             }
             
             if input.clays.contains(next) && !reachedPos.contains(next){
                 return true
             }
         }
         
         return false
     }
     
     
     func fillClay(at pos: Pos, left: Bool) -> Pos? {
         let next: Pos
         let nextDown: Pos
         
         if left {
             next = Pos(x: pos.x - 1, y: pos.y)
             nextDown = Pos(x: pos.x - 1, y: pos.y + 1)
         } else {
             next = Pos(x: pos.x + 1, y: pos.y)
             nextDown = Pos(x: pos.x + 1, y: pos.y + 1)
         }
         
         if input.clays.contains(next) {
             return nil
         } else {
             reachedPos.insert(next)
             if !input.clays.contains(nextDown) && !reachedPos.contains(nextDown) {
                 reachedPos.insert(nextDown)
                 downWaterPos.insert(nextDown)
                 return nextDown
             } else {
                 return fillClay(at: next, left: left)
             }
         }
     }
     
     
     var count = 2
     var counter = 0
     while (!water.isEmpty || !inClayWaterLeft.isEmpty || !inClayWaterRight.isEmpty || !inClayWater.isEmpty), count > 0 {
         counter += 1
         
//            if true {
         if counter % 1000 == 0 {
//            if counter >= 1000 && counter < 1500 {
//                count -= 1
             var map = Array(repeating: Array(repeating: ".", count: 1000), count: 2000)
             for clay in input.clays {
                 map[clay.y][clay.x] = "#"
             }
             map[spring.y][spring.x] = "+"
             reachedPos.forEach {
                 map[$0.y][$0.x] = "~"
             }
             downWaterPos.forEach {
                 map[$0.y][$0.x] = "|"
             }
             
             
             
             var pixels: [Pixel] = []

//                for y in 0..<200 {// / 20 {
             for y in 0..<map.count {// / 20 {
                 for x in 450..<750 {
                     if map[y][x] == "#" {
                         pixels.append(Pixel(a: 255, r: 255, g: 255, b: 255))
                     } else if map[y][x] == "+" {
                         pixels.append(Pixel(a: 255, r: 255, g: 228, b: 18))
                     } else if map[y][x] == "|" {
                         pixels.append(Pixel(a: 255, r: 0, g: 80, b: 255))
                     } else if map[y][x] == "~" {
                         pixels.append(Pixel(a: 255, r: 28, g: 200, b: 255))
                     } else {
                         pixels.append(Pixel(a: 255, r: 0, g: 0, b: 0))
                     }
                 }
             }
             
             let width = 300
             let height = pixels.count/width
             
             let image = NSImage(pixels: pixels, width: width, height: height)//?.resize(w: width*10, h: height*10)
             destinationURL = desktopURL
                 .appendingPathComponent("Images")
                 .appendingPathComponent("my-image-\(counter).png")
             if image!.pngWrite(to: destinationURL, options: .atomic) {
                 print("File saved ------------------")
             }
             
         }
         
         
         
         

         let current: Pos
         var inClay = false
         var left = false
         if !inClayWater.isEmpty {
             inClay = true
             current = inClayWater.removeFirst()
         } else if !inClayWaterLeft.isEmpty {
             inClay = true
             left = true
             current = inClayWaterLeft.removeFirst()
         } else if !inClayWaterRight.isEmpty {
             inClay = true
             left = false
             current = inClayWaterRight.removeFirst()
         } else {
             current = water.removeFirst()
         }
         
         
         let next = Pos(x: current.x, y: current.y + 1)
         if inClay {
             print(counter, "Clay")
             
             let left = fillClay(at: current, left: true)
             let right = fillClay(at: current, left: false)
             
             if left == nil && right == nil {
                 inClayWater.insert(Pos(x: current.x, y: current.y - 1))
             } else if let left = left, right == nil {
                 water.insert(left)
             } else if let right = right, left == nil {
                 water.insert(right)
             } else if let right = right, let left = left {
                 water.insert(left)
                 water.insert(right)
             }
             
             
             
             
//                if left {
//                    if let newCurrent = fillClay(at: current, left: true) {
//                        water.insert(newCurrent)
//                    } else {
//                        let upperPos = Pos(x: current.x, y: current.y - 1)
//                        if current.y > 0, isInsideClay(upperPos, left: true) {
//                            inClayWaterLeft.insert(upperPos)
//                        }
//                    }
//                } else {
//                    if let newCurrent = fillClay(at: current, left: false) {
//                        water.insert(newCurrent)
//                    } else {
//                        let upperPos = Pos(x: current.x, y: current.y - 1)
//                        if current.y > 0, isInsideClay(upperPos, left: false) {
//                            inClayWaterRight.insert(upperPos)
//                        }
//                    }
//                }
         } else if input.clays.contains(next) {
             if isInsideClay(current, left: true) || isInsideClay(current, left: false) {
                 inClayWater.insert(current)
             }
//                if isInsideClay(current, left: true) {
//                    inClayWaterLeft.insert(current)
//                }
//                if isInsideClay(current, left: false) {
//                    inClayWaterRight.insert(current)
//                }
         } else if reachedPos.contains(next) {
             if isInsideClay(current, left: true) && isInsideClay(current, left: false) {
                 inClayWater.insert(current)
             } else {
                 print(counter, "Nothing")
                 continue
             }
         } else {
             print(counter, "Falling")
             if next.y <= maxY {
                 downWaterPos.insert(next)
                 reachedPos.insert(next)
                 water.insert(next)
             }
         }
     }
     
//        var map = Array(repeating: Array(repeating: ".", count: 510), count: 14)
//        for clay in input {
//            map[clay.y][clay.x] = "#"
//        }
//        map[spring.y][spring.x] = "+"
//        reachedPos.forEach {
//            map[$0.y][$0.x] = "~"
//        }
//        map.forEach {
//            print($0[490...].joined())
//        }
     
     var map = Array(repeating: Array(repeating: ".", count: 1000), count: 2000)
     for clay in input.clays {
         map[clay.y][clay.x] = "#"
     }
     map[spring.y][spring.x] = "+"
     reachedPos.forEach {
         map[$0.y][$0.x] = "~"
     }
     downWaterPos.forEach {
         map[$0.y][$0.x] = "|"
     }
     
     
     
     var pixels: [Pixel] = []

     for y in 0..<map.count {// / 20 {
         for x in 450..<750 {
             if map[y][x] == "#" {
                 pixels.append(Pixel(a: 255, r: 255, g: 255, b: 255))
             } else if map[y][x] == "+" {
                 pixels.append(Pixel(a: 255, r: 255, g: 228, b: 18))
             } else if map[y][x] == "|" {
                 pixels.append(Pixel(a: 255, r: 0, g: 80, b: 255))
             } else if map[y][x] == "~" {
                 pixels.append(Pixel(a: 255, r: 28, g: 200, b: 255))
             } else {
                 pixels.append(Pixel(a: 255, r: 0, g: 0, b: 0))
             }
         }
     }
     
     let width = 300
     let height = pixels.count/width
     
     let image = NSImage(pixels: pixels, width: width, height: height)//?.resize(w: width*10, h: height*10)
     destinationURL = desktopURL
         .appendingPathComponent("Images")
         .appendingPathComponent("my-image-\(counter).png")
     if image!.pngWrite(to: destinationURL, options: .atomic) {
         print("File saved ------------------")
     }
     
     
     return "\(reachedPos.count)"
 }

 static func solvePart2(input: (clays: Set<Pos>, maxClayWidth: Int)) -> String {
     return "Add some Code here"
 }
 */
