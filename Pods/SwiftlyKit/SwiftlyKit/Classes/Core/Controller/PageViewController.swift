//
//  PageViewController.swift
//  XuetangC
//
//  Created by jewelz on 2017/10/31.
//

import UIKit

class PageContentViewController: UIViewController, Refreshable, Loadable, UITableViewDataSource, UITableViewDelegate {

    var presenter: UIView?
  
    var loadingView = DefaultLoadingView()
    
    var mainViewController: UIViewController?
    
    var tableView: UITableView!
    
    var page = 1
    var isLoadingPageData = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.backGroundGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 49, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 49, left: 0, bottom: 0, right: 0)
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        fetchData()
        beginRefreshing(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // stopLoading()
    }
    
    
    func fetchData() { }
    
    
    // MARK: - UITableViewDataSource && UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(false, "return cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusable", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: - Refreshabel
    
    func viewForHeader() -> UIScrollView? {
        return tableView
    }
    
    func viewForFooter() -> UIScrollView? {
        return tableView
    }
    
    
    func loadPageData() {
        page += 1
        isLoadingPageData = true
        loadData()
    }
    
    func loadNewData() {
        page = 1
        self.tableView.mj_footer.state = .idle
        isLoadingPageData = false
        loadData()
    }
}


class PageViewController: UIViewController {

    var titles: [String] {
        didSet {
            segmentControll.titles = titles
        }
    }
    
    var viewControllers: [PageContentViewController] = [] {
        didSet {
            addViewControllers(viewControllers)
        }
    }
    
    fileprivate lazy var segmentControll: SegmentControll = { [unowned self] in
        let segment = SegmentControll(titles: self.titles)
        segment.clickedAt = { [weak self] index in
            self?.switchFromCurrentViewController(to: index)
        }
        return segment
    }()
    
    fileprivate lazy var contentView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = UIColor.backGroundGray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    init(titles: [String]) {
        self.titles = titles
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, vc) in viewControllers.enumerated() {
            vc.view.frame = CGRect(x: CGFloat(index) * ScreenW, y: 0, width: ScreenW, height: ScreenH-64)
        }
        
    }

    func setupView() {
        view.addSubview(contentView)
        contentView.contentSize = CGSize(width: CGFloat(2) * ScreenW, height: 0)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(segmentControll)
        segmentControll.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.right.equalToSuperview()
            make.height.equalTo(49)
        }
    
    }
    
    func addViewController(_ vc: PageContentViewController) {
        vc.mainViewController = self
        contentView.addSubview(vc.view)
        addChildViewController(vc)
        didMove(toParentViewController: self)
    }
    
    func addViewControllers(_ vcs: [PageContentViewController]) {
        for vc in viewControllers {
            addViewController(vc)
        }
    }
    
    final func `switch`(to index: Int) {
        if index >= titles.count { return }
        if index < 0 { return }
        switchFromCurrentViewController(to: index)
        segmentControll.selectedIndex = index
    }
    
    // MARK: - Private
    
    private func switchFromCurrentViewController(to index: Int) {
        let offset = CGPoint(x: CGFloat(index) * ScreenW, y: contentView.contentOffset.y)
        contentView.setContentOffset(offset, animated: true)
    }

}

extension PageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / ScreenW + 0.5)
        segmentControll.selectedIndex = page
    }
}

