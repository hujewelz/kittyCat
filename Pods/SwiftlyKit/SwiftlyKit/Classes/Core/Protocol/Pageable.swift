
import UIKit
import MJRefresh

// 在单控制器多数据列表时不适用
public protocol Pageable: class {
    associatedtype ItemType
    
    // 当前页码
    var page: Int { get set }
    // 单页最大数量
    var maxCountPerList: Int { get }
    // 数据列表
    var dataList: [ItemType] { get set }
}

public extension Pageable where Self: UIViewController {
    var maxCountPerList: Int {
        return 20
    }
    
    func handleWithNewDataList(_ newDataList: [ItemType]?, scrollView: UIScrollView?) {
        scrollView?.mj_header.endRefreshing()
        scrollView?.mj_footer.state = .idle
        
        guard let newDataList = newDataList else {
            page -= 1
            return
        }
        if newDataList.count < maxCountPerList {
            scrollView?.mj_footer.state = .noMoreData
        }
        if page != 1 {
            dataList.append(contentsOf: newDataList)
        } else {
            dataList = newDataList
        }
    }
}
