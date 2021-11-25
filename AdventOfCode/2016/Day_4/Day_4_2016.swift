//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/4

enum Day_4_2016: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2016

    static func solvePart1(input: [String]) -> String {
        var totalCheckSum = 0
        for line in input {
            //aaaaa-bbb-z-y-x-123[abxyz]
            var comps = line.components(separatedBy: "-")
            let givenCheckSum = comps
                .removeLast()
                .dropLast()
                .components(separatedBy: "[")
            
            let occurrences = comps.joined().getCountedCharacters
            let checkSum = occurrences                  // ["z": 1, "y": 1, "b": 3, "a": 5, "x": 1]
                .sorted { $0.key < $1.key }             // First sort key: [(key: "a", value: 5), (key: "b", value: 3), (key: "x", value: 1), (key: "y", value: 1), (key: "z", value: 1)]
                .sorted { $0.value > $1.value }         // Then sort values [(key: "a", value: 5), (key: "b", value: 3), (key: "y", value: 1), (key: "z", value: 1), (key: "x", value: 1)]
                .prefix(upTo: 5)
                .map { $0.key }                         // ["a", "b", "x", "y", "z"]

            if String(checkSum) == givenCheckSum[1] {
                totalCheckSum += Int(givenCheckSum[0]) ?? 0
            }
        }
        
        return "\(totalCheckSum)"
    }

    static func solvePart2(input: [String]) -> String {
        var dataToDecrypt: [(String, Int)] = []
        var northPoleObjectStorageId = 0
        
        for line in input {
            //aaaaa-bbb-z-y-x-123[abxyz]
            var comps = line.components(separatedBy: "-")
            let givenCheckSum = comps
                .removeLast()
                .dropLast()
                .components(separatedBy: "[")
            
            let occurrences = comps.joined().getCountedCharacters
            let checkSum = occurrences                  // ["z": 1, "y": 1, "b": 3, "a": 5, "x": 1]
                .sorted { $0.key < $1.key }             // First sort key: [(key: "a", value: 5), (key: "b", value: 3), (key: "x", value: 1), (key: "y", value: 1), (key: "z", value: 1)]
                .sorted { $0.value > $1.value }         // Then sort values [(key: "a", value: 5), (key: "b", value: 3), (key: "y", value: 1), (key: "z", value: 1), (key: "x", value: 1)]
                .prefix(upTo: 5)
                .map { $0.key }                         // ["a", "b", "x", "y", "z"]

            if String(checkSum) == givenCheckSum[1] {
                let data = line.components(separatedBy: "[")[0].replacingOccurrences(of: givenCheckSum[0], with: "")
                dataToDecrypt.append((data, Int(givenCheckSum[0]) ?? 0))
            }
        }
        
        for data in dataToDecrypt {
            let cipher = createCipher(for: data.1)
            var newData = Array(data.0)
            for i in 0..<newData.count {
                let letter = newData[i]
                let shift = cipher.first { $0.0 == letter }
                newData[i] = shift!.1
            }
            
            if String(newData).contains("northpole") {
                northPoleObjectStorageId = data.1
                break
            }
        }
        
        
        return "\(northPoleObjectStorageId)"
    }
}

extension Day_4_2016 {
    static func createCipher(for shift: Int) -> [(String.Element, String.Element)] {
        let letters: [String.Element] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        let actualShift = shift%letters.count
        var cipher: [(String.Element, String.Element)] = []
        
        for letter in letters {
            let indexOfLetter = letters.firstIndex(of: letter)!
            let indexOfNewLetter = (indexOfLetter + actualShift) > (letters.count - 1)
                ? indexOfLetter + actualShift - letters.count
                : indexOfLetter + actualShift
            cipher.append((letter, letters[indexOfNewLetter]))
        }
        
        cipher.append(("-", " "))
        
        return cipher
    }
}
