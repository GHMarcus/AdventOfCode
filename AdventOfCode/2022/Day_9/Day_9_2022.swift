//
//  Day_9.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/9

enum Day_9_2022: Solvable {
    static var day: Input.Day = .Day_9
    static var year: Input.Year = .Year_2022

    struct Position: Equatable, Hashable {
        var x,y: Int

        func isNotTouching(_ other: Position) -> Bool {
            !(abs(x - other.x) <= 1 && abs(y - other.y) <= 1)
        }
    }

    static func solvePart1(input: [String]) -> String {

        var tail = Position(x: 0, y: 0)
        var head = Position(x: 0, y: 0)

        var visitedPositions: Set<Position> = [tail]

        for line in input {
            let cmp = line.components(separatedBy: " ")
            let direction = cmp[0]
            let distance = Int(cmp[1])!

            for _ in 1...distance {
                head = move(head, in: direction)

                guard tail.isNotTouching(head) else { continue }

                tail = snap(tail, to: head)
                visitedPositions.insert(tail)
            }
        }

        return "\(visitedPositions.count)"
    }

    static func solvePart2(input: [String]) -> String {

        var rope = Array(repeating: Position(x: 0, y: 0), count: 10)

        var visitedPositions: Set<Position> = [rope.last!]

        for line in input {
            let cmp = line.components(separatedBy: " ")
            let direction = cmp[0]
            let distance = Int(cmp[1])!

            for _ in 1...distance {

                rope[0] = move(rope[0], in: direction)

                for r in 1..<rope.count {
                    let head = rope[r-1]
                    let tail = rope[r]

                    guard tail.isNotTouching(head) else { continue }

                    rope[r] = snap(tail, to: head)
                }
                visitedPositions.insert(rope.last!)
            }
        }

        return "\(visitedPositions.count)"
    }

    static func move(_ head: Position, in direction: String) -> Position {
        var head = head
        switch direction {
        case "R":
            head.x += 1
        case "L":
            head.x -= 1
        case "U":
            head.y += 1
        case "D":
            head.y -= 1
        default:
            fatalError()
        }
        return head
    }

    static func snap(_ tail: Position, to head: Position) -> Position {
        var tail = tail

        func moveY() {
            tail.y += head.y < tail.y ? -1 : 1
        }

        func moveX() {
            tail.x += head.x < tail.x ? -1 : 1
        }

        if head.x == tail.x {
            moveY()
        } else if head.y == tail.y {
            moveX()
        } else {
            moveY()
            moveX()
        }
        return tail
    }
}
