//
//  ContentView.swift
//  swipe_Assignment
//
//  Created by manvendu pathak  on 08/06/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading....")
                } else {
                    List {
                        ForEach(viewModel.products.filter { viewModel.searchText.isEmpty ||
                            $0.product_name.localizedCaseInsensitiveContains(viewModel.searchText) }) { prod in
                                HStack {
                                    AsyncImage(url: URL(string: prod.image)) { phase in
                                        switch phase {
                                        case .failure:
                                            Image("photo")
                                        case .success(let image):
                                            image.resizable()
                                        default:
                                            Image("photo")
                                        }
                                    }
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    VStack(alignment: .leading) {
                                        Text(prod.product_name)
                                            .bold()
                                            .font(.system(size: 30))
                                        Text(prod.product_type)
                                            .font(.callout)
                                        Text("\(prod.price)")
                                            .font(.caption)
                                        Text("\(prod.tax)")
                                    }
                                }
                            }
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddProductView(viewModel: AddProductViewModel(productTypes: viewModel.productTypes))) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .background(Color.purple)
        .onAppear {
            viewModel.loadProducts()
        }
    }
}

#Preview {
    ContentView()
}
