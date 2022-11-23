//
//  Day_3.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/3

enum Day_3_2017: Solvable {
    static var day: Input.Day = .Day_3
    static var year: Input.Year = .Year_2017

    static func solvePart1(input: [Int]) -> String {
        let number = input.first!
        
        var a = 1
        while a*a < number {
            a += 2
        }
        
        // Clockwise means lower bound is site 0, left bound is site 1, upper bound is site 2, right bound is site 3
        var diff = a*a-number
        var site = 0
        
        while diff >= a {
            site += 1
            diff -= (a-1)
        }
        
        let numberPos: (x:Int,y:Int)
        let portPos: (x:Int,y:Int) = ((a-1)/2, (a-1)/2)
        
        switch site {
        case 0:
            numberPos = (a-1-diff, a-1)
        case 1:
            numberPos = (0, a-1-diff)
        case 2:
            numberPos = (diff, 0)
        case 3:
            numberPos = (a-1, diff)
        default:
            fatalError("Site greater then 3 is a loop")
        }
        
        print(portPos)
        print("\(number) -> \(numberPos)")
        
        return "\(abs(portPos.x - numberPos.x) + abs(portPos.y - numberPos.y))"
    }

    static func solvePart2(input: [Int]) -> String {
        enum Direction {
            case right, left, up, down
        }
        
        var number = input.first!
        
        var a = 1
        while a*a < number {
            a += 2
        }
        
        var memory = Array(repeating: Array(repeating: 0, count: a), count: a)
        let portPos: (x:Int,y:Int) = ((a-1)/2, (a-1)/2)
        memory[portPos.y][portPos.x] = 1
        var currentPos = portPos
        var distance = 1
        
    test:
        while true {
            var directions: [Direction] = [.right, .up, .left, .down, .right]
            var currentDirection = directions.removeFirst()
            
        round:
            while true {
                while true {
                    switch currentDirection {
                    case .right:
                        if currentPos.x + 1 <= portPos.x + distance {
                            currentPos.x += 1
                        } else {
                            if directions.isEmpty {
                                break round
                            }
                            currentDirection = directions.removeFirst()
                            continue
                        }
                    case .left:
                        if currentPos.x - 1 >= portPos.x - distance {
                            currentPos.x -= 1
                        } else {
                            if directions.isEmpty {
                                break round
                            }
                            currentDirection = directions.removeFirst()
                            continue
                        }
                    case .up:
                        if currentPos.y - 1 >= portPos.y - distance {
                            currentPos.y -= 1
                        } else {
                            if directions.isEmpty {
                                break round
                            }
                            currentDirection = directions.removeFirst()
                            continue
                        }
                    case .down:
                        if currentPos.y + 1 <= portPos.y + distance {
                            currentPos.y += 1
                        } else {
                            if directions.isEmpty {
                                break round
                            }
                            currentDirection = directions.removeFirst()
                            continue
                        }
                    }
                    let newNumber = countNeighbours(x: currentPos.x, y: currentPos.y, in: memory)
                    if newNumber > number {
                        number = newNumber
                        break test
                    }
                    memory[currentPos.y][currentPos.x] = newNumber
                    break
                }
            }
            distance += 1
        }
        
        return "\(number)"
    }
    
    static func countNeighbours(x: Int, y: Int, in memory: [[Int]]) -> Int {
        let neighbours = [(x-1,y-1), (x,y-1), (x+1,y-1),
                          (x-1,y  ),          (x+1,y  ),
                          (x-1,y+1), (x,y+1), (x+1,y+1)]
        
        var sum = 0
        for neighbour in neighbours {
            if neighbour.0 >= 0 && neighbour.1 >= 0 && neighbour.0 < memory[0].count && neighbour.1 < memory.count {
                sum += memory[neighbour.1][neighbour.0]
            }
        }
        
        return sum
    }
}
