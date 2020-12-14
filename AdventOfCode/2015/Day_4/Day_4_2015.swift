//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/4

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

enum Day_4_2015: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2015

    static func solvePart1(input: [String]) -> String {
        var number = 0
        let secretKey = input[0]
        while true {
            let md5Data = MD5(string:"\(secretKey)\(number)")
            let md5Hex = md5Data.map{ String(format: "%02hhx", $0) }.joined()
            if md5Hex.dropLast(md5Hex.count - 5) == "00000" {
                print(md5Hex)
                return "\(number)"
            } else {
                number += 1
            }
        }
    }

    static func solvePart2(input: [String]) -> String {
        "Takes too long"
//        var number = 0
//        let secretKey = input[0]
//        while true {
//            let md5Data = MD5(string:"\(secretKey)\(number)")
//            let md5Hex = md5Data.map{ String(format: "%02hhx", $0) }.joined()
//            if md5Hex.dropLast(md5Hex.count - 5) == "000000" {
//                print(md5Hex)
//                return "\(number)"
//            } else {
//                number += 1
//            }
//        }
    }

    static func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}
