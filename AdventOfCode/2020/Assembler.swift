//
//  Assembler.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 08.12.20.
//

struct Assembler {
    let code: [String]
    var acc = 0
    var pos = 0

    var visitedPos: Set<Int> = []

    mutating func run() -> (acc: Int, terminated: Bool) {
        while visitedPos.insert(pos).inserted {
            guard pos < code.count else {
                return (acc, false)
            }
            //print(code[pos])
            let cmp = code[pos].components(separatedBy: " ")
            let command = cmp.first ?? ""
            let value = Int(cmp.last ?? "") ?? 0

            switch command {
            case "nop":
                pos += 1
            case "acc":
                acc += value
                pos += 1
            case "jmp":
                pos += value
            default:
                fatalError("Should not be executed")
            }
        }
        return (acc, true)
    }
}
