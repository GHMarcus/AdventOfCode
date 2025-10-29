//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/21

enum Day_21_2016: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2016
    
    enum Dir {
        case left, right
    }
    
    enum Command {
        case swapPosition(Int, Int)
        case swapLetter(Character, Character)
        case rotateDir(Dir, Int)
        case rotateBase(Character)
        case reverse(Int, Int)
        case move(Int, Int)
    }
    
    class Scrambler {
        let commands: [Command]
        let password: String
        
        init(commands: [Command], password: String) {
            self.commands = commands
            self.password = password
        }
        
        private func swapPosition(_ x: Int, _ y: Int, in password: inout [Character]) {
            let tmp = password[x]
            password[x] = password[y]
            password[y] = tmp
        }
        
        private func swapLetter(_ a: Character, _ b: Character, in password: inout [Character]) {
            let indexA = password.firstIndex(of: a)!
            let indexB = password.firstIndex(of: b)!
            swapPosition(indexA, indexB, in: &password)
        }
        
        private func rotate(dir: Dir, count: Int, isReverse: Bool, in password: inout [Character]) {
            var newPassword = password
            for _ in 0..<count {
                if isReverse {
                    switch dir {
                    case .right:
                        let c = newPassword.removeFirst()
                        newPassword.append(c)
                    case .left:
                        let c = newPassword.removeLast()
                        newPassword.insert(c, at: 0)
                    }
                } else {
                    switch dir {
                    case .left:
                        let c = newPassword.removeFirst()
                        newPassword.append(c)
                    case .right:
                        let c = newPassword.removeLast()
                        newPassword.insert(c, at: 0)
                    }
                }
            }
            
            password = newPassword
        }
        
        private func rotate(base c: Character, in password: [Character]) -> [Character] {
            let index = password.firstIndex(of: c)!
            let n = 1 + index + (index >= 4 ? 1 : 0)
            var newPassword = password
            for _ in 0..<n {
                let c = newPassword.removeLast()
                newPassword.insert(c, at: 0)
            }
            return newPassword
        }
        
        private func reverse(_ x: Int, _ y: Int, in password: inout [Character]) {
            if x == 0 {
                let leftPart = password[0...y]
                let rightPart = password[(y+1)...]
                password = leftPart.reversed() + rightPart
            } else  if y == password.count - 1 {
                let leftPart = password[0..<x]
                let rightPart = password[x...]
                password = leftPart + rightPart.reversed()
            } else {
                let leftPart = password[0..<x]
                let middlePart = password[x...y]
                let rightPart = password[(y+1)...]
                password = leftPart + middlePart.reversed() + rightPart
            }
        }
        
        private func move(_ x: Int, _ y: Int, in password: inout [Character]) {
            let c = password.remove(at: x)
            password.insert(c, at: y)
        }
        
        func run() -> String {
            var password = Array(self.password)
            for command in commands {
                switch command {
                case .swapPosition(let x, let y):
                    swapPosition(x, y, in: &password)
                case .swapLetter(let a, let b):
                    swapLetter(a, b, in: &password)
                case .rotateDir(let dir, let n):
                    rotate(dir: dir, count: n, isReverse: false, in: &password)
                case .rotateBase(let c):
                    password = rotate(base: c, in: password)
                case .reverse(let x, let y):
                    reverse(x, y, in: &password)
                case .move(let x, let y):
                    move(x, y, in: &password)
                }
            }
            return String(password)
        }
        
        func reverseRun() -> String {
            var password = Array(self.password)
            for command in commands.reversed() {
                switch command {
                case .swapPosition(let x, let y):
                    swapPosition(x, y, in: &password)
                case .swapLetter(let a, let b):
                    swapLetter(a, b, in: &password)
                case .rotateDir(let dir, let n):
                    rotate(dir: dir, count: n, isReverse: true, in: &password)
                case .rotateBase(let c):
                    var newPassword = password
                    while true {
                        let rc = newPassword.removeFirst()
                        newPassword.append(rc)
                        
                        if password == rotate(base: c, in: newPassword) {
                            break
                        }
                    }
                    password = newPassword
                case .reverse(let x, let y):
                    reverse(x, y, in: &password)
                case .move(let x, let y):
                    move(y, x, in: &password)
                }
            }
            return String(password)
        }
    }
    
    static func convert(input: [String]) -> [Command] {
        var commands: [Command] = []
        for line in input {
            let cmp = line.components(separatedBy: " ")
            if cmp[0] == "swap" {
                if cmp[1] == "position" {
                    commands.append(.swapPosition(Int(cmp[2])!, Int(cmp[5])!))
                } else {
                    commands.append(.swapLetter(Character(cmp[2]), Character(cmp[5])))
                }
            } else if cmp[0] == "rotate" {
                if cmp[1] == "based" {
                    commands.append(.rotateBase(Character(cmp[6])))
                } else {
                    let dir = cmp[1] == "left" ? Dir.left : Dir.right
                    commands.append(.rotateDir(dir, Int(cmp[2])!))
                }
            } else if cmp[0] == "reverse" {
                commands.append(.reverse(Int(cmp[2])!, Int(cmp[4])!))
            } else if cmp[0] == "move" {
                commands.append(.move(Int(cmp[2])!, Int(cmp[5])!))
            } else {
                fatalError(line)
            }
        }
        return commands
    }
    

    static func solvePart1(input: [Command]) -> String {
        let scrambler = Scrambler(commands: input, password: "abcdefgh")
        let result = scrambler.run()
        return result
    }

    static func solvePart2(input: [Command]) -> String {
        let scrambler = Scrambler(commands: input, password: "fbgdceah")
        let result = scrambler.reverseRun()
        return result
    }
}
