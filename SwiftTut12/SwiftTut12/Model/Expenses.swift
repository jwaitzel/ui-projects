//
//  Expenses.swift
//  SwiftTut12
//
//  Created by Javiw on 8/31/22.
//

import Foundation

//MARK: Expense model
struct Expense: Identifiable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
    
}

var expenses: [Expense] = [
    Expense(amountSpent: "$18", product: "YouTube", productIcon: "Youtube", spendType: "Streaming"),
    Expense(amountSpent: "$128", product: "Amazon", productIcon: "Amazon", spendType: "Groceries"),
    Expense(amountSpent: "$28", product: "Apple", productIcon: "Apple", spendType: "Apple Pay"),
    Expense(amountSpent: "$9", product: "Patreon", productIcon: "Patreon", spendType: "Membership"),
    Expense(amountSpent: "$10", product: "Dribbble", productIcon: "Dribbble", spendType: "Membership"),
    Expense(amountSpent: "$100", product: "Instagram", productIcon: "Instagram", spendType: "Ad Publishing"),
    Expense(amountSpent: "$55", product: "Netflix", productIcon: "Netflix", spendType: "Movies"),
    Expense(amountSpent: "$348", product: "Photoshop", productIcon: "Photoshop", spendType: "Editing"),
    Expense(amountSpent: "$99", product: "Figma", productIcon: "Figma", spendType: "Pro Member"),
]
