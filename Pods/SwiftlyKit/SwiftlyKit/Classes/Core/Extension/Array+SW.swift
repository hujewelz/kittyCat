//
//  Array+SW.swift
//  SWKit
//
//  Created by Scyano on 2018/7/12.
//

import Foundation

public extension Array where Element: Equatable {
    // 稳定的数组去重
    func deduplicate() -> [Element] {
        return self.reduce([Element]()) {
            var result = $0
            if !$0.contains($1) {
                result.append($1)
            }
            return result
        }
    }
}
