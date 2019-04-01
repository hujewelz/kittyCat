//
//  CatAPI.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import Foundation
import Hotaru

let BASE_URL = "https://api.thecatapi.com/v1"
let API_KEY = "bc380686-662d-45ce-b3df-1cd61e499598"

extension TargetType {
    var baseURL: URL { return  URL(string: BASE_URL)! }
    
    var headers: Hotaru.Headers? {
        return ["Content-Type": "application/json", "x-api-key": API_KEY]
    }
}

enum CatAPI {
    case images(page: Int)
    case detail(String)
    case favourite(String)
}

extension CatAPI : TargetType {
    var path: String {
        switch self {
        case .images(page: let p):
            return "/images/search?page=\(p)&limit=10"
        case .detail(let id):
            return "/images/\(id)"
        case .favourite:
            return "/favourites/"
        }
    }
    
    var method: Hotaru.Method {
        switch self {
        case .favourite:
            return .post
        default:
            return .get
        }
    }
    
    var paramaters: Hotaru.Parameters? {
        switch self {
        case .favourite(let id):
            return ["image_id": id, "sub_id": "123"]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .favourite:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}
