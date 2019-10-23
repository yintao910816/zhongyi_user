//
//  MyBBSViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/6.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD

class MyBBSViewController: BaseViewController {
    
    var context : JSContext?
    
    lazy var segmentedV : UISegmentedControl = UISegmentedControl.init(items: ["帖子", "关注", "回复"])
    
    lazy var scrollV : UIScrollView = {
        let space = AppDelegate.shareIntance.space
        let s = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return s
    }()
    
    lazy var articleWV : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let a = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return a
    }()
    
    lazy var attentionWV : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let s = UIWebView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return s
    }()
    
    lazy var replyWV : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let r = UIWebView.init(frame: CGRect.init(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return r
    }()
    
    
    
    let urlArr = [ARTICLE_URL, ATTENTION_URL, REPLY_URL]
    
    var segmentIndex : CGFloat?{
        didSet{
            if let i = segmentIndex{
                scrollV.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * i, y: 0), animated: true)
                let intN = Int(i)
                let s = urlArr[intN]
                let baseS = UserDefaults.standard.value(forKey: kbbsFgiUrl) as? String
                let bbsToken = UserDefaults.standard.value(forKey: kBBSToken) as? String
                guard let bbsURL = baseS else{return}
                guard let token = bbsToken else{return}
                let urlS = bbsURL + s + "?BBSToken=" + token
                let url = URL.init(string: urlS)
                guard let u = url else{return}
                switch intN{
                case 0:
                    articleWV.loadRequest(URLRequest.init(url: u))
                case 1:
                    attentionWV.loadRequest(URLRequest.init(url: u))
                case 2:
                    replyWV.loadRequest(URLRequest.init(url: u))
                default:
                    HCPrint(message: "something wrong")
                }
            }
        }
    }
    
    var currentIndex : CGFloat?{
        didSet{
            if let i = currentIndex{
                segmentedV.selectedSegmentIndex = Int(i)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNaviView()
        initContentV()
        
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkBBSToken()
    }
    
    func checkBBSToken(){
        let bbsToken = UserDefaults.standard.value(forKey: kBBSToken)
        guard bbsToken == nil else{
            segmentIndex = 0
            return
        }
        
        HttpRequestManager.shareIntance.HC_getBBSToken { [weak self](success, msg) in
            if success == true {
                self?.segmentIndex = 0
            }else{
                HCShowError(info: msg)
            }
        }
    }
    
    func initContentV(){
        self.view.addSubview(scrollV)
        scrollV.bounces = false
        scrollV.delegate = self
        scrollV.isPagingEnabled = true
        
        scrollV.addSubview(articleWV)
        articleWV.delegate = self
        
        scrollV.addSubview(attentionWV)
        attentionWV.delegate = self
        
        scrollV.addSubview(replyWV)
        replyWV.delegate = self
        
        scrollV.contentSize = CGSize.init(width: SCREEN_WIDTH * 3, height: 0)
    }
    
    func initNaviView(){
        
        segmentedV.frame = CGRect.init(x: 0, y: 0, width: 225, height: 30)
        segmentedV.tintColor = kDefaultThemeColor
        segmentedV.selectedSegmentIndex = 0
        
        segmentedV.addTarget(self, action: #selector(MyBBSViewController.segmentedAction), for: UIControlEvents.valueChanged)
        
        self.navigationItem.titleView = segmentedV
    }
    
    
    func segmentedAction(sender : UISegmentedControl){
        if segmentIndex != CGFloat(sender.selectedSegmentIndex) {
            segmentIndex = CGFloat(sender.selectedSegmentIndex)
        }
    }
    
    func openURL(url : String, title: String){
        var tempURL : String!
        if url.contains("?"){
            tempURL = url + "&bbsToken=" + (UserManager.shareIntance.HCUserInfo?.BBSToken)!
        }else{
            tempURL = url + "?bbsToken=" + (UserManager.shareIntance.HCUserInfo?.BBSToken)!
        }
        
        DispatchQueue.main.async {[weak self]()in
            let webVC = WebViewController()
            webVC.url = tempURL
            self?.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension MyBBSViewController : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        HCPrint(message: "decelerating")
        pauseScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        HCPrint(message: "animation")
        pauseScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            HCPrint(message: "dragging")
            pauseScroll()
        }
    }
    
    func pauseScroll(){
        let offsetX = scrollV.contentOffset.x
        let index = offsetX / SCREEN_WIDTH
        
        if currentIndex != index {
            currentIndex = index
        }
    }
}

extension MyBBSViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        HCPrint(message: "webViewDidStartLoad")
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HCPrint(message: "webViewDidFinishLoad")
        SVProgressHUD.dismiss()
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        // JS获取BBSToken
        let getBBSToken: @convention(block) () ->(String) = {
            let bbsToken = UserDefaults.standard.value(forKey: kBBSToken)
            let s = bbsToken as! String
            return s
        }
        context?.setObject(unsafeBitCast(getBBSToken, to: AnyObject.self), forKeyedSubscript: "getBBSToken" as NSCopying & NSObjectProtocol)
        
        
        // JS调用打开网页
        let nativeOpenURL: @convention(block) () ->() = {
            let array = JSContext.currentArguments() // 这里接到的array中的内容是JSValue类型
            self.openURL(url: (array?[0] as AnyObject).toString(), title: (array?[1] as AnyObject).toString())
        }
        context?.setObject(unsafeBitCast(nativeOpenURL, to: AnyObject.self), forKeyedSubscript: "nativeOpenURL" as NSCopying & NSObjectProtocol)
        
        
        context?.exceptionHandler = {(context, value)in
            HCPrint(message: value)
        }
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        HCPrint(message: "shouldStartLoadWith")
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        HCShowError(info: "浏览器错误")
        HCPrint(message: error.localizedDescription)
    }
    
}

