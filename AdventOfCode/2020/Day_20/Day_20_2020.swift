//
//  Day_20.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/20

enum Day_20_2020: Solvable {
    static var day: Input.Day = .Day_20
    static var year: Input.Year = .Year_2020

    struct Tile: Equatable {
        let number: Int
        var data: [[String.Element]]

        var rights: [Int] = []
        var lefts: [Int] = []
        var tops: [Int] = []
        var bottoms: [Int] = []

        var isCorner: Bool {
            let topLeft = tops.isEmpty && lefts.isEmpty
            let topRight = tops.isEmpty && rights.isEmpty
            let bottomLeft = bottoms.isEmpty && lefts.isEmpty
            let bottomRight = bottoms.isEmpty && rights.isEmpty

            return topLeft || topRight || bottomLeft || bottomRight
        }

        var isBorder: Bool {
            tops.isEmpty || lefts.isEmpty || bottoms.isEmpty || rights.isEmpty
        }

        var hasAllPartners: Bool {
            let top = tops.count > 0
            let bottom = bottoms.count > 0
            let left = lefts.count > 0
            let right = rights.count > 0

            return top && bottom && left && right
        }

        var leftBorder: [String.Element] {
            var border: [String.Element] = []
            data.forEach{ border.append($0.first ?? Character("")) }
            return border
        }

        var rightBorder: [String.Element] {
            var border: [String.Element] = []
            data.forEach{ border.append($0.last ?? Character("")) }
            return border
        }

        var topBorder: [String.Element] {
            return data.first ?? []
        }

        var bottomBorder: [String.Element] {
            return data.last ?? []
        }

        func flipLeft() -> Tile {
            var flippedTile = self
            var flippedData: [[String.Element]] = []
            data.forEach{ flippedData.append($0.reversed()) }
            flippedTile.data = flippedData
            flippedTile.lefts = self.rights
            flippedTile.rights = self.lefts
            return flippedTile
        }

        func rotateClockwise() -> Tile {
            var rotatedTile = self
            let n = self.data.count
            for i in 0..<self.data.count {
                for j in 0..<self.data[0].count {
                    rotatedTile.data[i][j] = self.data[n - j - 1][i]
                }
            }

            rotatedTile.tops = self.lefts
            rotatedTile.bottoms = self.rights
            rotatedTile.lefts = self.bottoms
            rotatedTile.rights = self.tops

            return rotatedTile
        }

        func getBorderPartners(partners: Partners) -> [Int] {
            switch partners {
            case .left:
                return self.lefts
            case .top:
                return self.tops
            }
        }

    }

    static var tiles: [Tile] = []
    static var edges: [Tile] = []
    static var borders: [Tile] = []
    static var middles: [Tile] = []
    static var picture: [[Int]] = []

    static func solvePart1(input: [String]) -> String {
        var number = 0
        var data: [[String.Element]] = []


        for line in input {
            guard !line.isEmpty else {
                tiles.append(.init(number: number, data: data))
                number = 0
                data = []
                continue
            }
            if line.contains("Tile") {
                number = Int(line.components(separatedBy: " ").last?.dropLast() ?? "") ?? 0
            } else {
                data.append(Array(line))
            }
        }
        tiles.append(.init(number: number, data: data))


        for (t, tile) in tiles.enumerated() {
            searchPartner(tile: tile, t: t)
        }

        var corners: [Int] = []

        tiles.forEach{ tile in
            if tile.isCorner {
                corners.append(tile.number)
//                print(tile.number)
//                print("tops:    \(tile.tops)")
//                print("bottoms: \(tile.bottoms)")
//                print("lefts:   \(tile.lefts)")
//                print("rights:  \(tile.rights)")
//                print()
            }
        }
//        print(corners)
        return "\(corners.reduce(1, *))"
    }

