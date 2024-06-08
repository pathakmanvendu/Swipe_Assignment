//
//  AddProductView.swift
//  swipe_Assignment
//
//  Created by manvendu pathak  on 09/06/24.
//

import SwiftUI

//MARK: - THIS IS THE ADD PRODUCT SCREEN.
struct AddProductView: View {
    @ObservedObject var viewModel: AddProductViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Product Type")) {
                Picker("Select Product Type", selection: $viewModel.selectedProductTypeIndex) {
                    ForEach(0..<viewModel.productTypes.count, id: \.self) { index in
                        Text(viewModel.productTypes[index]).tag(index)
                    }
                }
            }
            
            Section(header: Text("Product Details")) {
                TextField("Product Name", text: $viewModel.productName)
                TextField("Price", text: $viewModel.productPrice)
                    .keyboardType(.numberPad)
                TextField("Tax", text: $viewModel.productTax)
                    .keyboardType(.numberPad)
            }
            
            Button(action: viewModel.addProduct) {
                Text("Add Product")
            }
        }
        .navigationTitle("Add Product")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Success"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AddProductView(viewModel: AddProductViewModel(productTypes: ["Electronics", "Clothing", "Groceries"]))
}
