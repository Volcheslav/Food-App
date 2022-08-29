//
//  MenuData.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/26/22.
//

import Foundation

protocol Food {
    var name: String { get set }
    var price: Double { get set }
    var imageName: String { get set }
}

struct Menu {
    private let burgerNames = ["Hanburger", "CheeseBurger", "BigBurger", "SteakHouse", "Classic", "OldBurger", "BlackHourse", "CheeseKing"]
    private let burgerPrice = [1.00, 2.49, 3.59, 4.29, 7.99, 2.49, 5.29, 3.33]
    private let burgerCalories = [1320, 2340, 2500, 1020, 1234, 1068, 2500, 1700]
    static let shared = Menu()
    func getBurgers() -> [Burger] {
        guard burgerNames.count == burgerPrice.count, burgerNames.count == burgerCalories.count else { return [] }
        let imgNames = Array(sequence(first: 0, next: { $0 + 1 }).prefix(burgerNames.count)).map { String("burger\($0)") }
        return zip(zip(zip(burgerNames, burgerPrice), burgerCalories), imgNames).map { Burger(name: $0.0.0.0, price: $0.0.0.1, imageName: $0.1, calories: $0.0.1) }
    }
    private init() {}
}

struct Burger: Food {
    var name: String
    var price: Double
    var imageName: String
    var calories: Int
}

struct Drink: Food {
    var name: String
    var price: Double
    var imageName: String
    var volume: Double
}
