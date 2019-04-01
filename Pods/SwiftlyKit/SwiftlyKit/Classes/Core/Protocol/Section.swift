//
//  Section.swift
//  SWKit
//
//  Created by huluobo on 2017/11/13.
//

import Foundation

public protocol Section {
    associatedtype Item
    
    /// The section title
    var title: String { get }
    
    /// The section items
    var items: [Item] { get }
}
