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

    enum Partners {
        case left, top
    }

    enum Position {
        case left, right, top, bottom
    }

    /*
     Failed
     26 -> 2258
     27 -> 2243
     28 -> 2228
     36 -> 2108
     */

    /*
     25->2273
     24->2288
     */

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

        func flipUp() -> Tile {
            var flippedTile = self
            flippedTile.data = data.reversed()
            flippedTile.tops = self.bottoms
            flippedTile.bottoms = self.tops
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

        mutating func removeBorders() {
            var newData = data
            newData.remove(at: data.count-1)
            newData.remove(at: 0)
            for (index, var line) in newData.enumerated() {
                line.remove(at: line.count-1)
                line.remove(at: 0)
                newData[index] = line
            }
            data = newData
        }
    }

    static var tiles: Dictionary<Int, Tile> = [:]

    static var edges: [Int] = []
    static var borders: [Int] = []
    static var middles: [Int] = []
    static var picture: [[Int]] = []

    static func solvePart1(input: [String]) -> String {
        var number = 0
        var data: [[String.Element]] = []

        for line in input {
            guard !line.isEmpty else {
                tiles[number] = Tile(number: number, data: data)
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
        tiles[number] = Tile(number: number, data: data)

        for tile in tiles {
            searchPartner(tile: tile.value)
        }

        var corners: [Int] = []

        tiles.forEach{ tile in
            if tile.value.isCorner {
                corners.append(tile.key)
//                print(tile.value.number)
//                print("tops:    \(tile.value.tops)")
//                print("bottoms: \(tile.value.bottoms)")
//                print("lefts:   \(tile.value.lefts)")
//                print("rights:  \(tile.value.rights)")
//                print()
            }
        }
        print(corners)
        return "\(corners.reduce(1, *))"
    }

    static func solvePart2(input: [String]) -> String {
//        tiles.forEach{ tile in
//                print(tile.value.number)
//                print("tops:    \(tile.value.tops)")
//                print("bottoms: \(tile.value.bottoms)")
//                print("lefts:   \(tile.value.lefts)")
//                print("rights:  \(tile.value.rights)")
//            print(tile.value.isBorder)
//                print()
//        }
        middles = tiles.keys.map{ $0 }

        edges = middles.filter{ tiles[$0]!.isCorner }
        middles = middles.filter{ !edges.contains($0) }
        borders = middles.filter{ tiles[$0]!.isBorder }
        middles = middles.filter{ !borders.contains($0) }

        let edge = edges.removeFirst()
//        let edge = 1951
//        edges = edges.filter{ $0 != 1951 }

        var edgeTile = tiles[edge]!
        var run = true
        while run {
            edgeTile = edgeTile.rotateClockwise()
            tiles[edgeTile.number] = edgeTile
            if edgeTile.tops.isEmpty && edgeTile.lefts.isEmpty {
                run = false
            }
        }

        picture = [[edge]]
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

        var startPos = (x:1, y:1)

        for y in 1..<picture.count-1 {
            for x in 1..<picture[1].count-1 {
                startPos.x = x
                startPos.y = y
                findNextMiddle(leftTile: picture[y][startPos.x-1], topTile: picture[y-1][startPos.x], pos: startPos)
            }
        }

        rotateAndInsertLastEdge()
        picture.forEach { print($0) }

        // Remove Borders
        for var tile in tiles {
            tile.value.removeBorders()
            tiles[tile.key] = tile.value
        }

        var realPicture: [[String.Element]] = []

        for line in picture {
            var resulting: [String] = []
            for element in line {
                let tileData = tiles[element]!.data
                let pictureData = tileData.map{String($0)}
//                pictureData = pictureData.map({ $0 + "  "})
                if resulting.isEmpty {
                    resulting = Array(repeating: "", count: pictureData.count)
                }
                resulting = zip(resulting, pictureData).map(+)
            }
//            realPicture += [Array("")]
            realPicture += resulting.map({ Array($0) })
        }

        realPicture.forEach { print(String($0)) }

        let foundSnakes = findAllSnakes(picture: realPicture)

        var number = 0
        for line in realPicture {
            for element in line {
                if element == "#" {
                    number += 1
                }
            }
        }
//        for i in 1...36 {
//            print("Snakes \(i): \(number - i*15)")
//        }

        number = number - foundSnakes * 15
        return "\(number)"
    }

    static func rotateAndInsertLastEdge() {
        let edge = edges.removeFirst()
        var edgeTile = tiles[edge]!

        let left = picture.last!.last!
        let top = picture[picture.count-2].last!

        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise().flipLeft()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise().flipUp()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }

        edgeTile = edgeTile.rotateClockwise()
        if let edgeLeft = edgeTile.lefts.first, let edgeTop = edgeTile.tops.first {
            if edgeTile.bottoms.isEmpty && edgeTile.rights.isEmpty && edgeLeft == left && edgeTop == top {
                picture[picture.count-1].append(edge)
                tiles[edge] = edgeTile
                return
            }
        }
    }

    static func searchPartner(tile: Tile) {
        var tile = tile
        for partnerTile in tiles {
            if tile.number == partnerTile.value.number {
                continue
            }

            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise().flipLeft()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise().flipUp()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)

            tile = tile.rotateClockwise()
            tile = checkBorder(tile: tile, partnerTile: partnerTile.value)
        }
        tiles[tile.number] = tile
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

    static func findRightEdge(partners: Partners, currentTile: Int) {
        for (index, edgeNumber) in edges.enumerated() {
            var edge = tiles[edgeNumber]!
            let leftRight: Bool
            var edgePartners = edge.getBorderPartners(partners: partners)
            switch partners {
            case .left:
                leftRight = true
            case .top:
                leftRight = false
            }
            //TODO: Es müssen auch die Ränder übereinstimmen
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise().flipLeft()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }

            edge = edge.rotateClockwise().flipUp()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
            edge = edge.rotateClockwise()
            edgePartners = edge.getBorderPartners(partners: partners)
            if edgePartners.contains(currentTile) {
                if leftRight {
                    picture[0].append(edge.number)
                } else {
                    picture.append([edge.number])
                }
                edges.remove(at: index)
                tiles[edgeNumber] = edge
                break
            }
        }
    }

    static func findBorders(partners: Partners, position: Position, tile: Int) -> Int {
        var currentTile = tile
        var maxRight = 0
        for _ in 0..<borders.count {
            maxRight += 1
            let maxBottom = picture.count - 1
            for (index, borderNumber) in borders.enumerated() {
                var border = tiles[borderNumber]!
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
                    break
                }
                border = border.rotateClockwise().flipLeft()
//                border = border.flipLeft()
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
                    break
                }
                border = border.rotateClockwise().flipUp()
//                border = border.flipLeft()
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
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
                    tiles[borderNumber] = border
                    break
                }
            }
        }

        return currentTile
    }

    static func findNextMiddle(leftTile: Int, topTile: Int, pos: (x: Int, y: Int)) {
        if pos.x >= picture[1].count || pos.y >= picture.count - 1 {
            return
        }
        for (index, middlesNumber) in middles.enumerated() {
            var middle = tiles[middlesNumber]!
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise().flipLeft()
//            middle = middle.flipLeft()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise().flipUp()
//            middle = middle.flipLeft()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
            middle = middle.rotateClockwise()
            if middle.lefts.contains(leftTile) && middle.tops.contains(topTile) {
                picture[pos.y][pos.x] = middle.number
                middles.remove(at: index)
                tiles[middlesNumber] = middle
                break
            }
        }
    }

    static func findAllSnakes(picture: [[String.Element]]) -> Int {
        var picture = picture
        var foundSnakes: [Int] = []

        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        picture = flipPictureLeft(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        picture = flipPictureUp(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))
        picture = rotatePictureClockwise(picture: picture)
        foundSnakes.append(findSnakes(in: picture))

        print(foundSnakes)

//        return foundSnakes.reduce(0, +)
        return foundSnakes.max() ?? 0
    }

    static func findSnakes(in picture: [[String.Element]]) -> Int {

        /*
                           #
         #    ##    ##    ###
          #  #  #  #  #  #
         */

        var changedPicture = picture

        let snakePositions: [(x: Int, y: Int)] = [
            (0,0),
            (1,1),
            (4,1),
            (5,0),
            (6,0),
            (7,1),
            (10,1),
            (11,0),
            (12,0),
            (13,1),
            (16,1),
            (17,0),
            (18,0),
            (18,-1),
            (19,0)
        ]
        var foundSnakes = 0
        for y in 1..<changedPicture.count-1 {
            for x in 0..<changedPicture[0].count-19 {
                let start = (x: x, y: y)
                var found = true
                for pos in snakePositions {
                    if changedPicture[start.y + pos.y][start.x + pos.x] != "#" {
                        found = false
                        break
                    }
                }
                if found {
                    for pos in snakePositions {
                        changedPicture[start.y + pos.y][start.x + pos.x] = "O"
                    }
//                    print()
//                    changedPicture.forEach {print(String($0))}
                    foundSnakes += 1
                }
            }
        }
        return foundSnakes
    }

    static func flipPictureLeft(picture: [[String.Element]]) -> [[String.Element]] {
        var flippedPicture: [[String.Element]] = []
        picture.forEach{ flippedPicture.append($0.reversed()) }
        return flippedPicture
    }

    static func flipPictureUp(picture: [[String.Element]]) -> [[String.Element]] {
        return picture.reversed()
    }

    static func rotatePictureClockwise(picture: [[String.Element]]) -> [[String.Element]] {
        var rotatedPicture: [[String.Element]] = picture
        let n = picture.count
        for i in 0..<picture.count {
            for j in 0..<picture[0].count{
                rotatedPicture[i][j] = picture[n - j - 1][i]
            }
        }
        return rotatedPicture
    }
}

