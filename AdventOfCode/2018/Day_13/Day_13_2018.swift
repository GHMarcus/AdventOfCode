//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2018/day/13

enum Day_13_2018: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2018
    
    struct Pos: Equatable, Hashable {
        var x,y: Int
        
        var description: String { "\(x),\(y)" }
    }
    
    enum Dir: String {
        case left = "<"
        case right = ">"
        case up = "^"
        case down = "v"
    }
    
    class Cart: Equatable {
        var pos: Pos
        var dir: Dir
        var nextTurn: Dir
        var crashed: Bool
        
        static func == (lhs: Cart, rhs: Cart) -> Bool {
            lhs.pos == rhs.pos
        }
        
        init(pos: Pos, dir: Dir) {
            self.pos = pos
            self.dir = dir
            nextTurn = .left
            crashed = false
        }
        
        private func nextNextTurn() {
            switch nextTurn {
            case .left:
                nextTurn = .up
            case .right:
                nextTurn = .left
            case .up:
                nextTurn = .right
            case .down:
                fatalError()
            }
        }
        
        private func turnLeft() {
            switch dir {
            case .left: dir = .down
            case .right: dir = .up
            case .up: dir = .left
            case .down: dir = .right
            }
        }
        
        private func turnRight() {
            switch dir {
            case .left: dir = .up
            case .right: dir = .down
            case .up: dir = .right
            case .down: dir = .left
            }
        }
        
        var description: Character {
            switch dir {
            case .left: return "<"
            case .right: return ">"
            case .up: return "^"
            case .down: return "v"
            }
        }
        
        var debugDescription: String {
            "\(pos):\(dir)\(crashed ? "X" : " ")"
        }
        
        func move() {
            switch dir {
            case .left: pos.x -= 1
            case .right: pos.x += 1
            case .up: pos.y -= 1
            case .down: pos.y += 1
            }
        }
        
        func turn(_ tile: Character) {
            switch (dir, tile) {
            case (_, "+"):
                switch nextTurn {
                case .left:
                    turnLeft()
                case .right:
                    turnRight()
                case .up:
                    break
                case .down:
                    fatalError()
                }
                nextNextTurn()
            case (.right, "\\"):
                  dir = .down
            case (.left, "\\"):
                dir = .up
            case (.down, "\\"):
                  dir = .right
            case (.up, "\\"):
                dir = .left
            case (.right, "/"):
                  dir = .up
            case (.left, "/"):
                dir = .down
            case (.down, "/"):
                  dir = .left
            case (.up, "/"):
                dir = .right
            case (_, "-"), (_, "|"):
                return
            default:
                fatalError()
            }
        }
    }
    
    static func convert(input: [String]) -> (carts: [Cart], grid: [[Character]]) {
        let maxX = input.map { $0.count }.max()!
        let maxY = input.count
        
        var grid: [[Character]] = Array(repeating: Array(repeating: " ", count: maxX), count: maxY)
        let cartSymbols: Set<Character> = ["^", "v", "<", ">"]
        var carts: [Cart] = []
        for (y, line) in input.enumerated() {
            for (x, char) in line.enumerated() {
                if cartSymbols.contains(char) {
                    switch char {
                    case "^":
                        carts.append(.init(pos: .init(x: x, y: y), dir: .up))
                        grid[y][x] = "|"
                    case "v":
                        carts.append(.init(pos: .init(x: x, y: y), dir: .down))
                        grid[y][x] = "|"
                    case "<":
                        carts.append(.init(pos: .init(x: x, y: y), dir: .left))
                        grid[y][x] = "-"
                    case ">":
                        carts.append(.init(pos: .init(x: x, y: y), dir: .right))
                        grid[y][x] = "-"
                    default: fatalError()
                    }
                } else {
                    grid[y][x] = char
                }
            }
        }
        
        return (carts, grid)
    }

    static func solvePart1(input: (carts: [Cart], grid: [[Character]])) -> String {
        var carts = input.carts
        var crashPos: Pos? = nil
    runLoop:
        while true {
            carts.sort{ ($0.pos.y, $0.pos.x) < ($1.pos.y, $1.pos.x)}
            for cart in input.carts {
                let otherCartsPos = input.carts.filter{ $0 != cart }
                cart.move()
                cart.turn(input.grid[cart.pos.y][cart.pos.x])
                
                if otherCartsPos.contains(where: { $0 == cart }) {
                    crashPos = cart.pos
                    break runLoop
                }
            }
        }
        return crashPos?.description ?? ""
    }

    static func solvePart2(input: (carts: [Cart], grid: [[Character]])) -> String {
        var carts = input.carts

        while true {
            carts.sort{ ($0.pos.y, $0.pos.x) < ($1.pos.y, $1.pos.x)}
            for cart in carts {
                let otherCartsPos = carts.filter{ $0 != cart }
                cart.move()
                cart.turn(input.grid[cart.pos.y][cart.pos.x])
                
                if otherCartsPos.contains(where: { $0 == cart }) {
                    carts.forEach {
                        if $0.crashed { return }
                        $0.crashed = $0 == cart
                    }
                }
            }
            carts = carts.filter{ !$0.crashed }
            if carts.count == 1 {
                break
            }
        }
        
        return carts.first!.pos.description
    }
}
