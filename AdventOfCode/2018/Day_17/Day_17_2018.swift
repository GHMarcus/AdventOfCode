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

    static func solvePart1(input: [String]) -> String {
        
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        var destinationURL = desktopURL.appendingPathComponent("Images")
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
        
        
        
        var map: [[Character]] = []
        var clay: [(x: Int, y: Int)] = []
        
        var maxX = 0
        var maxY = 0
        
        var minx = Int.max
        
        for line in input {
            let cmp = line.components(separatedBy: ", ")
            let xStr = cmp.filter { $0.contains("x") }.first!.dropFirst(2)
            let yStr = cmp.filter { $0.contains("y") }.first!.dropFirst(2)
            if xStr.contains("..") {
                let xRange = xStr.components(separatedBy: "..").map { Int($0)! }
                let y = Int(yStr)!
                for x in xRange[0]...xRange[1] {
                    clay.append((x,y))
                    maxX = x > maxX ? x : maxX
                    maxY = y > maxY ? y : maxY
                    
                    minx = x < minx ? x : minx
                }
            } else {
                let yRange = yStr.components(separatedBy: "..").map { Int($0)! }
                let x = Int(xStr)!
                for y in yRange[0]...yRange[1] {
                    clay.append((x,y))
                    maxX = x > maxX ? x : maxX
                    maxY = y > maxY ? y : maxY
                    
                    minx = x < minx ? x : minx
                }
            }
        }
        
        map = Array(repeating: Array(repeating: ".", count: maxX+1), count: maxY+1)
        
        clay.forEach {
            map[$0.y][$0.x] = "#"
        }
        
        map[0][500] = "+"
        //        print(maxX)
        //        print(maxY)
        //        print()
        //        map.printLines()
        
        
        var round = 0
        
        enum Direction: String {
            case down, left, right, back
        }
        
        struct Point {
            var x, y: Int
            var nextDirection: Direction
        }
    
        var openPoints: [Point?] = [Point(x: 500, y: 0, nextDirection: .down)]
//        var lastDownPoints: [Point] = []
        var lastDownPoint: Point? = nil
        
        while round < 20000 {
//            print("++++++++++++++++++++++")
//            openPoints.printLines()
//            print("++++++++++++++++++++++")
            let lastOpenPoint = openPoints.popLast() ?? nil
            guard var nextPoint = lastOpenPoint ?? lastDownPoint ?? (openPoints.popLast() ?? nil) else { //?? lastDownPoints.popLast() else {
                print("lastOne \(round)")
                break
            }
            
            switch nextPoint.nextDirection {
            case .down:
                nextPoint.y += 1
            case .left:
//                if map[nextPoint.y+1][nextPoint.x] == "." {
//                    nextPoint.nextDirection = .down
//                    openPoints.append(nextPoint)
//                    continue
//                } else {
                    nextPoint.x -= 1
//                }
            case .right:
//                if map[nextPoint.y+1][nextPoint.x] == "." {
//                    nextPoint.nextDirection = .down
//                    openPoints.append(nextPoint)
//                    continue
//                } else {
                    nextPoint.x += 1
//                }
            case .back:
                openPoints.append(nil)
                nextPoint.y -= 1
                nextPoint.nextDirection = .right
                openPoints.append(nextPoint)
                nextPoint.nextDirection = .left
                openPoints.append(nextPoint)
                nextPoint.nextDirection = .back
                lastDownPoint = nextPoint
//                lastDownPoints.append(nextPoint)
                continue
            }
            
            if nextPoint.x >= map[0].count || nextPoint.y >= map.count || nextPoint.x < 0 {
                if openPoints.isEmpty {
                    lastDownPoint = nil
                }
                continue
            }
            
            if nextPoint.nextDirection != .down, nextPoint.y < map.count-1, map[nextPoint.y+1][nextPoint.x] == "." {
//                mustDown = true
                nextPoint.nextDirection = .down
                openPoints.append(nil)
            }
            
            let next = map[nextPoint.y][nextPoint.x]
            
            if next == "." {
                switch nextPoint.nextDirection {
                case .down:
                    map[nextPoint.y][nextPoint.x] = "|"
                    nextPoint.nextDirection = .down
                    openPoints.append(nextPoint)
                    nextPoint.nextDirection = .back
                    lastDownPoint = nextPoint
                case .left:
                    map[nextPoint.y][nextPoint.x] = "~"
                    nextPoint.nextDirection = .left
                    openPoints.append(nextPoint)
                case .right:
                    map[nextPoint.y][nextPoint.x] = "~"
                    nextPoint.nextDirection = .right
                    openPoints.append(nextPoint)
                case .back:
                    continue
                }
            } else if next == "#" {
                switch nextPoint.nextDirection {
                case .down:
                    nextPoint.y -= 1
                    nextPoint.nextDirection = .right
                    openPoints.append(nextPoint)
                    nextPoint.nextDirection = .left
                    openPoints.append(nextPoint)
                    nextPoint.nextDirection = .back
                    lastDownPoint = nextPoint
//                    openPoints.append(nil)
//                    lastDownPoints.append(nextPoint)
                case .left, .right, .back:
                    continue
                }
                
                
                
                
                
            } else if next == "|" || next == "~" {
                continue
            } else {
                print("No next field found for: \(nextPoint)")
                break
            }
            
            
            
            
            
            
            
            // Draw Image
            
//            guard round > 1200 else {
//                round += 1
//                continue
//            }
//
//            var pixels: [Pixel] = []
//
//            for y in 0..<map.count / 20 {
//                for x in minx..<map[0].count {
//                    if map[y][x] == "#" {
//                        pixels.append(Pixel(a: 255, r: 255, g: 255, b: 255))
//                    } else if map[y][x] == "+" {
//                        pixels.append(Pixel(a: 255, r: 255, g: 228, b: 18))
//                    } else if map[y][x] == "|" {
//                        pixels.append(Pixel(a: 255, r: 28, g: 80, b: 255))
//                    } else if map[y][x] == "~" {
//                        pixels.append(Pixel(a: 255, r: 28, g: 200, b: 255))
//                    } else {
//                        pixels.append(Pixel(a: 255, r: 0, g: 0, b: 0))
//                    }
//                }
//            }
//
//            let width = maxX+1 - minx
//            let height = pixels.count/width
//
//            let image = NSImage(pixels: pixels, width: width, height: height)?.resize(w: width*10, h: height*10)
//            let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//            let destinationURL = desktopURL
//                .appendingPathComponent("Images")
//                .appendingPathComponent("my-image-\(round).png")
//            if image!.pngWrite(to: destinationURL, options: .atomic) {
//                print("File saved ------------------")
//            }
            
            
            round += 1
            if round > 1000000 {
                print("Maybe too long?")
                break
            }
        }
        
        var pixels: [Pixel] = []

        for y in 0..<map.count {// / 20 {
            for x in minx..<map[0].count {
                if map[y][x] == "#" {
                    pixels.append(Pixel(a: 255, r: 255, g: 255, b: 255))
                } else if map[y][x] == "+" {
                    pixels.append(Pixel(a: 255, r: 255, g: 228, b: 18))
                } else if map[y][x] == "|" {
                    pixels.append(Pixel(a: 255, r: 28, g: 80, b: 255))
                } else if map[y][x] == "~" {
                    pixels.append(Pixel(a: 255, r: 28, g: 200, b: 255))
                } else {
                    pixels.append(Pixel(a: 255, r: 0, g: 0, b: 0))
                }
            }
        }
        
        let width = maxX+1 - minx
        let height = pixels.count/width
        
        let image = NSImage(pixels: pixels, width: width, height: height)//?.resize(w: width*10, h: height*10)
        destinationURL = desktopURL
            .appendingPathComponent("Images")
            .appendingPathComponent("my-image-\(round).png")
        if image!.pngWrite(to: destinationURL, options: .atomic) {
            print("File saved ------------------")
        }
        
        
        var waterTouchedCount = 0
        
        for line in map {
            for point in line {
                if point == "|" || point == "~" {
                    waterTouchedCount += 1
                }
            }
        }
        
        
        
        print(round)
        return "\(waterTouchedCount)"
    }

    static func solvePart2(input: [String]) -> String {
        return "Add some Code here"
    }
}

