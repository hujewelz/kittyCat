//
//  AlertView.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/5/26.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifer = "actionsheetcell"
fileprivate let footerIdentifier = "sectionFooter"

@objc public  protocol ActionSheetDelegate: NSObjectProtocol {
    @objc optional func actionSheet(_ actionSheet: ActionSheet, clickedButtonAt buttonIndex: Int)
}

public class ActionSheet: UIView {
    
    fileprivate var otherButtonTitles: [String]?
    fileprivate var cancelButtonTitle = "取消"
    
    weak public var delegate: ActionSheetDelegate?
    
    public var clickedButtonAt: ((Int) -> Void)?
    
    fileprivate var disableIndex: Int = -1
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 48
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.separatorColor
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: footerIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        return tableView
    }()
    
    private var tableViewHeight: CGFloat = 48

    
    convenience public init(delegate: ActionSheetDelegate?,cancelButtonTitle: String?, otherButtonTitles: String...) {
        self.init(delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    public init(delegate: ActionSheetDelegate?,cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        
        self.delegate = delegate
        self.otherButtonTitles = otherButtonTitles
        
        if let title = cancelButtonTitle {
            self.cancelButtonTitle = title
        }
        
        if let others = otherButtonTitles  {
            tableViewHeight = CGFloat((others.count + 1) * 48 + 10)
        }
        
        super.init(frame: ScreenRect)
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(tableViewHeight)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.actionSheet?(self, clickedButtonAt: -1)
        dismiss()
    }
    
    public func setDisableItem(at index: Int) {
        disableIndex = index
    }
    
    public func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        if !window.subviews.contains(self) {
            window.addSubview(self)
        }
        
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            self.tableView.transform = CGAffineTransform(translationX: 0, y: -self.tableViewHeight)
        }, completion: nil)
    }
    
    
    public func dismiss() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.tableView.transform = CGAffineTransform.identity
        }) { finished in
            self.removeFromSuperview()
        }
    }

}

extension ActionSheet: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if otherButtonTitles == nil {
            return 1
        }
        
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let otherTitles = otherButtonTitles else {
            return 1
        }
        return otherTitles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(r: 81, g: 88, b: 102)
        cell.textLabel?.font = UIFont.pingFang(.regular, size: 17)
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        
        if otherButtonTitles == nil || indexPath.section == 1 {
            cell.textLabel?.text = cancelButtonTitle
        } else {
            cell.textLabel?.text = otherButtonTitles?[indexPath.row]
            if case 0..<otherButtonTitles!.count = disableIndex, indexPath.row == disableIndex {
                cell.textLabel?.textColor = UIColor(r: 206, g: 210, b: 219)
            } else {
                cell.textLabel?.textColor = UIColor(r: 81, g: 88, b: 102)
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if otherButtonTitles == nil || section == 1 {
            return 0.1
        }
        return 10
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor(hexValue: 0xF2F4F8)
        return footer
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if otherButtonTitles != nil {
            if case 0..<otherButtonTitles!.count = disableIndex, indexPath.row == disableIndex {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        }
        
        if indexPath.section == 1 {
            dismiss()
            return
//            let row = otherButtonTitles!.count
//            delegate?.actionSheet?(self, clickedButtonAt: row)
//            clickedButtonAt?(row)
        }
        
        delegate?.actionSheet?(self, clickedButtonAt: indexPath.row)
        clickedButtonAt?(indexPath.row)
        dismiss()
    }
}


