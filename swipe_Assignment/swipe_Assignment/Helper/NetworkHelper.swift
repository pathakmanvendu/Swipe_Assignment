//
//  NetworkHelper.swift
//  swipe_Assignment
//
//  Created by manvendu pathak  on 08/06/24.
//

import Foundation

//MARK: - This is the NetworkHelper class which contains all the network reuqest.
class NetworkHelper {
    //This function is used to fetch the data from the API(Get Request)
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    //This function is used to send the data to the Server(Post Request)
    func addProduct(productType: String, productName: String, price: String, tax: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Construct the URL
        let url = URL(string: "https://app.getswipe.in/api/public/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create boundary
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create form-data body
        let formData = createFormData(parameters: [
            "product_type": productType,
            "product_name": productName,
            "price": price,
            "tax": tax
        ], boundary: boundary)
        
        request.httpBody = formData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func createFormData(parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    enum NetworkError: Error {
        case noData
        case invalidResponse
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

