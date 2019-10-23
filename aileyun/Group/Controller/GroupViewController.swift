//
//  GroupViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/7.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD

class GroupViewController: BaseViewController {
    
    var context : JSContext?
    
    lazy var segmentedV : UISegmentedControl = UISegmentedControl.init(items: ["推荐", "圈子"])
    
    lazy var scrollV : UIScrollView = {
        let space = AppDelegate.shareIntance.space
        let s = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return s
    }()

    lazy var recommendWV : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let r = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return r
    }()
    
    lazy var groupWV : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let g = UIWebView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return g
    }()
    
    var currentIndex : CGFloat?{
        didSet{
            let bbsToken = UserManager.shareIntance.HCUserInfo?.BBSToken
            guard bbsToken != nil else{return}
            
            HCPrint(message: bbsToken)
            
            let bbsRootUrl = UserManager.shareIntance.HCUserInfo?.bbsFgiUrl
            guard bbsRootUrl != nil else {return}
            
            if currentIndex == 0 {
                segmentedV.selectedSegmentIndex = 0
                if recommendWV.request == nil{
                    let url = bbsRootUrl! + urlArr[0] + "?bbsToken=" + bbsToken!
                    recommendWV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
                }
            }else if currentIndex == 1{
                segmentedV.selectedSegmentIndex = 1
                if groupWV.request == nil{
                    let url = bbsRootUrl! + urlArr[1] + "?bbsToken=" + bbsToken!
                    groupWV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
                }
            }
            scrollV.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * currentIndex!, y: 0), animated: true)
        }
    }
    
    
    let urlArr = [RECOMMEND_URL, GROUP_URL]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNaviView()
        
        initContentV()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.groupNotification), name: NSNotification.Name.init(GO_TO_GROUP), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.refreshData), name: NSNotification.Name.init(DELETE_ARTICLE), object: nil)
        
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SVProgressHUD.dismiss()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentIndex == nil {
            currentIndex = 0
        }
        checkBBSToken()
    }
    
    func checkBBSToken(){
        let bbsToken = UserDefaults.standard.value(forKey: kBBSToken)
        guard bbsToken == nil else{return}
        
        HttpRequestManager.shareIntance.HC_getBBSToken { [weak self](success, msg) in
            if success == true {
                self?.currentIndex = 0
            }else{
                HCShowError(info: msg)
            }
        }
    }
    
    func refreshData(){
        recommendWV.reload()
        groupWV.reload()
    }
    
    func groupNotification(){
        currentIndex = 1
    }

    
    func initContentV(){
        self.view.addSubview(scrollV)
        scrollV.bounces = false
        scrollV.delegate = self
        scrollV.isPagingEnabled = true
        
        scrollV.addSubview(recommendWV)
        recommendWV.delegate = self
        
        scrollV.addSubview(groupWV)
        groupWV.delegate = self
        
        scrollV.contentSize = CGSize.init(width: SCREEN_WIDTH * 2, height: 0)
    
    }
    
    func initNaviView(){

        segmentedV.frame = CGRect.init(x: 0, y: 0, width: 160, height: 30)
        segmentedV.tintColor = kDefaultThemeColor
        segmentedV.selectedSegmentIndex = 0
        
        segmentedV.addTarget(self, action: #selector(GroupViewController.segmentedAction), for: UIControlEvents.valueChanged)
        
        self.navigationItem.titleView = segmentedV
        
    }
    
    func segmentedAction(sender : UISegmentedControl){
        if currentIndex != CGFloat(sender.selectedSegmentIndex) {
            currentIndex = CGFloat(sender.selectedSegmentIndex)
        }
    }
    
    
    func popViewController(){
        var webV : UIWebView!
        switch currentIndex! {
        case 0:
            webV = recommendWV
        case 1:
            webV = groupWV
        default:
            HCPrint(message: "something wrong")
        }
        
        if webV.canGoBack{
            webV.goBack()
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

extension GroupViewController : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        HCPrint(message: "decelerating")
        if scrollView == scrollV{
            pauseScroll()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        HCPrint(message: "animation")
        if scrollView == scrollV{
            pauseScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == scrollV{
            if decelerate == false {
                HCPrint(message: "dragging")
                pauseScroll()
            }
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

extension GroupViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        HCPrint(message: "webViewDidStartLoad")
//        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HCPrint(message: "webViewDidFinishLoad")
//        SVProgressHUD.dismiss()
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        // JS获取BBSToken
        let getBBSToken: @convention(block) () ->(String) = {
            let bbsToken = UserManager.shareIntance.HCUserInfo?.BBSToken
            return bbsToken!
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

