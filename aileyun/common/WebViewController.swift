//
//  WebViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD

class WebViewController: BaseViewController {
    var url : String?{
        didSet{
            HCPrint(message: url)
            if url != oldValue{
                let hospId : String!
                if let i = UserManager.shareIntance.HCUser?.hospitalId {
                    hospId = String.init(format: "%d", i.intValue)
                }else{
                    hospId = "0"
                }
                
                let token = UserManager.shareIntance.HCUser?.token ?? "noToken"
                
                if url!.contains("?"){
                    if url!.contains("hospitalId"){
                        if url!.hasSuffix("&"){
                            url = url! + "token=" + token + "&navHead=aly"
                            requestData()
                        }else if url!.hasSuffix("token="){
                            url = url! + token + "&navHead=aly"
                            requestData()
                        }else{
                            url = url! + "&token=" + token + "&navHead=aly"
                            requestData()
                        }
                    }else{
                        if url!.hasSuffix("&"){
                            url = url! + "token=" + token + "&hospitalId=" + hospId + "&navHead=aly"
                            requestData()
                        }else if url!.hasSuffix("token="){
                            url = url! + token + "&hospitalId=" + hospId + "&navHead=aly"
                            requestData()
                        }else{
                            url = url! + "&token=" + token + "&hospitalId=" + hospId + "&navHead=aly"
                            requestData()
                        }
                    }
                }else{
                    if UserManager.shareIntance.HCUser?.token != nil {
                        url = url! + "?token=" + token + "&hospitalId=" + hospId + "&navHead=aly"
                    }
                    requestData()
                }
            }
            HCPrint(message: url)
        }
    }
    
    var params : [String : Any]?
    
    var context : JSContext?
    
    lazy var isPublishClick : Bool = false
    
    lazy var webView : UIWebView = {
        
        let space = AppDelegate.shareIntance.space
        
        let w = UIWebView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        w.scrollView.bounces = false
        w.delegate = self
        self.view.addSubview(w)
        return w
    }()
    
    lazy var animator = PopoverAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightItem = UIBarButtonItem.init(image: UIImage.init(named: "分类"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WebViewController.menu))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.url!.contains("postTopic.html"){
            let rightItem = UIBarButtonItem.init(title: "发表", style: .plain, target: self, action: #selector(WebViewController.publish))
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let leftItem = UIBarButtonItem(image: UIImage(named: "返回灰"), style: .plain, target: self, action: #selector(WebViewController.popViewController))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func requestData(){
        SVProgressHUD.show()
        let request = URLRequest.init(url: URL.init(string: url!)!)
        webView.loadRequest(request)
    }

    func popViewController(){
        if webView.canGoBack{
            webView.goBack()
        }else{
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //收藏帖子
    func collect(){
        _ = context?.evaluateScript("wyPtd.collection()")
    }
    
    func changeRightBarButton(status : NSNumber){
        DispatchQueue.main.async {[weak self]()in
            if status.intValue == 0 {
                let rightItem = UIBarButtonItem.init(title: "收藏", style: .plain, target: self, action: #selector(WebViewController.collect))
                self?.navigationItem.rightBarButtonItem = rightItem
            }else{
                let rightItem = UIBarButtonItem.init(title: "取消收藏", style: .plain, target: self, action: #selector(WebViewController.collect))
                self?.navigationItem.rightBarButtonItem = rightItem
            }
        }
    }
        
    
    //发表
    func publish(){
        guard isPublishClick == false else{
            HCShowInfo(info: "正在处理")
            return
        }
        self.view.endEditing(true)
        isPublishClick = true
        
        _ = context?.evaluateScript("wyPt.postTopic()")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self]()in
            self?.isPublishClick = false
        }
    }
    
    func menu(){
        self.hidesBottomBarWhenPushed = true
        let menuVC = WebMenuViewController()
        menuVC.naviVC = self.navigationController
        
        menuVC.modalPresentationStyle = .custom
        
        let space = AppDelegate.shareIntance.space
        
        animator.presentedFrame = CGRect(x: SCREEN_WIDTH - 160, y: space.topSpace + 50, width: 150, height: 114)
        menuVC.transitioningDelegate = animator
        
        self.present(menuVC, animated: true) {
            //
        }
    }
    
    func openURL(url : String, title: String){
        guard isRootURL(url: url) == false else {
            return
        }
        
        var tempURL : String!
        if url.contains("?"){
            tempURL = url + "&bbsToken=" + (UserManager.shareIntance.HCUserInfo?.BBSToken)!
        }else{
            tempURL = url + "?bbsToken=" + (UserManager.shareIntance.HCUserInfo?.BBSToken)!
        }
        
        DispatchQueue.main.async {[weak self]()in
            let webVC = WebViewController()
            webVC.url = tempURL
            webVC.navigationItem.title = title
            self?.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func isRootURL(url : String)->(Bool){
        if url.contains("recommend.html"){
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
            return true
        }else if url.contains("forumCircle.html"){
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
            let not = Notification.init(name: NSNotification.Name.init(GO_TO_GROUP), object: nil, userInfo: nil)
            NotificationCenter.default.post(not)
            return true
        }else{
            return false
        }
    }
    
    func setTitle(){
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"){
            self.navigationItem.title = title
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension WebViewController : UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        let s = request.url?.absoluteString
        if s == "app://reload"{
            webView.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
            return false
        }else if (s?.contains("http"))!{
            return true
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        HCPrint(message: "didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        HCPrint(message: "didFinishLoad")
        SVProgressHUD.dismiss()
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        // JS调用了无参数swift方法
        let backtohis: @convention(block) () ->() = {[weak self]in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        context?.setObject(unsafeBitCast(backtohis, to: AnyObject.self), forKeyedSubscript: "backtohis" as NSCopying & NSObjectProtocol)
        
        // JS调用打开网页
        let nativeOpenURL: @convention(block) () ->() = {
            let array = JSContext.currentArguments() // 这里接到的array中的内容是JSValue类型
            self.openURL(url: (array?[0] as AnyObject).toString(), title: (array?[1] as AnyObject).toString())
        }
        context?.setObject(unsafeBitCast(nativeOpenURL, to: AnyObject.self), forKeyedSubscript: "nativeOpenURL" as NSCopying & NSObjectProtocol)
        
        // JS调用改变收藏状态
        let postCollectStatus: @convention(block) () ->() = {
            let array = JSContext.currentArguments() // 这里接到的array中的内容是JSValue类型
            self.changeRightBarButton(status: (array?[0] as AnyObject).toNumber())
        }
        context?.setObject(unsafeBitCast(postCollectStatus, to: AnyObject.self), forKeyedSubscript: "postCollectStatus" as NSCopying & NSObjectProtocol)
        
        // JS调用删除帖子，回退并刷新界面
        let deleteArticle: @convention(block) () ->() = {
            DispatchQueue.main.async {[weak self]in
                let not = Notification.init(name: NSNotification.Name.init(DELETE_ARTICLE), object: nil, userInfo: nil)
                NotificationCenter.default.post(not)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        context?.setObject(unsafeBitCast(deleteArticle, to: AnyObject.self), forKeyedSubscript: "closePage" as NSCopying & NSObjectProtocol)
        
        context?.exceptionHandler = {(context, value)in
            HCPrint(message: value)
        }
        
        setTitle()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        HCPrint(message: error.localizedDescription)
        SVProgressHUD.dismiss()
    }
}

