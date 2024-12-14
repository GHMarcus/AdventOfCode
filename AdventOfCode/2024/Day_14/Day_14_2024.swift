//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/14

enum Day_14_2024: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = [Robot]

    class Robot {
        var x, y, vx, vy: Int
        
        init(x: Int, y: Int, vx: Int, vy: Int) {
            self.x = x
            self.y = y
            self.vx = vx
            self.vy = vy
        }
        
        func move(maxX: Int, maxY: Int) {
            x += vx
            y += vy
            if x < 0 {
                x = maxX - (abs(x))
            }
            
            if x >= maxX {
                x = 0 + (abs(x - maxX))
            }
            
            if y < 0 {
                y = maxY - (abs(y))
            }
            
            if y >= maxY {
                y = 0 + (abs(y - maxY))
            }
        }
    }
    
    static func convert(input: [String]) -> ConvertedInput {
        var robots: [Robot] = []
        for line in input {
            let cmp = line.components(separatedBy: " ").map { $0.dropFirst(2) }
            let pos = String(cmp[0]).components(separatedBy: ",").map { Int($0)! }
            let vel = String(cmp[1]).components(separatedBy: ",").map { Int($0)! }
            robots.append(Robot(x: pos[0], y: pos[1], vx: vel[0], vy: vel[1]))
        }
        return robots
    }

    static func solvePart1(input: ConvertedInput) -> String {
        let maxX = 101
        let maxY = 103
        let maxTime = 100
        
        for _ in 0..<maxTime {
            for robot in input {
                robot.move(maxX: maxX, maxY: maxY)
            }
        }
        
        let xHalf = maxX / 2
        let yHalf = maxY / 2
        
        let q1 = input.filter { $0.x < xHalf && $0.y < yHalf }.count
        let q2 = input.filter { $0.x > xHalf && $0.y < yHalf }.count
        let q3 = input.filter { $0.x < xHalf && $0.y > yHalf }.count
        let q4 = input.filter { $0.x > xHalf && $0.y > yHalf }.count
        
        return "\(q1 * q2 * q3 * q4)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        let maxX = 101
        let maxY = 103
        
        // Solved time visually and found 6888
        // Then saw that the bottom frame of the picture is exactly on the middle line
        // Then checked when 5 robots build a line at the center and found it.
        var time = 0
        while true {
            time += 1
            for robot in input {
                robot.move(maxX: maxX, maxY: maxY)
            }
            
            let pos1 = input.first { $0.x == maxX/2 && $0.y == maxY/2 }
            let pos2 = input.first { $0.x == maxX/2 - 1 && $0.y == maxY/2 }
            let pos3 = input.first { $0.x == maxX/2 + 1 && $0.y == maxY/2 }
            let pos4 = input.first { $0.x == maxX/2 - 2 && $0.y == maxY/2 }
            let pos5 = input.first { $0.x == maxX/2 + 2 && $0.y == maxY/2 }
            
            if pos1 != nil && pos2 != nil && pos3 != nil && pos4 != nil && pos5 != nil {
                break
            }
        }
        
        var map = Array(repeating: Array(repeating: ".", count: maxX), count: maxY)
        for robot in input {
            map[robot.y][robot.x] = "#"
        }
        
        print("")
        print(map[maxY/2 - 1].joined())
        print(map[maxY/2].joined())
        print(map[maxY/2 + 1].joined())
        print("")
        
        map.forEach {
            print($0.joined())
        }
        
        return "\(time)"
    }
}
