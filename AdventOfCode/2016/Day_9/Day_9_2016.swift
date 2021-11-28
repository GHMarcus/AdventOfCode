//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/9

enum Day_9_2016: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2016
    
    static func solvePart1(input: [String]) -> String {
        var decompressedData: [String] = []
        
        for line in input {
            let oldString = Array(line)
            var newString: [String.Element] = []
            var isMarker = false
            var marker: [String.Element] = []
            
            var counter = 0
            while counter < oldString.count {
                if oldString[counter] == "(" {
                    isMarker = true
                } else if oldString[counter] == ")" {
                    isMarker = false
                    let compression = String(marker).components(separatedBy: "x")
                    
                    for _ in 0..<Int(compression[1])! {
                        for i in 0..<Int(compression[0])! {
                            // Plus one for the closing bracket
                            newString.append(oldString[counter+i+1])
                        }
                    }
                    // Plus one for the closing bracket
                    counter += (Int(compression[0])!)
                    marker = []
                } else if isMarker {
                    marker.append(oldString[counter])
                } else {
                    newString.append(oldString[counter])
                }
                counter += 1
            }
            decompressedData.append(String(newString))
        }
        
        var sum = 0
        
        decompressedData.forEach {
            sum += $0.count
        }
        
        return "\(sum)"
    }
    
    static func solvePart2(input: [String]) -> String {
        var sum = 0
        for line in input {
            let string = Array(line)
            
            var counter = 0
            while counter < string.count {
                if string[counter] == "(" {
                    sum += decompress(startIndex: counter, str: line)
                    var jump = ""
                    for i in 1..<string.count {
                        if string[counter+i] == "x" {
                            break
                        } else {
                            jump.append(string[counter+i])
                        }
                    }
                    counter += Int(jump)!
                }
            }
        }
        
        return "\(sum)"
    }
    
    static func decompress(startIndex: Int, str: String) -> Int {
        let compression = str.suffix(str.count-startIndex)
        let closingBracket = compression.firstIndex(of: ")")!
        let compressionMarker = compression.prefix(upTo: closingBracket).dropFirst(1)//.prefix(closingBracket.utf16Offset(in: compression)).dropFirst()
        print(compressionMarker)
        let range = Int(compressionMarker.components(separatedBy: "x")[0])!
        let factor = Int(compressionMarker.components(separatedBy: "x")[1])!
        if !compression.suffix(str.count-startIndex-closingBracket.utf16Offset(in: compression)-1).prefix(range).contains("(") {
            return factor
        } else {
            return factor * decompress(startIndex: startIndex + compressionMarker.count + 2, str: str)
        }
    }
}
