//
//  LKRefreshFooter.swift
//  XuetangC
//
//  Created by like on 2017/11/28.
//

import Foundation
import MJRefresh
import SnapKit

public class SWRefreshHeader: MJRefreshNormalHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
        stateLabel.font = UIFont.pingFang(.light, size: 13)
        stateLabel.textColor = UIColor(hexValue: 0x999999)
        lastUpdatedTimeLabel.font = UIFont.pingFang(.light, size: 13)
        lastUpdatedTimeLabel.textColor = UIColor(hexValue: 0x999999)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



public class SWRefreshFooter: MJRefreshAutoNormalFooter {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stateLabel.font = UIFont.pingFang(.light, size: 13)
        stateLabel.textColor = UIColor(hexValue: 0x999999)
        self.setTitle("我也是有底线的", for: .noMoreData)
        addSubview(leftLine)
        addSubview(rightLine)
        let str = NSString(string: "我也是有底线的")
        let textSize = str.size(withAttributes: [NSAttributedStringKey.font: UIFont.pingFang(.regular, size: 14)])
        leftLine.snp.makeConstraints { (make) in
            make.width.equalTo(32);
            make.height.equalTo(01);
            make.right.equalTo(self.stateLabel.snp.centerX).offset(-12-textSize.width/2);
            make.centerY.equalTo(self.stateLabel);
        }
        rightLine.snp.makeConstraints { (make) in
            make.width.equalTo(32);
            make.height.equalTo(1);
            make.left.equalTo(self.stateLabel.snp.centerX).offset(12+textSize.width/2);
            make.centerY.equalTo(self.stateLabel);
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepare() {
        super.prepare()
        mj_h = 62
    }
    
    override public var state: MJRefreshState {
        didSet {
            leftLine.isHidden = !(state == .noMoreData)
            rightLine.isHidden = !(state == .noMoreData)
        }
    }
    
    private lazy var leftLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexValue: 0xc1c1c1)
        line.isHidden = true
        return line
    }()
    
    private lazy var rightLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexValue: 0xc1c1c1)
        line.isHidden = true
        return line
    }()
}
