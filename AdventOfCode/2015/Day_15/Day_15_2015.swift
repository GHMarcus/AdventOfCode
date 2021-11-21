//
//  Day_15.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2015/day/15

enum Day_15_2015: Solvable {
    static var day: Input.Day = .Day_15
    static var year: Input.Year = .Year_2015
    
    static var mealsWithCalorie: [Int] = []
    
    struct Ingredient {
        let name: String
        let capacity: Int
        let durability: Int
        let flavor: Int
        let texture: Int
        let calories: Int
    }

    static func solvePart1(input: [String]) -> String {
        let ingredients = convertInputToIngredients(input)
        
        var arr: [Int] = Array(repeating: 0, count: ingredients.count)
        var meals: [Int] = []
        var count = 1
        for _ in 0..<ingredients.count {
            count *= 100
        }
        count += 100
        // Part 1 took over 170 seconds so I decided to add an progress indicator
        var percent = 1
        let divisor = count / 100

        for i in 0..<count {
            if i % divisor == 0 {
                print("\(percent) %")
                percent += 1
            }
            var n = 0
            var changed = false
            while !changed {
                let v_1 = arr[n]
                if v_1 == 100 {
                    for i in 0...n {
                        arr[i] = 1
                    }
                    n += 1
                } else {
                    arr[n] = v_1 + 1
                    changed = true
                }
            }

            if arr.reduce(0, +) == 100 {
                let meal = cook(with: arr, ingredients: ingredients)
                meals.append(meal.score)
                if meal.calorie == 500 {
                    mealsWithCalorie.append(meal.score)
                }
            }

        }
        
        return "\(meals.max() ?? 0)"
    }
    
    static func solvePart2(input: [String]) -> String {
        // Part 1 took over 170 seconds so I decided to reuse the results for part 2
        return "\(mealsWithCalorie.max() ?? 0)"
    }
}

extension Day_15_2015 {
  
    static func convertInputToIngredients(_ input: [String]) -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        for line in input {
            let components = line
                .replacingOccurrences(of: ",", with: "")
                .replacingOccurrences(of: ":", with: "")
                .components(separatedBy: " ")
            
            ingredients.append(Ingredient(
                name: components[0],
                capacity: Int(components[2]) ?? 0,
                durability: Int(components[4]) ?? 0,
                flavor: Int(components[6]) ?? 0,
                texture: Int(components[8]) ?? 0,
                calories: Int(components[10]) ?? 0
            ))
            
        }
        
        return ingredients
    }
    
    static func cook(with receipt: [Int], ingredients: [Ingredient]) -> (score: Int, calorie: Int) {
        var capacity = 0
        var durability = 0
        var flavor = 0
        var texture = 0
        var calories = 0
        
        
        for i in 0..<ingredients.count {
            capacity += ingredients[i].capacity * receipt[i]
            durability += ingredients[i].durability * receipt[i]
            flavor += ingredients[i].flavor * receipt[i]
            texture += ingredients[i].texture * receipt[i]
            calories += ingredients[i].calories * receipt[i]
        }
        
        capacity = capacity < 0 ? 0 : capacity
        durability = durability < 0 ? 0 : durability
        flavor = flavor < 0 ? 0 : flavor
        texture = texture < 0 ? 0 : texture
        
        let score = capacity * durability * flavor * texture
        
        return (score, calories)
    }
}
