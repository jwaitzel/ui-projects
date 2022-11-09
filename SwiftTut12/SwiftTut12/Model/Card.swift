//
//  Card.swift
//  SwiftTut12
//
//  Created by Javiw on 9/1/22.
//

import Foundation

struct Card: Identifiable {
    
    var id: String = UUID().uuidString
    var cardImage: String
    var rotation: CGFloat = 0
}
