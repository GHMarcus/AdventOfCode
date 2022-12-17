//
//  Day_17.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/17

enum Day_17_2022: Solvable {
    static var day: Input.Day = .Day_17
    static var year: Input.Year = .Year_2022

    enum RockType {
        case minus
        case plus
        case flippedL
        case bigI
        case square

        var nextType: RockType {
            switch self {
            case .minus:
                return .plus
            case .plus:
                return .flippedL
            case .flippedL:
                return .bigI
            case .bigI:
                return .square
            case .square:
                return .minus
            }
        }
    }

    struct Point: Hashable {
        var x, y: Int
    }

    class Rock {
        let type: RockType
        var points: [Point]

        init(type: RockType, point: Point) {
            self.type = type
            var points: [Point] = []
            switch type {
            case .minus:
                for i in 0...3 {
                    var newPoint = point
                    newPoint.x += i
                    points.append(newPoint)
                }
            case .plus:
                points.append(point)
                var newPoint = point
                newPoint.x += 1
                points.append(newPoint)
                newPoint.x -= 2
                points.append(newPoint)
                newPoint.x += 1
                newPoint.y += 1
                points.append(newPoint)
                newPoint.y -= 2
                points.append(newPoint)
            case .flippedL:
                points.append(point)
                var newPoint = point
                newPoint.x += 1
                points.append(newPoint)
                newPoint.x += 1
                points.append(newPoint)
                newPoint.y += 1
                points.append(newPoint)
                newPoint.y += 1
                points.append(newPoint)
            case .bigI:
                points.append(point)
                var newPoint = point
                newPoint.y += 1
                points.append(newPoint)
                newPoint.y += 1
                points.append(newPoint)
                newPoint.y += 1
                points.append(newPoint)
            case .square:
                points.append(point)
                var newPoint = point
                newPoint.x += 1
                points.append(newPoint)
                newPoint.y += 1
                points.append(newPoint)
                newPoint.x -= 1
                points.append(newPoint)
            }
            self.points = points
        }

        var highestY: Int {
            points.map { $0.y }.max()!
        }

        func moveToLeft(otherRocks: Set<Point>) {
            if points.map({ $0.x }).min()! > 0 {
                let newPoints: [Point] = points.reduce(into: [], { partialResult, point in
                    var newPoint = point
                    newPoint.x -= 1
                    partialResult.append(newPoint)
                })

                var canMove = true
                for point in newPoints {
                    if otherRocks.contains(point) {
                        canMove = false
                        break
                    }
                }
                if canMove {
                    points = newPoints
                }
            }
        }

        func moveToRight(otherRocks: Set<Point>) {
            if points.map({ $0.x }).max()! < 6 {
                let newPoints: [Point] = points.reduce(into: [], { partialResult, point in
                    var newPoint = point
                    newPoint.x += 1
                    partialResult.append(newPoint)
                })

                var canMove = true
                for point in newPoints {
                    if otherRocks.contains(point) {
                        canMove = false
                        break
                    }
                }
                if canMove {
                    points = newPoints
                }
            }
        }

        func fallDown(otherRocks: Set<Point>) -> Bool {
            if points.map({ $0.y }).min()! > 0 {
                let newPoints: [Point] = points.reduce(into: [], { partialResult, point in
                    var newPoint = point
                    newPoint.y -= 1
                    partialResult.append(newPoint)
                })

                var canMove = true
                for point in newPoints {
                    if otherRocks.contains(point) {
                        canMove = false
                        break
                    }
                }
                if canMove {
                    points = newPoints
                }
                return canMove
            } else {
                return false
            }
        }
    }

    static func solvePart1(input: [Character]) -> String {
        let hotGas = input
        var currentGas = 0
        var stoppedRocks: Set<Point> = []
        var currentRock = Rock(type: .minus, point: Point(x: 2, y: 3))
        var isFalling = false

        var stoppingCounter = 0
        let stoppingCountMax = 2022


        while true {
            if isFalling {
                isFalling = false
                let moved = currentRock.fallDown(otherRocks: stoppedRocks)
                if moved {
                    continue
                } else {
                    currentRock.points.forEach {
                        stoppedRocks.insert($0)
                    }
                    stoppingCounter += 1
                    if stoppingCounter == stoppingCountMax {
                        break
                    }
                    let newPoint: Point
                    let maxY = stoppedRocks.map({ $0.y }).max()!
                    switch currentRock.type.nextType {
                    case .plus:
                        newPoint = Point(x: 2+1, y: maxY + 4 + 1)
                    default:
                        newPoint = Point(x: 2, y: maxY + 4)
                    }
                    let newRock = Rock(
                        type: currentRock.type.nextType,
                        point: newPoint
                    )
                    currentRock = newRock
                    isFalling = false
                }
            } else {
                isFalling = true
                if currentGas >= hotGas.count {
                    currentGas = 0
                }
                let currentDirection = hotGas[currentGas]
                if currentDirection == "<" {
                    currentRock.moveToLeft(otherRocks: stoppedRocks)
                } else if currentDirection == ">" {
                    currentRock.moveToRight(otherRocks: stoppedRocks)
                } else {
                    fatalError("should never be here")
                }
                currentGas += 1
            }
        }

        let maxY = stoppedRocks.map({ $0.y }).max()!

        return "\(maxY+1)"
    }

