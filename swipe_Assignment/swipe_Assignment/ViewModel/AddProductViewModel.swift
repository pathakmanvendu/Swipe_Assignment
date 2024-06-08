//
//  ProductViewModel.swift
//  swipe_Assignment
//
//  Created by manvendu pathak  on 09/06/24.
//

import Foundation
import SwiftUI

class AddProductViewModel: ObservableObject {
    @Published var selectedProductTypeIndex = 0
    @Published var productName = ""
    @Published var productPrice = ""
    @Published var productTax = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    let network = NetworkHelper()
    let productTypes: [String]
    
    init(productTypes: [String]) {
        self.productTypes = productTypes
    }
    
    func addProduct() {
        // Validate inputs
        if !validateInputs() {
            showAlert = true
            return
        }
        
        let selectedProductType = productTypes[selectedProductTypeIndex]
        
        network.addProduct(productType: selectedProductType, productName: productName, price: productPrice, tax: productTax) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.alertMessage = "Your product has been succesfully added."
                    print(response)
                case .failure(let error):
                    self.alertMessage = "Error in adding the product."
                    print(error)
                }
                self.showAlert = true
            }
        }
    }
    
    private func validateInputs() -> Bool {
        if productTypes.isEmpty || selectedProductTypeIndex >= productTypes.count {
            alertMessage = "Please select a valid product type."
            return false
        }
        
        if productName.trimmingCharacters(in: .whitespaces).isEmpty {
            alertMessage = "Product name cannot be empty."
            return false
        }
        
        if !isDecimalNumber(productPrice) {
            alertMessage = "Price must be a valid decimal number."
            return false
        }
        
        if !isDecimalNumber(productTax) {
            alertMessage = "Tax must be a valid decimal number."
            return false
        }
        
        return true
    }
    
    private func isDecimalNumber(_ value: String) -> Bool {
        let decimalRegex = "^[0-9]+(\\.[0-9]{1,2})?$"
        let decimalPredicate = NSPredicate(format: "SELF MATCHES %@", decimalRegex)
        return decimalPredicate.evaluate(with: value)
    }
}