public struct Pixel {
    var a,r,g,b: UInt8
}

extension NSImage {
    convenience init?(pixels: [Pixel], width: Int, height: Int) {
        guard width > 0 && height > 0, pixels.count == width * height else { return nil }
        var data = pixels
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<Pixel>.size) as CFData)
        else { return nil }
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * MemoryLayout<Pixel>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent)
        else { return nil }
        self.init(cgImage: cgim, size: NSSize(width: width, height: height))
    }
    
    func resize(w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        self.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, size.width, size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}


/*
 static func solvePart1(input: [String]) -> String {
     
     let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
     var destinationURL = desktopURL.appendingPathComponent("Images")
     try? FileManager.default.removeItem(at: destinationURL)
     try? FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
     
     
     
     var map: [[Character]] = []
     var clay: [(x: Int, y: Int)] = []
     
     var maxX = 0
     var maxY = 0
     
     var minx = Int.max
     
     for line in input {
         let cmp = line.components(separatedBy: ", ")
         let xStr = cmp.filter { $0.contains("x") }.first!.dropFirst(2)
         let yStr = cmp.filter { $0.contains("y") }.first!.dropFirst(2)
         if xStr.contains("..") {
             let xRange = xStr.components(separatedBy: "..").map { Int($0)! }
             let y = Int(yStr)!
             for x in xRange[0]...xRange[1] {
                 clay.append((x,y))
                 maxX = x > maxX ? x : maxX
                 maxY = y > maxY ? y : maxY
                 
                 minx = x < minx ? x : minx
             }
         } else {
             let yRange = yStr.components(separatedBy: "..").map { Int($0)! }
             let x = Int(xStr)!
             for y in yRange[0]...yRange[1] {
                 clay.append((x,y))
                 maxX = x > maxX ? x : maxX
                 maxY = y > maxY ? y : maxY
                 
                 minx = x < minx ? x : minx
             }
         }
     }
     
     map = Array(repeating: Array(repeating: ".", count: maxX+1), count: maxY+1)
     
     clay.forEach {
         map[$0.y][$0.x] = "#"
     }
     
     map[0][500] = "+"
     //        print(maxX)
     //        print(maxY)
     //        print()
     //        map.printLines()
     
     let height = maxY+1
     let width = maxX+1 - minx
     
     var round = 0
     var mustDown = false
     
     enum Direction: String {
         case down, left, right, back
     }
 
 
     var leftWaterPos: (Int,Int)? = nil
     var rightWaterPos: (Int,Int)? = nil
     var lastDown = (500,0)
     var currentDirection = Direction.down
     
     while round < 100{//1970 {
         
         var nextPos: (Int,Int)
         
         if !mustDown, let left = leftWaterPos {
             currentDirection = .left
             nextPos = left
         } else if !mustDown, let right = rightWaterPos {
             currentDirection = .right
             nextPos = right
         } else if mustDown {
             mustDown = false
             currentDirection = .back
             nextPos = lastDown
         } else {
             currentDirection = .back
             nextPos = lastDown
         }
         
         if nextPos.0+1 >= map[0].count || nextPos.1+1 >= map.count {
             if leftWaterPos != nil {
                 leftWaterPos = nil
                 continue
             } else if rightWaterPos != nil {
                 rightWaterPos = nil
                 break
             }
         }
         
         if currentDirection != .down, map[nextPos.1+1][nextPos.0] == "." {
             mustDown = true
             currentDirection = .down
         }
         
         switch currentDirection {
         case .down:
             nextPos.1 += 1
         case .left:
             nextPos.0 -= 1
         case .right:
             nextPos.0 += 1
         case .back:
             lastDown.1 -= 1
             leftWaterPos = nextPos
             rightWaterPos = nextPos
             continue
         }
         
         let next = map[nextPos.1][nextPos.0]
         
         if next == "." {
             switch currentDirection {
             case .down:
                 map[nextPos.1][nextPos.0] = "|"
                 lastDown = nextPos
             case .left:
                 map[nextPos.1][nextPos.0] = "~"
                 leftWaterPos = nextPos
             case .right:
                 map[nextPos.1][nextPos.0] = "~"
                 rightWaterPos = nextPos
             case .back:
                 leftWaterPos = nil
                 rightWaterPos = nil
                 lastDown = nextPos
             }
         } else if next == "#" {
             switch currentDirection {
             case .down:
                 leftWaterPos = nextPos
                 rightWaterPos = nextPos
             case .left:
                 leftWaterPos = nil
             case .right:
                 rightWaterPos = nil
             case .back:
                 fatalError("What the heck is here wrong?")
             }
         } else {
             fatalError("Now next field found for: \(nextPos)")
         }
         
         
         
         
         
         // Draw Image
         
//            guard round > 1955 else {
//                round += 1
//                continue
//            }

         var pixels: [Pixel] = []

         for y in 0..<map.count {/// 10 {
             for x in minx..<map[0].count {
                 if map[y][x] == "#" {
                     pixels.append(Pixel(a: 255, r: 255, g: 255, b: 255))
                 } else if map[y][x] == "+" {
                     pixels.append(Pixel(a: 255, r: 255, g: 228, b: 18))
                 } else if map[y][x] == "|" {
                     pixels.append(Pixel(a: 255, r: 28, g: 80, b: 255))
                 } else if map[y][x] == "~" {
                     pixels.append(Pixel(a: 255, r: 28, g: 200, b: 255))
                 } else {
                     pixels.append(Pixel(a: 255, r: 0, g: 0, b: 0))
                 }
             }
         }
         
         let width = maxX+1 - minx
         let height = pixels.count/width
         
         let image = NSImage(pixels: pixels, width: width, height: height)?.resize(w: width*10, h: height*10)
         let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
         var destinationURL = desktopURL
             .appendingPathComponent("Images")
             .appendingPathComponent("my-image-\(round).png")
         if image!.pngWrite(to: destinationURL, options: .atomic) {
             print(currentDirection)
             print(leftWaterPos)
             print(rightWaterPos)
             print(lastDown)
             print(next)
             
             
             
             print("File saved ------------------")
         }
         
         
         round += 1
         if round > 1000000 {
             return "Maybe too long?"
         }
     }
     
     
     var waterTouchedCount = 0
     
     for line in map {
         for point in line {
             if point == "|" || point == "~" {
                 waterTouchedCount += 1
             }
         }
     }
     
     
     
     print(round)
     return "\(waterTouchedCount)"
 }
 */
