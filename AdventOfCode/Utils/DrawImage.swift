//
//  DrawImage.swift
//  AdventOfCode
//
//  Created by Gollnick, Marcus on 28.11.25.
//

import AppKit

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


/// In order to save some images we need an folder to do it. So we create one. (~/Desktop/Images)
/// This also deletes the folder when starting again. This will guarantee that no older images will be there in the folder
/// You should call this function at the beginning of a solve function
/// Note: There will be a prompt, which will ask for permission to save to the desktop
func prepareImageFolder() {
    let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    let destinationURL = desktopURL.appendingPathComponent("Images")
    try? FileManager.default.removeItem(at: destinationURL)
    try? FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
}

/// This functions take an array of pixels and and will write them to (~/Desktop/Images)
/// You have to hand over a width, the height is calculated inside.
/// If you want more then one image, you can provide an id to identify and do not override the images
/// An example how you can use this function is in the declaring file
func drawImage(with pixels: [Pixel], width: Int, id: Int? = nil) {
    let width = width
    let height = pixels.count/width
    
    let image = NSImage(pixels: pixels, width: width, height: height)
    let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    let destinationURL = desktopURL
        .appendingPathComponent("Images")
        .appendingPathComponent("my-image\(id != nil ? "-\(id!)" : "").png")
    if image!.pngWrite(to: destinationURL, options: .atomic) {
        print("File saved ------------------")
    }
}

/*
 Example on how to use this functions with Year 2018 Day 17 (Water running down the sand and fill some clays)
 
 static func solvePart1(input: Grid) -> String {
     
     prepareImageFolder()
     
     var grid = input
     
 
     Do what you have to do before drawing an image...
     
     
     var pixels: [Pixel] = []

     for y in 0..<grid.count {// / 20 {
         for x in 450..<750 {
             let pos = Pos(x: x, y: y)
             if grid[pos] == .clay {
                 pixels.append(Pixel(a: 255, r: 255, g: 255, b: 255))
             } else if grid[pos] == .flowing {
                 pixels.append(Pixel(a: 255, r: 0, g: 80, b: 255))
             } else if grid[pos] == .settled {
                 pixels.append(Pixel(a: 255, r: 28, g: 200, b: 255))
             } else {
                 pixels.append(Pixel(a: 255, r: 0, g: 0, b: 0))
             }
         }
     }
     
     drawImage(with: pixels, width: 300)
     
     return "\(result)"
 }
 */