    static func solvePart2(input: [Character]) -> String {
        let hotGas = input
        var currentGas = 0
        var stoppedRocks: Set<Point> = []
        var currentRock = Rock(type: .minus, point: Point(x: 2, y: 3))
        var isFalling = false

        var stoppingCounter = 0
        let stoppingCountMax = 1000000000000

        var heightDelta: [Int] = []


        while true {
            if isFalling {
                isFalling = false
                let moved = currentRock.fallDown(otherRocks: stoppedRocks)
                if moved {
                    continue
                } else {
                    let previousMaxY = stoppedRocks.map({ $0.y }).max() ?? -1
                    currentRock.points.forEach {
                        stoppedRocks.insert($0)
                    }
                    stoppingCounter += 1
                    if stoppingCounter == 6000 {
                        break
                    }
                    let newPoint: Point
                    let maxY = stoppedRocks.map({ $0.y }).max()!

                    // check heightDelta
                    heightDelta.append(maxY - previousMaxY)

                    // reduce rocks
                    stoppedRocks = stoppedRocks.filter({ $0.y >= (maxY-50)})
                    switch currentRock.type.nextType {
                    case .plus:
                        newPoint = Point(x: 2+1, y: maxY + 4 + 1)
                    default:
                        newPoint = Point(x: 2, y: maxY + 4)
                    }
                    let newRock = Rock(
                        type: currentRock.type.nextType,
                        point: newPoint
                    )
                    currentRock = newRock
                    isFalling = false
                }
            } else {
                isFalling = true
                if currentGas >= hotGas.count {
                    currentGas = 0
                }
                let currentDirection = hotGas[currentGas]
                if currentDirection == "<" {
                    currentRock.moveToLeft(otherRocks: stoppedRocks)
                } else if currentDirection == ">" {
                    currentRock.moveToRight(otherRocks: stoppedRocks)
                } else {
                    fatalError("should never be here")
                }
                currentGas += 1
            }
        }

        // Note: This pattern strings were found visually, maybe I will change it later

//        let repeatingPatternStr = "01230113220023401212012120132001334"
//        let repeatingPattern = Array(repeatingPatternStr).map { Int(String($0))! }
//        let offsetStr = "1321213220132021334"
//        let offset = offsetStr.count

        let repeatingPatternStr = "12340133000202212322123021330213322023021322200310133221332212240133021332013030012401334012122103001332013300133221332003220022200330012120130201334200322130300230212240023021322013222020401212013320132010301113030013020300200302132421334002000121201303213300030121332213300133201330202240133401234202340133001334012322133401221201220123020230010310132021320013300132201320013220103111304013320133001330213302133400200213320130201330012120133221334213320132001302013342003001320213222132201224013322133421330210322133021332213220022400200202300033001324212202130321332013200132201224013300133000303213320022221232013320123000302002240033001322013220133021302213302132201332013320133001031003302023401222013220132111334013300121201330212322133201034012110123201320002222132201332213320121201213003002133201222012320133001210013300133021304013040122201332213340020001330012130103201320002302133001330212242132221332213302123000322010220023401334202202123001222213200130300234213300133201230212320032221031012120022221330213300132101320013200121201320013322112120022002300132001214002300133021324213030023200220013340133001232213340132001301213300133201334012202003201332213020133421212003302133200230213320122400230012142133021032012220023021213001240003001332013030030321230213320133400332013300132001334013340132221324012300133220232010320132000230012302122201320012120023001230012302133421303013200130201302013302130201324213220132401332200340133021332013300132221320213340133001221003220132421212203002130201214212130023421330013222130321321213340132421230112300033001322013202122221302003220132011324012320123201330013300132201210213300132001322013340003201301013242133201330013322130300132213320130021321212322"
        let repeatingPattern = Array(repeatingPatternStr).map { Int(String($0))! }
        let offsetStr = "121201321103322133401222213322133001334013200133201212012130012201304002200023011322002242133421303002022132201212012120133201212013222123011304003040133201321113300133001212003030133221234013320132121324002212023401304213322132001332013240132000213013340132021212013242023221213203000132201320013042123011332013300123201330013340130321304013300133201330013302133021303002300132001330211210123011332213320132001330213300132001334013340132221324012300133220232010320132000230012302122201320012120023001230012302133421303013200130201302013302130201324213220132401332200340133021332013300132221320213340133001221003220132421212203002130201214212130023421330013222130321321213340132421230112300033001322013202122221302003220132011324012320123201330013300132201210213300132001322013340003201301013242133201330013322130300132213320130021321212322"
        let offset = offsetStr.count


        let offsetHeight = Array(heightDelta[0..<offset]).reduce(0, +)

        var pattern = heightDelta.map { String($0) }.joined()
        pattern = pattern
            .replacingOccurrences(of: offsetStr, with: "#")
            .replacingOccurrences(of: repeatingPatternStr, with: "*")

        print(pattern)
        print(offsetHeight)

        let repeatsCount = (stoppingCountMax - offset) / repeatingPattern.count
        let repeatsHeight = repeatsCount * repeatingPattern.reduce(0, +)

        let rest = (stoppingCountMax - offset) % repeatingPattern.count
        var restHeight = 0
        if rest > 0 {
            restHeight = Array(repeatingPattern[0..<rest]).reduce(0, +)
        }

        print(repeatsCount)
        print(rest)

        return "\(offsetHeight + repeatsHeight + restHeight)"
    }
}
