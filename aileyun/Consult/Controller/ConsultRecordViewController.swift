//
//  ConsultRecordViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/13.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultRecordViewController: BaseViewController {
    
    
    let reuseIdentifier = "reuseIdentifier"
    
    let allBtn = chooseButton()
    let notPayBtn = chooseButton()
    let waitBtn = chooseButton()
    let didReplyBtn = chooseButton()
    let backBtn = chooseButton()
    
    var selectBtn = chooseButton()
    
    let indicateV = UIView()
    
    let scrollV = UIScrollView()
    lazy var currentTVC : RecordTableViewController = RecordTableViewController()
    lazy var nextTVC : RecordTableViewController = RecordTableViewController()
    
    lazy var tableVHeight : CGFloat = {
        let space = AppDelegate.shareIntance.space
        let h = SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 84
        return h
    }()
    
    
    // 2 * 20 + 5 * 4
    let width = (SCREEN_WIDTH - 60) / 5
    
    var allowChangeDirec : Bool = true
    
    var currentIndex = 0{
        didSet{
            allowChangeDirec = true
            changeView(index: currentIndex, vc: currentTVC)
        }
    }
    var nextIndex = 1{
        didSet{
            changeView(index: nextIndex, vc: nextTVC)
        }
    }
    let totalTV = 4
    

    //缓存的数据
    var dataArr = [ConsultArrModel]()
    
    //对应的状态字符
    let strArr : [String] = ["", "-1", "0", "1,2", "3,4"]
    
    var direction : Direction = .DirectionNone {
        didSet {
            guard allowChangeDirec == true else{return}
            if direction == .DirectionLeft{
                nextIndex = currentIndex - 1
                nextTVC.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(nextIndex), y: 0, width: SCREEN_WIDTH, height: tableVHeight)
            }
            if direction == .DirectionRight{
                nextIndex = currentIndex + 1
                nextTVC.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(nextIndex), y: 0, width: SCREEN_WIDTH, height: tableVHeight)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "咨询记录"
        
        //加载进入内存
        DispatchQueue.global().async {
            SharePlayer.shareIntance.audioPlayer.isPlaying
        }
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "返回灰"), style: .plain, target: self, action: #selector(ConsultRecordViewController.popToRootVC))
        self.navigationItem.leftBarButtonItem = leftItem
        
        //展示图片后，清空delegate
        self.navigationController?.delegate = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    func popToRootVC(){
        HttpClient.shareIntance.cancelAllRequest()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //为什么会变成828？
    override func viewDidAppear(_ animated: Bool) {
        HCPrint(message: currentTVC.view.frame.size.width)
        pauseScroll()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if SharePlayer.shareIntance.audioPlayer.isPlaying {
            SharePlayer.shareIntance.audioPlayer.stop()
        }
    }
    
    func initUI(){
        let space = AppDelegate.shareIntance.space
            
        let contV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: 40))
        contV.backgroundColor = UIColor.white
        self.view.addSubview(contV)
        
        allBtn.setTitle("全部", for: .normal)
        allBtn.isSelected = true
        allBtn.tag = 0
        allBtn.addTarget(self, action: #selector(ConsultRecordViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        contV.addSubview(allBtn)
        allBtn.frame = CGRect.init(x: 20, y: 0, width: width, height: 40)
        
        notPayBtn.setTitle("未支付", for: .normal)
        notPayBtn.tag = 1
        notPayBtn.addTarget(self, action: #selector(ConsultRecordViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        contV.addSubview(notPayBtn)
        notPayBtn.frame = CGRect.init(x: 25 + width, y: 0, width: width, height: 40)
        
        waitBtn.setTitle("待回复", for: .normal)
        waitBtn.tag = 2
        waitBtn.addTarget(self, action: #selector(ConsultRecordViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        contV.addSubview(waitBtn)
        waitBtn.frame = CGRect.init(x: 30 + width * 2, y: 0, width: width, height: 40)
        
        didReplyBtn.setTitle("已回复", for: .normal)
        didReplyBtn.tag = 3
        didReplyBtn.addTarget(self, action: #selector(ConsultRecordViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        contV.addSubview(didReplyBtn)
        didReplyBtn.frame = CGRect.init(x: 35 + width * 3, y: 0, width: width, height: 40)
        
        backBtn.setTitle("已退回", for: .normal)
        backBtn.tag = 4
        backBtn.addTarget(self, action: #selector(ConsultRecordViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        contV.addSubview(backBtn)
        backBtn.frame = CGRect.init(x: 40 + width * 4, y: 0, width: width, height: 40)
        
        selectBtn = allBtn
        
        indicateV.backgroundColor = kDefaultThemeColor
        contV.addSubview(indicateV)
        indicateV.snp.updateConstraints { (make) in
            make.bottom.equalTo(didReplyBtn)
            make.width.equalTo(didReplyBtn)
            make.height.equalTo(2)
            make.left.equalTo(contV).offset(20)
        }
        
        let divisionV = UIView()
        divisionV.backgroundColor = kdivisionColor
        self.view.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(contV.snp.bottom)
            make.height.equalTo(1)
        }
        
        self.view.addSubview(scrollV)
        scrollV.snp.updateConstraints { (make) in
            make.top.equalTo(divisionV)
            make.left.right.equalTo(self.view)
            make.height.equalTo(tableVHeight)
        }
        scrollV.contentSize = CGSize.init(width: SCREEN_WIDTH * 5, height: 0)
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.bounces = false
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
        
        currentTVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: tableVHeight)
        nextTVC.view.frame = CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: tableVHeight)
        
        scrollV.addSubview(nextTVC.view)
        nextTVC.status = "-1"
        nextTVC.saveDataBlock = {[weak self](model)in
            if (self?.dataArr.count)! > 0 {
                for (i, m) in (self?.dataArr.enumerated())!{
                    if m.status == model.status {
                        self?.dataArr.remove(at: i)
                    }
                }
            }
            self?.dataArr.append(model)
        }
        
        scrollV.addSubview(currentTVC.view)
        currentTVC.status = ""
        currentTVC.clickBlock = {[weak self](vc)in
            self?.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        currentTVC.saveDataBlock = {[weak self](model)in
            if (self?.dataArr.count)! > 0 {
                for (i, m) in (self?.dataArr.enumerated())!{
                    if m.status == model.status {
                        self?.dataArr.remove(at: i)
                    }
                }
            }
            self?.dataArr.append(model)
        }
        currentTVC.convertPointBlock = {[weak self](p)in
            return (self?.currentTVC.view.convert(p, to: self?.view))!
        }
        currentTVC.parentVC = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func chooseCategory(btn : chooseButton){
        modifyBtn(btn: btn)
        
        scrollV.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * CGFloat(btn.tag), y: 0), animated: true)
    }
    
    func modifyBtn(btn : chooseButton){
        if btn != selectBtn{
            selectBtn.isSelected = false
            
            let i = CGFloat(btn.tag - selectBtn.tag)
            
            btn.isSelected = true
            selectBtn = btn
            
            var tempFrame = indicateV.frame
            tempFrame.origin.x = tempFrame.origin.x + CGFloat((width + 5) * i)
            UIView.animate(withDuration: 0.25) {[weak self]()in
                self?.indicateV.frame = tempFrame
            }
        }
    }
}

