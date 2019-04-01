//
//  CatFlowService.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import Foundation
import Hotaru
import SwiftyJSON

struct CatFlowService {
    var page = 0
    
    mutating func fetchCats(with page: Int) {
        self.page = page
        
        Provider(CatAPI.images(page: page)).request { response in
            guard let data = response.data else { return }
            
            let cats = Cat.Image.images(data)
            
        }.addToCancelBag()
    }
}


struct CatService {
    static func saveAsFavourite(image: String, completion: @escaping (Bool) -> Void) {
        Provider(CatAPI.favourite(image)).request { response in
            guard let _ = response.data else {
                completion(false)
                return
            }
            completion(true)
        }.addToCancelBag()
    }
    
    static func catDetail(with id: String, completion: @escaping (Cat.Detail?) -> Void) {
        Provider(CatAPI.detail(id)).request { response in
            guard let data = response.data else {
                completion(nil)
                return
            }
            let dict = SwiftyJSON.JSON(data).dictionaryObject
            print("dict: ", dict)
//            completion(true)
        }.addToCancelBag()
    }
}
