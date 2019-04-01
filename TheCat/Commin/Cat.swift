//
//  Cat.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit

struct Cat { // as a namespace
    
    
}

extension Cat {
    struct Image : Decodable {
        var id: String
        var url: String
        var width: Int
        var height: Int
    }
}

extension Cat.Image {
    static func from(_ obj: Any) -> Cat.Image {
        guard let data = try? JSONSerialization.data(withJSONObject: obj),
        let img = try? JSONDecoder().decode(Cat.Image.self, from: data) else { return Cat.Image.empty}
        return img
    }
    
    static func images(_ obj: Any) -> [Cat.Image] {
        guard let data = try? JSONSerialization.data(withJSONObject: obj),
            let imgs = try? JSONDecoder().decode([Cat.Image].self, from: data) else { return [Cat.Image.empty]}
        return imgs
    }
    
    static var empty: Cat.Image {
        return Cat.Image(id: "", url: "", width: 0, height: 0)
    }
    
    var size: CGSize {
        let w = UIScreen.main.bounds.width
        guard width * height > 0 else {
            return CGSize(width: w, height: 120)
        }
        
        let h = w * CGFloat(height) / CGFloat(width)
        return CGSize(width: w, height: h)
    }
}


extension Cat {
    struct Detail {
        var id: String
        var url: String
        var sub_id: String
    }
}
