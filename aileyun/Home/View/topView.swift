//
//  HomeBannerView.swift
//  TestSwift
//
//  Created by heming on 16/7/26.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

import Foundation
import UIKit

enum Direction{
    case DirectionLeft    //向左滑
    case DirectionRight   //向右滑
    case DirectionNone    //未滑动
}

class topView: UIView,UIScrollViewDelegate{
    
    var autoScrollTimeInterval:TimeInterval?               //自动滚动时间间隔
    var scrollView            :UIScrollView?               //滚动视图
    var imgWidth              :CGFloat?                    //图片宽度
    var imgHeight             :CGFloat?                    //图片高度
    var pageControl           :UIPageControl?              //分页控制器
    var currentView           :imageButton?                //当前视图
    var nextView              :imageButton?                //下一视图
    var currentIndex          :NSInteger?                  //当前索引
    var nextIndex             :NSInteger?                  //下一索引
    var timer                 :Timer?                      //定时器
    var ADsArray              :[String]? {
        didSet{
            if let arr = ADsArray {
                currentView?.imgV.HC_setImageFromURL(urlS: arr[0], placeHolder: "guanggao")
                pageControl?.numberOfPages = arr.count
            }
        }
    }                 //图片数组
    
    var dataArr : [HomeBannerModel]?{
        didSet{
            if let dataArr = dataArr{
                var arr = [String]()
                for model in dataArr{
                    if let s = model.path{
                        arr.append(s)
                    }
                }
                if arr.count > 0{
                    ADsArray = arr
                    self.startTimer()
                }
            }
        }
    }
    
    weak var naviCtl : UINavigationController?
    
    var direction : Direction = .DirectionNone {  //滚动方向
        //设置新值之前
        willSet {
            if newValue == direction {
                return
            }
        }
        //设置新值之后
        didSet {
            //向右滚动
            if direction == .DirectionRight{
                if nextView?.frame != CGRect(x: 0, y: 0, width: imgWidth!, height: imgHeight!){
                    nextView?.frame = CGRect(x: 0, y: 0, width: imgWidth!, height: imgHeight!)
                    nextIndex = currentIndex! - 1
                    if nextIndex! < 0
                    {
                        nextIndex = (ADsArray?.count)! - 1
                    }
                    nextView?.imgV.HC_setImageFromURL(urlS: (ADsArray?[nextIndex!])!, placeHolder: "guanggao")
                }
            }
            //向左滚动
            if direction == .DirectionLeft{
                if nextView?.frame != CGRect(x: 2*imgWidth!, y: 0, width: imgWidth!, height: imgHeight!){
                    nextView?.frame = CGRect(x: 2*imgWidth!, y: 0, width: imgWidth!, height: imgHeight!)
                    nextIndex = (currentIndex! + 1) % (ADsArray?.count)!
                    nextView?.imgV.HC_setImageFromURL(urlS: (ADsArray?[nextIndex!])!, placeHolder: "guanggao")
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        imgWidth  = frame.size.width
        imgHeight = frame.size.height
        
        scrollView = UIScrollView(frame: frame)
        scrollView?.delegate = self
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.contentSize = CGSize(width: 3*imgWidth!, height: imgHeight!)
        scrollView?.contentOffset = CGPoint(x: imgWidth!, y: 0)
        self.addSubview(scrollView!)
        
        currentView = imageButton(frame: CGRect(x: imgWidth!, y: 0, width: imgWidth!, height: imgHeight!))
        currentView?.tag = 0
        currentView?.addTarget(self, action: #selector(topView.click), for: UIControlEvents.touchUpInside)
        scrollView?.addSubview(currentView!)
        
        nextView = imageButton(frame: CGRect(x: 2*imgWidth!, y: 0, width: imgWidth!, height: imgHeight!))
        nextView?.tag = 1
        nextView?.addTarget(self, action: #selector(topView.click), for: UIControlEvents.touchUpInside)
        scrollView?.addSubview(nextView!)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: imgHeight!-20, width: imgWidth!, height: 20))
        pageControl?.hidesForSinglePage = false
        pageControl?.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        pageControl?.currentPageIndicatorTintColor = UIColor.red.withAlphaComponent(0.5)
        self.addSubview(pageControl!)
        
        currentIndex = 0
        nextIndex = 0
        pageControl?.currentPage = currentIndex!
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        timer?.invalidate()
    }
    
    //点击事件
    func click(sender : imageButton){
        var index = 0
        if sender.tag == 0{
            index = currentIndex!
        }else{
            index = nextIndex!
        }
        
        guard dataArr != nil else{return}
        
        let urlS = dataArr![index].url ?? ""
        if urlS.contains("http"){
            let webV = WebViewController()
            webV.url = urlS
            naviCtl?.pushViewController(webV, animated: true)
        }
        
        let id = dataArr![index].id?.intValue ?? 0
        HttpRequestManager.shareIntance.HC_clickCount(id: id) { (bool) in
            HCPrint(message: bool)
        }
    }
    
    // 开启定时器
    func startTimer(){
        self.stopTimer()
        if (ADsArray?.count)! > 1 {
            timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval!, target: self, selector: #selector(self.nextImage), userInfo: nil, repeats: true)
        }else{
            return
        }
    }
    
    // 关闭定时器
    func stopTimer(){
        if timer != nil && (timer?.isValid)!{
            timer?.invalidate()
            timer = nil
        }
    }
    
    // 滚动到下一张图片
    func nextImage(){
        scrollView?.setContentOffset(CGPoint(x: imgWidth!*2, y: 0), animated: true)
    }
    
    //MARK: -----UIScrollViewDelegate-----
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetX = scrollView.contentOffset.x;
        self.direction = offsetX > imgWidth! ? .DirectionLeft : offsetX < imgWidth! ? .DirectionRight : .DirectionNone
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        self.pauseScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        self.pauseScroll()
    }
    
    //开始拖拽时停止定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.stopTimer()
    }
    
    //拖拽结束后开启定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        self.startTimer()
    }
    
    ///停止滚动
    func pauseScroll(){
        let offset = self.scrollView!.contentOffset.x;
        let index = offset / self.imgWidth!
        //1表示没有滚动
        if index == 1{
            return
        }
        
        currentIndex = self.nextIndex
        pageControl?.currentPage = currentIndex!
        
        //交换图片
        let tempV = currentView
        currentView = nextView
        nextView = tempV
        
        scrollView?.bringSubview(toFront: currentView!)
        currentView?.frame = CGRect(x: imgWidth!, y: 0, width: imgWidth!, height: imgHeight!)
        scrollView?.contentOffset = CGPoint(x: imgWidth!, y: 0)
    }
}
