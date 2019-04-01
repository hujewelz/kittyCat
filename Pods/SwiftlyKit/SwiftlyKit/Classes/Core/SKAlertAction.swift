//
//  SKAlertAction.SKift
//  SKKit
//
//  Created by huluobo on 2018/12/29.
//

import UIKit

public protocol SKAlertActionStyleType {
    var tintColor: UIColor { get }
    var font: UIFont { get }
}

public extension SKAlertActionStyleType {
    var font: UIFont { return UIFont.systemFont(ofSize: 16) }
}

public typealias SKAlertActionHandler = (SKAlertActionType) -> Void

public protocol SKAlertActionType {
    var title: String? { get }
    var style: SKAlertActionStyleType { get }
    var isEnabled: Bool { get }
    var handler: (SKAlertActionHandler)? { get }
}

public extension SKAlertActionType {
    var isEnabled: Bool { return true }
}

open class SKAlertAction: SKAlertActionType {
    
    public var title: String? = "确定"
    
    public var style: SKAlertActionStyleType
    
    public var handler: SKAlertActionHandler?
    
    public init(title: String?, style: SKAlertActionStyleType = SKAlertActionStyle.default, handler: SKAlertActionHandler? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

public enum SKAlertActionStyle {
    case `default`
    case cancel
}

extension SKAlertActionStyle: SKAlertActionStyleType {
    public var tintColor: UIColor {
        switch self {
        case .default:
            return UIColor(hexValue: 0x55CFFE)
        case .cancel:
            return UIColor(hexValue: 0xFF6600)
        }
    }
}