extension ConsultRecordViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == scrollV else {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        if offsetX < 0 || offsetX > SCREEN_WIDTH * 4{
            return
        }
        
        let preDirect = direction
        
        if currentIndex == 0 {
            direction = .DirectionRight
        }else if currentIndex == 1{
            if offsetX < SCREEN_WIDTH{
                direction = .DirectionLeft
            }else{
                direction = .DirectionRight
            }
        }else if currentIndex == 2{
            if offsetX < SCREEN_WIDTH * 2{
                direction = .DirectionLeft
            }else{
                direction = .DirectionRight
            }
        }else if currentIndex == 3{
            if offsetX < SCREEN_WIDTH * 3{
                direction = .DirectionLeft
            }else{
                direction = .DirectionRight
            }
        }else if currentIndex == 4{
            direction = .DirectionLeft
        }
        
        // 方向不变则不能修改
        // currentIndex改变后才能修改
        // 方向改变则允许修改
        if preDirect != direction {
            allowChangeDirec = true
        }else{
            allowChangeDirec = false
        }
        
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == scrollV else {
            return
        }
        pauseScroll()
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        guard scrollView == scrollV else {
            return
        }
        pauseScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == scrollV else {
            return
        }
        if decelerate == false {
            pauseScroll()
        }
    }
    
    func pauseScroll(){
        let offset = scrollV.contentOffset.x;
        let index = NSInteger(offset / SCREEN_WIDTH)
        
        currentTVC.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: tableVHeight)
        
        guard index != currentIndex else{return}
        
        currentIndex = index
        
        HCPrint(message: currentIndex)
        
    }
    
    func changeView(index : NSInteger, vc : RecordTableViewController){
        // 改变btn的属性
        if vc == currentTVC {
            if index == 0{
                modifyBtn(btn: allBtn)
            }else if index == 1 {
                modifyBtn(btn: notPayBtn)
            }else if index == 2 {
                modifyBtn(btn: waitBtn)
            }else if index == 3 {
                modifyBtn(btn: didReplyBtn)
            }else if index == 4 {
                modifyBtn(btn: backBtn)
            }
        }
        
        setDataFor(vc: vc, status: strArr[index])
    }
    
    
    func setDataFor(vc : RecordTableViewController, status : String){
        let model = findData(status: status)
        if model != nil {
            vc.dataModel = model
        }else{
            vc.status = status
        }

    }
    
    func findData(status : String)->ConsultArrModel?{
        for m in dataArr{
            if m.status == status{
                return m
            }
        }
        return nil
    }
}


