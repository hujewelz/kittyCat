//
//  HomeViewController.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit
import SwiftlyKit
import SwiftyJSON

protocol HomeViewControllerDelegate : class {
    func homeViewControllerDidPresentProfileVC(_ vc: HomeViewController)
}

class RootViewController: UIViewController, UIScrollViewDelegate {
    
    weak var homeVC: HomeViewController?
    
    var didHideStatusBar = true { didSet { setNeedsStatusBarAppearanceUpdate() } }
    
    override var prefersStatusBarHidden: Bool { return didHideStatusBar }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: ScreenRect)
        scrollView.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: ScreenW * 2, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        automaticallyAdjustsScrollViewInsets = false
        
        let home = HomeViewController()
        homeVC = home
        scrollView.addSubview(home.view)
        addChild(home)
        home.didMove(toParent: self)
        
        let newVC = NewViewController()
        newVC.leftButtonClicked = {
            self.scrollView.setContentOffset(.zero, animated: true)
        }
        let addNew = BaseNavigationController(rootViewController: newVC)
        scrollView.addSubview(addNew.view)
        addChild(addNew)
        addNew.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (i, vc) in children.enumerated() {
            vc.view.frame = CGRect(x: CGFloat(i) * ScreenW, y: 0, width: ScreenW, height: ScreenH)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        didHideStatusBar = x == 0
        UserDefaults.standard.set(true, forKey: "scrollToRight")
        homeVC?.disableArrowAnimation()
    }
}

class HomeViewController : UICollectionViewController, Loadable {
    
    struct CatLayout {
        let cat: Cat.Image
        var size: CGSize
        
        init(cat: Cat.Image) {
            self.cat = cat
            size = cat.size
        }
    }
    
    var loadingView = CatLoadingView()
    
    var headerView: HomeHeaderView?
    
    lazy var animatedArrorView = UIImageView(image: UIImage(named: "arror_right"))
    
    var page = 0
    
    fileprivate var resource: Resource<CatAPI, [CatLayout]>
    
    weak var delegate: HomeViewControllerDelegate?
    
    var layouts: [CatLayout] = [] {
        didSet { collectionView!.reloadData() }
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    init() {
        resource = Resource(target: CatAPI.images(page: 0)) { Cat.Image.images($0).compactMap(CatLayout.init) }
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        beginRefreshing(false)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layouts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HomeCatFlowCell
        let item = layouts[indexPath.item]
        cell.catImageView.setImage(with: item.cat.url)
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCatFlowCell
        let rect = cell.convert(cell.catImageView.frame, to: view)
        let item = layouts[indexPath.item]
        let vc = CatDetailViewController(catImage: item.cat, rect: rect)
        present(vc, animated: true, completion: nil)
    }
    
    func disableArrowAnimation() {
        animatedArrorView.layer.removeAllAnimations()
        animatedArrorView.isHidden = true
    }
    
    private func fetchData() {
        resource.target = CatAPI.images(page: page)
        
        load(with: resource) {[weak self] (images) in
            guard let `self` = self, let images = images else { return }
            self.collectionView!.mj_header.endRefreshing()
            self.collectionView!.mj_footer.endRefreshing()
            self.collectionView!.mj_footer.isHidden = images.count < 10
            if self.page == 0 {
                self.layouts = images
            } else {
                self.layouts.append(contentsOf: images)
            }
        }
    }
    
    private func setupView() {
        if #available(iOS 11.0, *) {
            collectionView!.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.cornerRadius = 8
        view.backgroundColor = UIColor.white
        self.collectionView!.registerNib(HomeCatFlowCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
        loadingView.reloadData = { [weak self] in
            self?.loadNewData()
        }
        
        // 
        if UserDefaults.standard.bool(forKey: "scrollToRight") { return }
        view.addSubview(animatedArrorView)
        animatedArrorView.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.top.equalTo(120)
        }
        aimated(animatedArrorView)
    }
    
    private func aimated(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = ScreenW - 52 - 10
        animation.toValue = ScreenW - 52 + 10
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        animation.duration = 0.5
        animation.repeatCount = 999999999
        view.layer.add(animation, forKey: "shake")
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = layouts[indexPath.item].size
        return s
    }
}

extension HomeViewController : Refreshable {
    func viewForHeader() -> UIScrollView? {
        return collectionView
    }
    
    func viewForFooter() -> UIScrollView? {
        return collectionView
    }
    
    func loadNewData() {
        page = 0
        self.collectionView!.mj_footer.state = .idle
        fetchData()
    }
    
    func loadPageData() {
        page += 1
        fetchData()
    }
}


