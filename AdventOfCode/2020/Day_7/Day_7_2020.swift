//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/7

enum Day_7_2020: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2020

    static var bags: [Bag] = []

    struct Bag: Hashable {

        let name: String
        let innerBags: [InnerBag]

        init(rule: String) {
            let splitedRule = rule.components(separatedBy: " contain ")
            name = (splitedRule.first ?? "")
                .replacingOccurrences(of: "bags", with: "")
                .replacingOccurrences(of: "bag", with: "")
                .trimmingCharacters(in: .whitespaces)
            let innerBags = splitedRule.last?.components(separatedBy: ", ")
            if innerBags?.first?.contains("no") ?? false {
                self.innerBags = []
            } else {
                var bags: [InnerBag] = []
                innerBags?.forEach{ bagString in
                    let number = Int(bagString.dropLast(bagString.count - 1)) ?? 0
                    let name = String(bagString.dropFirst(2)
                                        .replacingOccurrences(of: ".", with: "")
                                        .replacingOccurrences(of: "bags", with: "")
                                        .replacingOccurrences(of: "bag", with: "")
                                        .trimmingCharacters(in: .whitespaces))
                    bags.append(.init(number: number, name: name))
                }
                self.innerBags = bags
            }
        }

        var canDirectlyHoldShineyGoldBag: Bool {
            innerBags.reduce(false) { (result, next) -> Bool in
                result || next.name.contains("shiny gold")
            }
        }

        func canHoldBag(_ name: String) -> Bool {
            innerBags.reduce(false) { (result, next) -> Bool in
                result || next.name.contains(name.dropLast())
            }
        }
    }

    struct InnerBag: Hashable {
        let number: Int
        let name: String
    }

    static func solvePart1(input: [String]) -> String {
        input.forEach { bags.append(.init(rule: $0))}
        bags = bags.filter{ $0.innerBags != [] }

        let directHolidingBags = bags.filter{ $0.canDirectlyHoldShineyGoldBag }
        var indirectHoldingBagNames = directHolidingBags.map{ $0.name }
        var indirectHoldingBags: Set<Bag> = []

        while let bag = indirectHoldingBagNames.first {
            guard let currentBag = bags.first(where: {$0.name == bag}) else {
                indirectHoldingBagNames = indirectHoldingBagNames.filter({$0 != bag})
                continue
            }

            for bag in bags {
                if bag.canHoldBag(currentBag.name) {
                    indirectHoldingBags.insert(bag)
                    indirectHoldingBagNames.append(bag.name)
                }
            }
            indirectHoldingBagNames = indirectHoldingBagNames.filter({$0 != currentBag.name})
        }

        return "\(directHolidingBags.count + indirectHoldingBags.count)"
    }

    static func solvePart2(input: [String]) -> String {
        guard let goldBag = bags.first(where: { $0.name == "shiny gold" }) else {
            fatalError("Can not find gold Bag")
        }
        let remainBags = bags.filter { $0.name != "shiny gold" }

        var containingBags = numberOfInnerBags(for: goldBag, bags: bags)

//        for innerBag in goldBag.innerBags {
//            containingBags += innerBag.number + innerBag.number *
//        }

        // 220149

        return "\(containingBags)"
    }

    private static func numberOfInnerBags(for currentBag: Bag, bags: [Bag]) -> Int {

        guard !currentBag.innerBags.isEmpty else {
            return 1
        }

//        let leftBags = bags.filter { $0.name != innerBag.name }

        return currentBag.innerBags.reduce(0) { (result, next) -> Int in
            guard let nextBag = bags.first(where: { $0.name == next.name }) else { return result }
            return result + next.number + next.number * numberOfInnerBags(for: nextBag, bags: bags)//leftBags)
        }
    }
}
