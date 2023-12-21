//
//  NetworkService.swift
//  TestApp
//
//  Created by ульяна on 13.12.23.
//

import Foundation
import Alamofire
import UIKit

final class NetworkService {
    
    static func fetchList(page: Int32, callBack: @escaping (PagePhotoTypeDtoOut?, Error?) -> Void) {
        
        let url = "\(ApiConstans.PagePhotoTypeDtoOutPath)\(page)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            
            var jsonValue: PagePhotoTypeDtoOut?
            var err: Error?
            
            switch response.result {
            case.success(let data):
                
                guard let data = data else { return }
                do {
                    jsonValue = try JSONDecoder().decode(PagePhotoTypeDtoOut.self, from: data)
                } catch {
                    err = error
                }
            case.failure(let error):
                err = error
            }
            callBack(jsonValue, err)
        }
    }
    
    static func postPhoto(id: String, name: String, image: UIImage, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let url = "https://your-api-endpoint.com/upload"
        let parameters: [String: Any] = [
            "id": id,
            "name": name,
            "photo": imageData.base64EncodedString()
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value as Any))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
 