    static func solvePart2(input: [String]) -> String {
        middles = tiles

        edges = middles.filter{ $0.isCorner }
        middles = middles.filter{ !edges.contains($0) }
        borders = middles.filter { $0.isBorder }
        middles = middles.filter{ !borders.contains($0) }

        for tile in tiles {
            print(tile.number)
            print("tops:    \(tile.tops)")
            print("bottoms: \(tile.bottoms)")
            print("lefts:   \(tile.lefts)")
            print("rights:  \(tile.rights)")
            print()
        }

        picture = [[edges[0].number]]
        edges.remove(at: 0)

        //[3833, 3581, 3037, 1487, 3947, 1153, 2129, 1733, 3881, 1399, 1511, 3517]
        /*
         [3833, 3581, 3037, 1487, 3947, 1153, 2129, 1733, 3881, 1399, 1511, 3517]
         [1657, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2897]
         [3313, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2017]
         [3319, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3457]
         [3307, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1699]
         [2113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3023]
         [1723, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1873]
         [3671, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1097]
         [2543, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3389]
         [2777, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3359]
         [3583, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1103]
         [2593, 1543, 3373, 3863, 1493, 2137, 1619, 2843, 3613, 2411, 1117]
         */

        var currentTile = picture[0][0]
        currentTile = findBorders(partners: .left, position: .left, tile: currentTile)
        findRightEdge(partners: .left, currentTile: currentTile)

        currentTile = picture[0][0]
        currentTile = findBorders(partners: .top, position: .top, tile: currentTile)
        findRightEdge(partners: .top, currentTile: currentTile)

        for i in 1..<picture.count-1 {
            let line = Array(repeating: 0, count: picture[0].count-2)
            picture[i].append(contentsOf: line)
        }

        currentTile = picture.last![0]
        currentTile = findBorders(partners: .left, position: .bottom, tile: currentTile)

        currentTile = picture[0].last!
        currentTile = findBorders(partners: .top, position: .right, tile: currentTile)

        picture.forEach { print($0) }



        return "Add some Code here"
    }

    static func searchPartner(tile: Tile, t: Int) {
        var tile = tile
        for (p, partnerTile) in tiles.enumerated() {
            if tile.number == partnerTile.number {
                continue
            }

            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.flipLeft()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile)
        }
        tiles[t] = tile
    }

    static func checkBorder(tile: Tile, partnerTile: Tile) -> Tile {
        var tile = tile
        // Left
        if tile.leftBorder == partnerTile.rightBorder {
            tile.lefts.append(partnerTile.number)
        }
        // Right
        if tile.rightBorder == partnerTile.leftBorder {
            tile.rights.append(partnerTile.number)
        }
        // Top
        if tile.topBorder == partnerTile.bottomBorder {
            tile.tops.append(partnerTile.number)
        }
        // Bottom
        if tile.bottomBorder == partnerTile.topBorder {
            tile.bottoms.append(partnerTile.number)
        }
        return tile
    }

    enum Partners {
        case left, top
    }

    enum Position {
        case left, right, top, bottom
    }

    static func findRightEdge(partners: Partners, currentTile: Int) {
        for (index, var edge) in edges.enumerated() {
            let leftRight: Bool
            let edgePartners: [Int]
            switch partners {
            case .left:
                leftRight = true
                edgePartners = edge.lefts
            case .top:
                leftRight = false
                edgePartners = edge.tops
            }

            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.rotateClockwise()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.rotateClockwise()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.rotateClockwise()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.flipLeft()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.rotateClockwise()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.rotateClockwise()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
            edge = edge.rotateClockwise()
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                continue
            }
        }
    }

    static func findBorders(partners: Partners, position: Position, tile: Int) -> Int {
        var currentTile = tile
        var maxRight = 0
        for _ in 0..<borders.count {
            maxRight += 1
            let maxBottom = picture.count - 1
            for (index, var border) in borders.enumerated() {
                var borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise().flipLeft()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
                border = border.rotateClockwise()
                borderPartners = border.getBorderPartners(partners: partners)
                if borderPartners.contains(currentTile) {
                    switch position {
                    case .left:
                        picture[0].append(border.number)
                    case .right:
                        picture[maxRight].append(border.number)
                    case .top:
                        picture.append([border.number])
                    case .bottom:
                        picture[maxBottom].append(border.number)
                    }
                    currentTile = border.number
                    borders.remove(at: index)
                    break
                }
            }
        }

        return currentTile
    }
}
