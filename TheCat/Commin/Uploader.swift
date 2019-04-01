//
//  Uploader.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import Foundation
import Alamofire

final class Uploader {
    
    enum Result {
        case success
        case failure(Error)
    }
    
    static func upload(data: Data, completion: @escaping (Uploader.Result) -> Void) {
        let headers = ["x-api-key": API_KEY]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: "file", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            multipartFormData.append(AccountManager.shared.id!.data(using: .utf8)!, withName: "sub_id")
        }, to: URL(string: BASE_URL + "/images/upload")!,
           headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let code = response.response?.statusCode, code == 201 {
                        completion(.success)
                    } else {
                        let error = NSError(domain: "com.kittycat.error", code: 401, userInfo: ["msg": "Image was too big or did not contain a Cat"])
                        completion(.failure(error))
                    }
                    print(response.description)
                }
            case .failure(let encodingError):
                completion(.failure(encodingError))
            }
        }
    }
}
