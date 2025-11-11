//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/20

enum Day_20_2017: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2017
    
    class Particle {
        var x, y, z, vx, vy, vz: Int
        let ax, ay, az, id: Int
        
        init(x: Int, y: Int, z: Int, vx: Int, vy: Int, vz: Int, ax: Int, ay: Int, az: Int, id: Int) {
            self.x = x
            self.y = y
            self.z = z
            self.vx = vx
            self.vy = vy
            self.vz = vz
            self.ax = ax
            self.ay = ay
            self.az = az
            self.id = id
        }
        
        var desc: String {
            "p=<\(x),\(y),\(z)> v=<\(vx),\(vy),\(vz)> a=<\(ax),\(ay),\(az)>"
        }
        
        var distToZero: Int {
            abs(x) + abs(y) + abs(z)
        }
        
        func move() {
            vx += ax
            vy += ay
            vz += az
            x += vx
            y += vy
            z += vz
        }
    }
    
    static func convert(input: [String]) -> [Particle] {
        var particles: [Particle] = []
        for (index, line) in input.enumerated() {
            let cmp = line.dropLast().components(separatedBy: ">, ").map { $0.dropFirst(3).filter { $0 != " " } }
            let p = cmp[0].components(separatedBy: ",").map { Int($0)! }
            let v = cmp[1].components(separatedBy: ",").map { Int($0)! }
            let a = cmp[2].components(separatedBy: ",").map { Int($0)! }
            particles.append(Particle(x: p[0], y: p[1], z: p[2], vx: v[0], vy: v[1], vz: v[2], ax: a[0], ay: a[1], az: a[2], id: index))
        }
        return particles
    }

    static func solvePart1(input: [Particle]) -> String {
        for _ in 0...1000 {
            input.forEach { $0.move() }
        }
        
        let sortedParticles = input.sorted { $0.distToZero < $1.distToZero }
        
        return "\(sortedParticles.first!.id)"
    }

    static func solvePart2(input: [Particle]) -> String {
        var particles = input
        for _ in 0...1000 {
            particles.forEach { $0.move() }
            
            let collisions = Dictionary(grouping: particles) {
                [$0.x, $0.y, $0.z]
            }.map{ $0.value.map { $0.id } }
            collisions.forEach { ids in
                if ids.count > 1 {
                    particles.removeAll(where: { ids.contains($0.id) })
                }
            }
        }
        
        return "\(particles.count)"
    }
}
