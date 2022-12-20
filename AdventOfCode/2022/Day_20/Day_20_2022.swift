//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/20

enum Day_20_2022: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2022

    class Number {
        let value: Int64
        var order: Int
        var prev: Number?
        var next: Number?

        init(value: Int64, order: Int, prev: Number?, next: Number?) {
            self.value = value
            self.order = order
            self.prev = prev
            self.next = next
        }
    }

    static func solvePart1(input: [Int]) -> String {
        let start: Number = Number(value: Int64(input[0]), order: 1, prev: nil, next: nil)
        var current: Number = start
        start.next = current
        start.prev = current
        for line in 1..<input.count {
            let next = Number(value: Int64(input[line]), order: line+1, prev: current, next: current.next)
            current.next = next
            current = next
            start.prev = next
        }

        var moved = 0
        var zero: Number? = nil
        while true {
            let order = moved + 1
            if order > input.count {
                break
            }

            var current = start
            while current.order != order {
                current = current.next!
            }

            var moves: Int64 = 0

            if current.value < 0 {
                moves = (current.value * -1) % Int64(input.count-1)
                moves *= -1
            } else {
                moves = current.value % Int64(input.count-1)
            }

            if current.value == 0 {
                zero = current
            } else if moves.signum() == -1 {
                var destination = current
                current.prev?.next = current.next
                current.next?.prev = current.prev
                for _ in moves...0 {
                    destination = destination.prev!
                }
                current.next = destination.next
                destination.next = current

                current.prev = destination
                current.next?.prev = current
            } else if moves > 0 {
                var destination = current
                current.prev?.next = current.next
                current.next?.prev = current.prev
                for _ in 1...moves {
                    destination = destination.next!
                }
                current.next = destination.next
                destination.next = current

                current.prev = destination
                current.next?.prev = current
            }

            moved = order
        }


        var firstValue: Int64 = 0
        current = zero!
        for _ in 1...1000 {
            current = current.next!
        }
        firstValue = current.value

        var secondValue: Int64 = 0
        for _ in 1...1000 {
            current = current.next!
        }
        secondValue = current.value

        var thirdValue: Int64 = 0
        for _ in 1...1000 {
            current = current.next!
        }
        thirdValue = current.value

        return "\(firstValue+secondValue+thirdValue)"
    }

    static func solvePart2(input: [Int]) -> String {
        let decryptionKey: Int64 = 811589153
        let start: Number = Number(value: Int64(input[0])*decryptionKey, order: 1, prev: nil, next: nil)
        var current: Number = start
        start.next = current
        start.prev = current
        for line in 1..<input.count {
            let next = Number(value: Int64(input[line])*decryptionKey, order: line+1, prev: current, next: current.next)
            current.next = next
            current = next
            start.prev = next
        }

        var zero: Number? = nil
        for round in 1...10 {
            var moved = 0
            while true {
                let order = moved + 1

                if order > input.count {
                    break
                }

                var current = start
                while current.order != order {
                    current = current.next!
                }

                var moves: Int64 = 0

                if current.value < 0 {
                    moves = (current.value * -1) % Int64(input.count-1)
                    moves *= -1
                } else {
                    moves = current.value % Int64(input.count-1)
                }

                if current.value == 0 {
                    zero = current
                } else if moves.signum() == -1 {
                    var destination = current
                    current.prev?.next = current.next
                    current.next?.prev = current.prev
                    for _ in moves...0 {
                        destination = destination.prev!
                    }
                    current.next = destination.next
                    destination.next = current

                    current.prev = destination
                    current.next?.prev = current
                } else if moves > 0 {
                    var destination = current
                    current.prev?.next = current.next
                    current.next?.prev = current.prev
                    for _ in 1...moves {
                        destination = destination.next!
                    }
                    current.next = destination.next
                    destination.next = current

                    current.prev = destination
                    current.next?.prev = current
                }

                moved = order
            }
            print("Round: \(round) finished")
        }


        var firstValue: Int64 = 0
        current = zero!
        for _ in 1...1000 {
            current = current.next!
        }
        firstValue = current.value

        var secondValue: Int64 = 0
        for _ in 1...1000 {
            current = current.next!
        }
        secondValue = current.value

        var thirdValue: Int64 = 0
        for _ in 1...1000 {
            current = current.next!
        }
        thirdValue = current.value

        return "\(firstValue+secondValue+thirdValue)"
    }
}
