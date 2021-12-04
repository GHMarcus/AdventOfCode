//
//  Day_4.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2021/day/4

enum Day_4_2021: Solvable {
    static var day: Input.Day = .Day_4
    static var year: Input.Year = .Year_2021

    class Value {
        let number: Int
        var isMarked:  Bool

        init(number: Int) {
            self.number = number
            isMarked = false
        }
    }

    class Board {
        let id: Int
        var numbers: [[Value]] = []

        init(id: Int) {
            self.id = id
        }

        var hasBingo: Bool {
            for row in 0..<numbers.count {
                let bingo = numbers[row].reduce(true) { partialResult, value in
                    partialResult && value.isMarked
                }
                if bingo {
                    return true
                }
            }

            for column in 0..<numbers[0].count {
                var bingo = true
                for row in 0..<numbers.count {
                    bingo = bingo && numbers[row][column].isMarked
                }
                if bingo {
                    return true
                }
            }
            return false
        }

        var winningSum: Int {
            var sum = 0
            for row in numbers {
                for value in row {
                    if !value.isMarked {
                        sum += value.number
                    }
                }
            }
            return sum
        }

        func markNumber(_ number: Int) {
            for row in 0..<numbers.count {
                for column in 0..<numbers[0].count {
                    if numbers[row][column].number == number {
                        numbers[row][column].isMarked = true
                        return
                    }
                }
            }
        }
    }

    static func solvePart1(input: [String]) -> String {
        let drawnNumbers = input[0].components(separatedBy: ",").compactMap { Int($0) }
        var boards: [Board] = []

        var id = 1
        var board = Board(id: id)

        for i in 2..<input.count {
            if input[i] == "" {
                boards.append(board)
                id += 1
                board = Board(id: id)
                continue
            }
            let line = input[i].components(separatedBy: " ").compactMap { Int($0) } .compactMap { Value(number: $0) }
            board.numbers.append(line)
        }
        boards.append(board)

        var score: Int = 0
    round: for drawnNumber in drawnNumbers {
        for board in boards {
            board.markNumber(drawnNumber)
            if board.hasBingo {
                score = board.winningSum * drawnNumber
                break round
            }
        }
    }

        return "\(score)"
    }

    static func solvePart2(input: [String]) -> String {
        let drawnNumbers = input[0].components(separatedBy: ",").compactMap { Int($0) }
        var boards: [Board] = []

        var id = 1
        var board = Board(id: id)

        for i in 2..<input.count {
            if input[i] == "" {
                boards.append(board)
                id += 1
                board = Board(id: id)
                continue
            }
            let line = input[i].components(separatedBy: " ").compactMap { Int($0) } .compactMap { Value(number: $0) }
            board.numbers.append(line)
        }
        boards.append(board)

        var score: Int = 0
        var ids = boards.map { $0.id }
    round: for drawnNumber in drawnNumbers {
        for board in 0..<boards.count {
            boards[board].markNumber(drawnNumber)
            if boards[board].hasBingo {
                if ids.count == 1 && boards[board].id == ids[0] {
                    score = boards[ids[0]-1].winningSum * drawnNumber
                    break round
                } else {
                    ids.removeAll { $0 == boards[board].id }
                    continue
                }
            }
        }
    }

        return "\(score)"
    }
}
