//
//  Refreshable.swift
//  DogSay
//
//  Created by jewelz on 2017/4/29.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import Foundation
import MJRefresh

public protocol Refreshable: class {
    
    var header: MJRefreshHeader { get }
    var footer: MJRefreshFooter { get }
    
    func viewForHeader() -> UIScrollView?
    
    func viewForFooter() -> UIScrollView?
    
    func loadNewData()
    
    func loadPageData()
}

public extension Refreshable {
    
    public var header: MJRefreshHeader {
//        let h = XMRefreshHeader(refreshingBlock: { [weak self] in
//            self?.loadNewData()
//        })
        let h = MJRefreshHeader(refreshingBlock: { [weak self] in
            self?.loadNewData()
        })
        return h!
    }
    
    public var footer: MJRefreshFooter {
        let f = SWRefreshFooter(refreshingBlock: { [weak self] in
            self?.loadPageData()
        })
        return f!
    }
    
    
    public func beginRefreshing(_ isRefresh: Bool = true) {
        
        if viewForHeader() != nil && viewForHeader()?.mj_header == nil {
            viewForHeader()?.mj_header = header
            header.refreshingBlock = { [weak self] in
                self?.loadNewData()
            }
            if isRefresh {
                viewForHeader()?.mj_header.beginRefreshing()
            }
        }
        
        if viewForFooter() != nil && viewForFooter()?.mj_footer == nil {
            viewForFooter()?.mj_footer = footer
            footer.refreshingBlock = { [weak self] in
                self?.loadPageData()
            }
        }
    }
    
    public func viewForHeader() -> UIScrollView? {
        return nil
    }
    
    public func viewForFooter() -> UIScrollView? {
        return nil
    }
    
    public func loadNewData() {}
    
    public func loadPageData() {}
}
