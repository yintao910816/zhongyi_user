//
//  LEDWordsView.swift
//  aileyun
//
//  Created by huchuang on 2017/10/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class LEDWordsView: UIView {
    
    weak var naviVC : UINavigationController?
    
    var modelArr : [NoticeHomeVModel]?{
        didSet{
            startScrollText()
        }
    }
    
    var showingLabel = [NoticeLabel]()

    var index = 0
    
    var waitTime : CGFloat = 0
    
    lazy var imgV : UIImageView = {
        let i = UIImageView.init(image: UIImage.init(named: "noticeNew"))
        return i
    }()
    
    lazy var labelPool : [NoticeLabel] = {
        var pool = [NoticeLabel]()
        for i in 0..<3{
            let l = NoticeLabel.init()
            l.font = UIFont.init(name: kReguleFont, size: 16)
            l.textColor = kDefaultThemeColor
            pool.append(l)
        }
        return pool
    }()
    
    lazy var delBtn : UIButton = {
        let b = UIButton.init()
        b.setImage(UIImage.init(named: "删除"), for: .normal)
        b.addTarget(self, action: #selector(LEDWordsView.removeAction), for: .touchUpInside)
        return b
    }()
    
    lazy var containerV : UIView = {
        let s = UIView.init()
        s.clipsToBounds = true
        return s
    }()
    
    let contWidth = SCREEN_WIDTH - 80
    let speed : CGFloat = 60
    
    var timer : Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 255/255.0, green: 248/255.0, blue: 220/255.0, alpha: 0.8)
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(LEDWordsView.noticeClick))
        self.addGestureRecognizer(tapG)
        
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
            make.width.equalTo(20)
        }
        
        self.addSubview(delBtn)
        delBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(25)
        }
        
        containerV.frame = CGRect.init(x: 40, y: 0, width: contWidth, height: frame.height)
        self.addSubview(containerV)
    }
    
    func startScrollText(){
        guard modelArr != nil else{
            return
        }
        timer?.invalidate()
        waitTime = 0
        clearShowingLabel()
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self](t) in
                self?.findLabelTodisplay()
            })
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        } else {
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func clearShowingLabel(){
        guard showingLabel.count > 0 else {
            return
        }
        for i in showingLabel {
            i.removeFromSuperview()
        }
    }
    
    func findLabelTodisplay(){
        guard waitTime <= 0 else{
            waitTime = waitTime - 0.1
            return
        }
        guard labelPool.count > 0 else{return}
        
        if index >= (modelArr?.count)! {
            index = 0
        }
        
        let label = labelPool[0]
        labelPool.remove(at: 0)
        showingLabel.append(label)
        
        //取内容
        let str = modelArr?[index].content
        label.noticeId = modelArr?[index].id
        
        index = index + 1
        
        label.text = str
        label.sizeToFit()
        let f = label.frame
        waitTime = (f.size.width + 30) / speed
        
        labelAnimation(l: label)
    }
    
    func labelAnimation(l : NoticeLabel){
        l.frame = CGRect.init(x: contWidth, y: 0, width: l.frame.size.width + 3, height: frame.size.height)
        
        containerV.addSubview(l)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let time = (contWidth + l.frame.size.width) / speed
        
        UIView.animate(withDuration: Double(time), delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {[weak self]()in
            l.frame = CGRect.init(x: -l.frame.size.width, y: 0, width: l.frame.size.width + 30, height: (self?.frame.size.height)!)
        }) { [weak self](b) in
            l.removeFromSuperview()
            self?.showingLabel.remove(at: 0)
            self?.labelPool.append(l)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func removeAction(){
        timer?.invalidate()
        self.removeFromSuperview()
    }
    
    func noticeClick(tap : UITapGestureRecognizer){
        let point = tap.location(in: self)
        for l in showingLabel {
            let tempFrame = l.layer.presentation()?.frame
            if (tempFrame?.contains(point))!{
                SVProgressHUD.show()
                let notIdS = String.init(format: "%d", (l.noticeId?.intValue)!)
                HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "NOTICE_DETAIL_URL", callback: { [weak self](success, urlS) in
                    SVProgressHUD.dismiss()
                    if success == true{
                        let webVC = WebViewController()
                        webVC.url = urlS + "?noticeId=" + notIdS
                        self?.naviVC?.pushViewController(webVC, animated: true)
                    }else{
                        HCShowError(info: urlS)
                    }
                })
            }
        }
    }

}
