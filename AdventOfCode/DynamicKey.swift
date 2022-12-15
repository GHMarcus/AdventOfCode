//
//  DynamicKeys.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 10.12.22.
//

struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.intValue = intValue
        stringValue = "\(intValue)"
    }
}
