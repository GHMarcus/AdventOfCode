//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/21

enum Day_21_2020: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2020

    struct Food {
        var ingredients: [String]
        var allergens: [String]

        // mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        init(_ line: String) {
            let cmp = line.components(separatedBy: " (")
            ingredients = cmp[0].components(separatedBy: " ")
            let allergenStr = cmp[1].dropFirst(9).dropLast()
            allergens = allergenStr.components(separatedBy: ", ")
        }
    }

    static var allergensIngredients: Dictionary<String, String> = [:]

    static func solvePart1(input: [String]) -> String {
        var foods: [Food] = []
        var allergensSet: Set<String> = []
        for line in input {
            let food = Food(line)
            foods.append(food)
            food.allergens.forEach { allergensSet.insert($0) }
        }

        var sortedAllergens = allergensSet.sorted()
        var run = true
        while run {
            allergensIngredients = [:]
            for allergen in sortedAllergens {
                let foodsContainsAllergen = foods.filter { $0.allergens.contains(allergen) }
                for ingredient in foodsContainsAllergen[0].ingredients {
                    var ingredientContainsAllergen = true
                    for food in foodsContainsAllergen {
                        if !food.ingredients.contains(ingredient) {
                            ingredientContainsAllergen = false
                            break
                        }
                    }
                    let ingredientNotUsed = !(allergensIngredients.contains {$0.value == ingredient})
                    if ingredientContainsAllergen && ingredientNotUsed {
                        allergensIngredients[allergen] = ingredient
                        print(allergensIngredients)
                        break
                    }
                }
            }
            if allergensIngredients.count == allergensSet.count {
                run = false
            } else {
                sortedAllergens = allergensSet.shuffled()
            }
        }

        var nonAllergicIngrediets = 0
        for food in foods {
            for ingredient in food.ingredients {
                if !(allergensIngredients.contains {$0.value == ingredient}) {
                    nonAllergicIngrediets += 1
                }
            }
        }

        return "\(nonAllergicIngrediets)"
    }

    static func solvePart2(input: [String]) -> String {

        let sortedAllergenIngredients = allergensIngredients.sorted { $0.key < $1.key }
        let listedIngredients = sortedAllergenIngredients.map{ $0.value }

        return listedIngredients.joined(separator: ",")
    }
}
