//
//  SegmentControll.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/5/31.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public class SegmentControll: UIView {
    lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue_3090ff
        return view
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backGroundGray
        return view
    }()
    
    public var titles: [String] {
        didSet {
            setupTitles(titles)
        }
    }
    
    // 设置滚动到某一选项卡
    public var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex >= self.titles.count {
                return
            }
            
            guard let button = viewWithTag(selectedIndex+1) as? UIButton else {
                return
            }
            
            relayoutButton(button)
        }
    }
    
    public var clickedAt: ((Int) -> Void)?
    
    public init(titles: [String]) {
        self.titles = titles
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 48))
       // shadowDirection = .down
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        setupTitles(titles)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addBadge(at index: Int) {
        if index >= titles.count { return }
        
        if let _ = viewWithTag(index + 9999) { return }
        
        let title = titles[index]
        let view = UIView()
        view.backgroundColor = UIColor.red_fd7644
        view.tag = index + 9999
        view.cornerRadius = 4
        let titleWidth = title.size(font: UIFont.pingFang(.regular, size: 14)).width
        let x = width / CGFloat(titles.count * 2) +  width / CGFloat(titles.count) * CGFloat(index) + titleWidth / 2 - 2
        view.frame = CGRect(x: x, y: 14, width: 8, height: 8)
        addSubview(view)
    }
    
    public func removeBadge(at index: Int) {
        guard let view = viewWithTag(index + 9999) else { return }
        view.removeFromSuperview()
    }
    
    // MARK: - Private
    
    private func setupTitles(_ titles: [String]) {
    
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let count = titles.count
        
        for (index, title) in titles.enumerated() {
            let button = generateButton(with: title)
            button.tag = index + 1
            button.addTarget(self, action: #selector(SegmentControll.buttonClicked(_:)), for: .touchUpInside)
            addSubview(button)
            button.snp.remakeConstraints({ make in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.width.equalTo(self).dividedBy(count)
                make.height.equalTo(self.snp.height)//.offset(-1)
                
            })
            
            guard let lastButton = viewWithTag(index) as? UIButton, index >= 1 else {
                continue
            }
            
            button.snp.remakeConstraints({ make in
                make.left.equalTo(lastButton.snp.right)
                make.top.equalTo(self)
                make.width.equalTo(self).dividedBy(count)
                make.height.equalTo(self.snp.height)//.offset(-1)
            })
        }
        
        guard let firstButton = viewWithTag(1) as? UIButton else {
            return
        }
        firstButton.isSelected = true
        addSubview(underLineView)
        let font = firstButton.titleLabel?.font
        let width = firstButton.currentTitle?.size(withAttributes: [.font: font!]).width ?? 0
        underLineView.snp.remakeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(2)
            make.width.equalTo(width+16)
            make.centerX.equalTo(firstButton.snp.centerX)
        }
        
        
    }
    
    var lastSelected = 1
    
    @objc private func buttonClicked(_ sender: UIButton) {
        relayoutButton(sender)
        clickedAt?(sender.tag - 1)
    }
    
    private func relayoutButton(_ sender: UIButton) {
        if sender.tag == lastSelected {
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        guard let button = viewWithTag(lastSelected) as? UIButton else {
            lastSelected = sender.tag
            return
        }
        button.isSelected = !sender.isSelected
        let font = sender.titleLabel?.font
        let Cwidth = sender.currentTitle?.size(withAttributes: [.font: font!]).width ?? 0
        let translationX = (width / CGFloat(titles.count)) * CGFloat(sender.tag - 1)
        UIView.animate(withDuration: 0.25) {
            self.underLineView.snp.updateConstraints({ (make) in
                make.width.equalTo(Cwidth+16)
            })
            self.underLineView.transform = CGAffineTransform(translationX: translationX, y: 0)
        }
        
        lastSelected = sender.tag

    }
    
    private func generateButton(with title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.pingFang(.regular, size: 15)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.textBlack, for: .normal)
        button.setTitleColor(UIColor.blue_3090ff, for: .selected)
        
        return button
    }
    
}
