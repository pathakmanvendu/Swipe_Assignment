//
//  ContentViewModel.swift
//  swipe_Assignment
//
//  Created by manvendu pathak  on 09/06/24.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var products: [Product] = []
    @Published var searchText = ""
    @Published var productTypes: [String] = []
    
    private let network = NetworkHelper()
    
    func loadProducts() {
        isLoading = true
        network.fetchProducts { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.products = data
                    self.productTypes = self.extractProductTypes(from: data)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func extractProductTypes(from products: [Product]) -> [String] {
        var typesSet = Set<String>()
        products.forEach { product in
            typesSet.insert(product.product_type)
        }
        return Array(typesSet)
    }
}
