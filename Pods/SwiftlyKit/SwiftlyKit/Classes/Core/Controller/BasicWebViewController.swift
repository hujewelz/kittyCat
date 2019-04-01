//
//  BasicWebViewController.swift
//  XiaoMei
//  webView基类
//  Created by like on 2018/1/10.
//

import UIKit
import WebKit

public protocol WKScriptMessageHandable {
    
    var scriptMessageHandler: WKScriptMessageHandler? { get }
    
    var scriptMessageNames: [String]? { get }
}

open class BasicWebViewController: UIViewController, Loadable, WKScriptMessageHandable {
    
    open var webView: WKWebView!
    
    open var presenter: UIView?
    open var loadingView = DefaultLoadingView()
    
    open var configuration: WKWebViewConfiguration?

    public var scriptMessageHandler: WKScriptMessageHandler?
    
    public var scriptMessageNames: [String]? = ["jump"] {
        didSet {
            guard let messageNames = scriptMessageNames else {
                return
            }
            _scriptMessageNames.removeAll()
            _scriptMessageNames.append(contentsOf: messageNames)
            if !_scriptMessageNames.contains("jump") {
                _scriptMessageNames.append("jump")
            }
        }
    }
    
    
    // MARK: - Lifecycle
    public init(request: URLRequest, configuration: WKWebViewConfiguration? = nil) {
        _request = request
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init?(urlString: String, configuration: WKWebViewConfiguration? = nil) {
        guard let url = URL(string: urlString) else { return nil }
        let request = URLRequest(url: url)
       
        self.init(request: request, configuration: configuration)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        scriptMessageHandler = self
        setupSubviews()
        startLoading()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addMessageHandler()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeMessageHandler()
    }
    
    private func setupSubviews() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.groupTableViewBackground
        
        var configuration: WKWebViewConfiguration!
        if self.configuration == nil {
            configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            let userController = WKUserContentController()
            configuration.userContentController = userController
        } else {
            configuration = self.configuration!
        }
       
        let y: CGFloat = self.navigationController != nil ? 64 : 0
        webView = WKWebView(frame: CGRect(x: 0, y: y, width: ScreenW, height: ScreenH-y), configuration: configuration)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.load(_request)
    }
    
    // MARK: - Public
    
    open func naviBack() {
        if !webView.canGoBack {
            navigationController?.popViewController(animated: true)
        } else {
            webView.goBack()
        }
    }
    
    ///实现此方法来进行 webview加载完成需要的额外操作
    open func webViewDidFinished() {}
    ///处理js交互
    open func handleMessageFromWebview(with name: String, data: [String: Any]) {}
    
    // MARK: - Utils
    
    private func addMessageHandler() {
        if let handler = scriptMessageHandler {
            for name in _scriptMessageNames {
                webView.configuration.userContentController.add(handler, name: name)
            }
        }
    }
    
    private func removeMessageHandler() {
        for name in _scriptMessageNames {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
    
    public func reload() {
        webView.load(_request)
    }
    

    fileprivate let _request: URLRequest!
    fileprivate var _scriptMessageNames: [String] = ["jump"]
}

extension BasicWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (data, error) in
            if let title = data as? String {
                self.title = title
            }
        }
        self.webViewDidFinished()
        self.loadingView.isError = false
        stopLoading()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let error = error as NSError
        if error.code != -999 {
            self.loadingView.isError = true
            stopLoading()
        }
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loadingView.isError = true
        stopLoading()
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingView.isError = false
        startLoading()
    }
}


extension BasicWebViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let string = message.body as? String,
            let data = string.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = json as? [String: Any] else { return }
        
        print("name: ", message.name, ", body: ", dict)
        handleMessageFromWebview(with: message.name, data: dict)
    }
        
}
