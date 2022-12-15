//
//  Leaderboard.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 10.12.22.
//

import Foundation

class Leaderboard: Decodable {
    let members: [Member]
    let year: String

    private func getMembers() -> [Member] {
        members.sorted { $0.score > $1.score }
    }

    func print() {
        Swift.print("********** Year \(year) **********")
        getMembers().forEach {
            $0.print()
        }
        Swift.print("*******************************")
    }

    private enum CodingKeys: String, CodingKey {
        case members
        case year = "event"
    }

    required init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
              let membersContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .members)
        else {
            members = []
            year = ""
            return
        }

        year = try container.decode(String.self, forKey: .year)
        members = membersContainer.allKeys.compactMap { key in
            try? membersContainer.decode(Member.self, forKey: key)
        }
    }
}

struct Member: Decodable {
    let name: String
    let score: Int
    var stars: [Star] = []

    private func getStars() -> [(key: Int, value: [Star])] {
        Dictionary(grouping: stars, by: \.day)
            .sorted { $0.key < $1.key }
            .map { (key, value) in
                (key, value.sorted(by: { $0.number < $1.number }))
            }
    }

    func print() {
        let formatter = Date.mediumTimeFormatterTimeZoneAware

        var str = ""
        str.append("\(name) (\(score)): ")

        for day in getStars() {
            str.append("\n  Day \(day.key):")
            day.value.forEach {
                str.append("\n    ⭐️ #\($0.number) -> \(formatter.string(from: $0.time))")
            }
        }

        Swift.print(str)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case score = "local_score"
        case days = "completion_day_level"
        case time = "get_star_ts"
    }

    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
              let daysContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .days)
        else {
            name = ""
            score = 0
            stars = []
            return
        }

        name = try container.decode(String.self, forKey: .name)
        score = try container.decode(Int.self, forKey: .score)
        stars = daysContainer.allKeys.flatMap{ day -> [Star] in
            guard let starsContainer = try? daysContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: day)
            else { return [] }

            return starsContainer.allKeys.compactMap { number in
                do {
                    let starContainer =  try starsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: number)
                    let ts = try starContainer.decode(Double.self, forKey: .time)
                    return Star(day: Int(day.stringValue) ?? 0, number: Int(number.stringValue) ?? 0, time: Date(timeIntervalSince1970: ts))
                } catch {
                    return nil
                }
            }
        }
    }

}

struct Star {
    let day: Int
    let number: Int
    let time: Date
}

extension Date {
    static let mediumTimeFormatterTimeZoneAware = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.timeStyle = .medium
        return formatter
    }()
}

