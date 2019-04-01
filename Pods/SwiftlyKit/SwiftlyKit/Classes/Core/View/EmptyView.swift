
import UIKit
import SnapKit

public class EmptyView: UIView, EmptyViewType {
    
    public var buttonTaped: (() -> Void)?
    
    /// 图片名称
    public var placeholderIconName: String = "noData" {
        didSet {
            imageView.image = UIImage.bundleImage(named: placeholderIconName)
        }
    }
    
    /// 提示文字
    public var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    /// 按钮标题
    public var buttonTitle: String? {
        didSet {
            button.isHidden = buttonTitle == nil
            button.setTitle(buttonTitle, for: .normal)
            _updateConstraintsIfNeeded()
        }
    }
    
    public var subTitle: String? {
        didSet {
            subLabel.isHidden = subTitle == nil
            subLabel.text = subTitle
            _updateConstraintsIfNeeded()
        }
    }
    
    /// 是否隐藏按钮
    public var isButtonHidden: Bool = false {
        didSet {
            button.isHidden = isButtonHidden
            _updateConstraintsIfNeeded()
        }
    }
    /// 补丁, 调整按钮和图片的间距
    public var buttonTopConstraint: Constraint!
    private var imageViewBottomConstraint: Constraint!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public init(frame: CGRect,placeholderIconName: String = "noData",
                text: String?,
                buttonTitle: String? = nil,
                subTitle: String? = nil) {
        self.placeholderIconName = placeholderIconName
        self.text = text
        self.subTitle = subTitle
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        setupView()
    }
    
    public convenience init(placeholderIconName: String = "noData",
                            text: String?,
                            buttonTitle: String? = nil,
                            subTitle: String? = nil) {
        self.init(frame: ScreenRect,
                  placeholderIconName: placeholderIconName,
                  text: text,
                  buttonTitle: buttonTitle,
                  subTitle: subTitle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.bundleImage(named: "noData")
        return imageV
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel(font: UIFont.pingFang(.medium, size: 16), textColor: UIColor(hexValue: 0x878794))
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel(font: UIFont.pingFang(.regular, size: 14), textColor: UIColor(hexValue: 0xa9a9b8))
        return label
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setBackgroundImage(UIImage.bundleImage(named: "list_button_icon_small"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    private func setupView() {
        backgroundColor = UIColor(hexValue: 0xF8F7FC)
        imageView.image = UIImage.bundleImage(named: placeholderIconName)
        textLabel.text = text
        subLabel.text = subTitle
        subLabel.isHidden = subTitle == nil
        button.setTitle(buttonTitle, for: .normal)
        button.isHidden = buttonTitle == nil
        
        let container = UIView()
        container.backgroundColor = UIColor.clear
        addSubview(container)
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        container.addSubview(imageView)
        container.addSubview(textLabel)
        container.addSubview(subLabel)
        container.addSubview(button)
        
        let imageViewBottom = imageViewBottomOffSet()
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            self.imageViewBottomConstraint = make.bottom.equalTo(imageViewBottom).constraint
        }
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView).offset(-7)
        }
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
        button.addTarget(self, action: #selector(EmptyView.buttonClicked), for: .touchUpInside)
        button.snp.makeConstraints { [unowned self] make in
            make.centerX.equalToSuperview()
            self.buttonTopConstraint = make.top.equalTo(imageView.snp.bottom).offset(28).constraint
        }
        
    }
    
    @objc private func buttonClicked() {
        buttonTaped?()
    }
    
    private func _updateConstraintsIfNeeded() {
        let bottom = imageViewBottomOffSet()
        imageViewBottomConstraint.update(offset: bottom)
    }
    
    private func imageViewBottomOffSet() -> CGFloat {
        var imageViewBottom: CGFloat = 0
        if !button.isHidden {
            imageViewBottom = 28 + 56
        } else if !subLabel.isHidden {
            imageViewBottom = 16
        }
        return -imageViewBottom
    }
}
