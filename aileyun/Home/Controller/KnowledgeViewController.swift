//
//  KnowledgeViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class KnowledgeViewController: UIViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    
    let knowledgeIV = UIImageView()
    
    let recommendBtn = chooseButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 40))
    let lifeBtn = chooseButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 40))
    let nutritionBtn = chooseButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 40))
    let sexBtn = chooseButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 40))
    
    let buttonWidth = (SCREEN_WIDTH - 130) / 4
    
    var selectBtn = chooseButton()
    
    let indicateV = UIView()
    
    let scrollV = UIScrollView()
    let currentTV = UITableView()
    let nextTV = UITableView()
    
    var currentIndex : NSInteger = 0 {
        didSet{
            if currentIndex != oldValue{
                if currentIndex == 0{
                    chooseCategory(btn: recommendBtn)
                }else if currentIndex == 1 {
                    chooseCategory(btn: lifeBtn)
                }else if currentIndex == 2 {
                    chooseCategory(btn: nutritionBtn)
                }else if currentIndex == 3 {
                    chooseCategory(btn: sexBtn)
                }
                currentTV.reloadData()
            }
        }
    }
    var nextIndex = 1 {
        didSet{
            nextTV.reloadData()
        }
    }
    let totalTV = 4
    
    var modelArr : [KnowledgeListModel]? {
        didSet{
            initUI()
            currentTV.reloadData()
            nextTV.reloadData()
        }
    }
    
    weak var naviVC : UINavigationController?
    
    var direction : Direction = .DirectionNone {
        didSet {
            if direction == .DirectionLeft{
                nextIndex = currentIndex - 1
                nextTV.frame = CGRect(x: SCREEN_WIDTH * CGFloat(nextIndex), y: 0, width: SCREEN_WIDTH, height: 500)
            }
            if direction == .DirectionRight{
                nextIndex = currentIndex + 1
                nextTV.frame = CGRect(x: SCREEN_WIDTH * CGFloat(nextIndex), y: 0, width: SCREEN_WIDTH, height: 500)
            }
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        currentTV.register(knowledgeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        currentTV.isScrollEnabled = false
        
        nextTV.register(knowledgeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        nextTV.isScrollEnabled = false
        
    }

    func initUI(){
        
        knowledgeIV.image = UIImage.init(named: "标题")
        knowledgeIV.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(knowledgeIV)
        knowledgeIV.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(20)
            make.width.height.equalTo(20)
        }
        
        let knowledgeL = UILabel()
        knowledgeL.text = "今日知识"
        knowledgeL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        knowledgeL.textColor = kTextColor
        self.view.addSubview(knowledgeL)
        knowledgeL.snp.updateConstraints { (make) in
            make.left.equalTo(knowledgeIV.snp.right)
            make.centerY.equalTo(knowledgeIV)
        }
        
        
        sexBtn.setTitle(modelArr?[3].name, for: .normal)
        sexBtn.tag = 3
        sexBtn.addTarget(self, action: #selector(KnowledgeViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        self.view.addSubview(sexBtn)
        sexBtn.snp.updateConstraints { (make) in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
            make.centerY.equalTo(knowledgeIV)
            make.right.equalTo(self.view).offset(-20)
        }
        
        nutritionBtn.setTitle(modelArr?[2].name, for: .normal)
        nutritionBtn.tag = 2
        nutritionBtn.addTarget(self, action: #selector(KnowledgeViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nutritionBtn)
        nutritionBtn.snp.updateConstraints { (make) in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
            make.centerY.equalTo(sexBtn)
            make.right.equalTo(sexBtn.snp.left)
        }
        
        lifeBtn.setTitle(modelArr?[1].name, for: .normal)
        lifeBtn.tag = 1
        lifeBtn.addTarget(self, action: #selector(KnowledgeViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        self.view.addSubview(lifeBtn)
        lifeBtn.snp.updateConstraints { (make) in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
            make.centerY.equalTo(sexBtn)
            make.right.equalTo(nutritionBtn.snp.left)
        }
        
        recommendBtn.setTitle(modelArr?[0].name, for: .normal)
        recommendBtn.tag = 0
        recommendBtn.isSelected = true
        recommendBtn.addTarget(self, action: #selector(KnowledgeViewController.chooseCategory), for: UIControlEvents.touchUpInside)
        self.view.addSubview(recommendBtn)
        recommendBtn.snp.updateConstraints { (make) in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(20)
            make.centerY.equalTo(sexBtn)
            make.right.equalTo(lifeBtn.snp.left)
        }
        
        selectBtn = recommendBtn
        
        indicateV.backgroundColor = kDefaultThemeColor
        indicateV.frame = CGRect.init(x: SCREEN_WIDTH - 20 - buttonWidth * 4, y: recommendBtn.frame.maxY + 5, width: buttonWidth, height: 3)
        self.view.addSubview(indicateV)
        
        let divisionV = UIView()
        divisionV.backgroundColor = kdivisionColor
        self.view.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(indicateV.snp.bottom)
            make.height.equalTo(1)
        }
        
        
        self.view.addSubview(scrollV)
        scrollV.snp.updateConstraints { (make) in
            make.top.equalTo(knowledgeIV.snp.bottom).offset(10)
            make.left.right.equalTo(self.view)
            make.height.equalTo(500)
        }
        scrollV.contentSize = CGSize.init(width: SCREEN_WIDTH * 4, height: 0)
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
        
        scrollV.addSubview(nextTV)
        nextTV.dataSource = self
        nextTV.delegate = self
        nextTV.frame = CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: 500)
        
        scrollV.addSubview(currentTV)
        currentTV.dataSource = self
        currentTV.delegate = self
        currentTV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 500)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func chooseCategory(btn : chooseButton, fromIndex : Bool = false){
        selectBtn.isSelected = false
        
        let i = btn.tag - selectBtn.tag
        
        btn.isSelected = true
        
        selectBtn = btn
    
        var tempFrame = indicateV.frame
        tempFrame.origin.x = tempFrame.origin.x + buttonWidth * CGFloat(i)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.indicateV.frame = tempFrame
        }
        
        scrollV.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * CGFloat(btn.tag), y: 0), animated: true)
        
    }

}

extension KnowledgeViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! knowledgeTableViewCell
        
        if tableView == currentTV {
            cell.model = modelArr?[currentIndex].detailList?[indexPath.row] as! KnowledgeModel
        }else{
            cell.model = modelArr?[nextIndex].detailList?[indexPath.row] as! KnowledgeModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = WebViewController()
        var url : String?
        if tableView == currentTV {
            url = (modelArr?[currentIndex].detailList?[indexPath.row] as! KnowledgeModel).PAGE_URL
        }else{
            url = (modelArr?[nextIndex].detailList?[indexPath.row] as! KnowledgeModel).PAGE_URL
        }
        webVC.url = url
        naviVC?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension KnowledgeViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if offsetX < 0 || offsetX > SCREEN_WIDTH * 3{
            return
        }
        
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
            direction = .DirectionLeft
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pauseScroll()
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        pauseScroll()
    }
    
    func pauseScroll(){
        let offset = scrollV.contentOffset.x;
        let index = offset / SCREEN_WIDTH
        
        currentIndex = NSInteger(index)
        
        currentTV.frame = CGRect(x: SCREEN_WIDTH * CGFloat(currentIndex), y: 0, width: SCREEN_WIDTH, height: 500)

    }

}
