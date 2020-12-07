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

        init(name: String, innerBagsString: String) {
            self.name = name
            if innerBagsString.contains("no") {
                self.innerBags = []
            } else {
                var innerBags: [InnerBag] = []
                // 4 vibrant magenta, 4 light violet, 5 bright gold, 2 faded black
                let bags = innerBagsString.components(separatedBy: ", ")
                // 4 vibrant magenta
                bags.forEach { bag in
                    let splitted = bag.components(separatedBy: " ")
                    let number = Int(splitted.first ?? "") ?? 0
                    let name = splitted.dropFirst().joined(separator: " ")
                    innerBags.append(.init(name: name, number: number))
                }
                self.innerBags = innerBags
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
        let name: String
        let number: Int
    }

    static func solvePart1(input: [String]) -> String {
        input.forEach { line in
            let rule = line
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: " bags", with: "")
                .replacingOccurrences(of: " bag", with: "")
                .components(separatedBy: " contain ")


            bags.append(.init(name: rule.first ?? "", innerBagsString: rule.last ?? ""))
        }

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

        return "\(numberOfInnerBags(for: goldBag))"
    }

    private static func numberOfInnerBags(for currentBag: Bag) -> Int {

        guard !currentBag.innerBags.isEmpty else {
            return 0
        }

        return currentBag.innerBags.reduce(0) { (result, next) -> Int in
            let nextBag = getBag(from: next)
            return result + next.number + next.number * numberOfInnerBags(for: nextBag)
        }
    }

    private static func getBag(from innerBag: InnerBag) -> Bag {
        guard let bag = bags.first(where: { $0.name == innerBag.name }) else {
            fatalError("Could not find innerBag in bags")
        }

        return bag
    }
}
