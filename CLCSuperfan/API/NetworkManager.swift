//
//  NetworkManager.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import Foundation

enum NetworkError: Error {
    case requestFailed // request failed to send
    case malformedResponse // server gave back a weird response
    case badData // server sent back bad or no data
    case unauthorized // requested for an unauthorized endpoint
    case unknown
}

// singleton class for managing requests and respones to superfan backend
class NetworkManager {
    static let shared = NetworkManager()
    
    static let apiUrl = "https://lioness-usable-painfully.ngrok-free.app"
    
    private let session = URLSession.shared
    
    func request<T: Decodable>(api: some APIProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: api.url)
        request.httpMethod = api.method
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        if let token = AuthManager.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = api.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(.requestFailed))
                return
            }
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("request to backend failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.malformedResponse))
                return
            }
            
            switch response.statusCode {
            // success!
            case 200...299:
                guard let data = data else {
                    completion(.failure(.badData))
                    return
                }
                
                // decode response from server (handles completion)
                self.decodeResponse(data: data, completion: completion)
                
            case 401, 403:
                print(response.statusCode)

                completion(.failure(.unauthorized))
                
            default:
                completion(.failure(.unknown))
                
            }
        }.resume()
    }
    
    private func decodeResponse<T: Decodable>(data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let decoder = JSONDecoder()
            print()
            let decodedData = try decoder.decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            print("failed to decode data with error \(error)")
            completion(.failure(.malformedResponse))
        }
    }
}
