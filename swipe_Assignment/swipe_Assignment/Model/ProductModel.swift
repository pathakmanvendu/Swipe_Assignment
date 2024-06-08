//
//  ProfuctModel.swift
//  swipe_Assignment
//
//  Created by manvendu pathak  on 08/06/24.
//

import Foundation

struct Product: Codable, Identifiable{
    let id = UUID()
    let image: String
    let price: Double
    let product_name: String
    let product_type: String
    let tax: Double
    
    enum CodingKeys: String, CodingKey {
        case image, price, product_name, product_type, tax
    }
}


