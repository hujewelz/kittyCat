//
//  Resource.swift
//  SWKit
//
//  Created by huluobo on 2018/1/2.
//

import Foundation
import Hotaru

public struct Resource<Target, R> where Target: TargetType {
    public var target: Target
    
    public var parse: (Data) -> R?
}

public extension Resource {
    init(target: Target, JSONParse: @escaping (Any) -> R?) {
        self.target = target
        self.parse = { data in
            let result = try? JSONSerialization.jsonObject(with: data, options: [])
            return result.flatMap{ JSONParse($0) }
        }
    }
    
    static func from(_ target: Target) -> Resource<Target, Data> {
        return Resource<Target, Data>(target: target) { (data) -> Data? in
            return data
        }
    }
}
