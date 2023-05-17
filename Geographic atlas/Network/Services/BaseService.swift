//
//  BaseService.swift
//  Geographic atlas
//
//  Created by  Nurbek on 17.05.2023.
//

import Foundation
import Moya

class BaseService<T: TargetType>: NSObject {
    
    private let provider: MoyaProvider<T>
    
    init(provider: MoyaProvider<T>) {
        self.provider = provider
    }
}

extension BaseService {
    
    func request<E: Decodable>(_ target: T, type: E.Type, completion: @escaping(E?, String?) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                guard let data = self.returnObject(of: E.self, from: response.data).0 else {
                    completion(nil, "Decoding Error")
                    return
                }
                completion(data, nil)
            case .failure:
                completion(nil, "Request Error")
            }
        }
    }
    
    func returnObject<E: Decodable>(of type: E.Type, from data: Data) -> (E?, String?) {
        do {
            let _ = try JSONDecoder().decode(E.self, from: data)
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        if let object = try? JSONDecoder().decode(E.self, from: data) {
            return (object, nil)
        } else {
            return (nil, String(data: data, encoding:.utf8) ?? "")
        }
    }
    
    func returnObject<E: Decodable>(of type: E.Type, from data: Data, with key: String) -> (E?, String?) {
        if let data = try? JSONDecoder().decode([String: E].self, from: data), let object = data[key] {
            return (object, nil)
        } else {
            return (nil, String(data: data, encoding:.utf8) ?? "")
        }
    }
    
}

