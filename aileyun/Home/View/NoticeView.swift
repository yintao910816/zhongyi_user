//
//  NoticeView.swift
//  aileyun
//
//  Created by huchuang on 2017/12/28.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class NoticeView: UIView {

    let dicArr : [[String : Any]] = [["id" : 1, "title" : "系统消息", "content" : "各位患者：你们好，感谢您的支持，我们将竭诚为您服务"], ["id" : 2, "title" : "最新消息", "content" : "各位患者你们好，感谢您的信任，愿你早日实现求子梦想"]]
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let t = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: 50))
        t.isUserInteractionEnabled = false
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    var modelArr : [NoticeHomeVModel]?{
        didSet{
            tableV.reloadData()
            timer?.invalidate()
            row = 0
            startShow()
        }
    }
    
    lazy var contentT : UILabel = {
        let c = UILabel()
        c.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        c.textColor = kTextColor
        return c
    }()
    
    var timer : Timer?
    
    var row = 0 {
        didSet{
            if row >= (modelArr?.count)! {
                row = 0
            }
            contentT.text = modelArr![row].title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        initUI()
        
        defaultData()
        
        tableV.register(NotiveViewTVCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func defaultData(){
        var modelA = [NoticeHomeVModel]()
        for d in dicArr {
            let m = NoticeHomeVModel.init(d)
            modelA.append(m)
        }
        modelArr = modelA
    }
    
    func startShow(){
        guard (modelArr?.count)! > 1 else{return}
        row = 1
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self](t) in
                self?.row = (self?.row)! + 1
                let indexP = IndexPath.init(row: (self?.row)!, section: 0)
                self?.tableV.scrollToRow(at: indexP, at: .top, animated: true)
            })
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        } else {
        }
    }
    
    func initUI(){
        let imgV = UIImageView.init(frame: CGRect.init(x: 20, y: 10, width: 20, height: 20))
        imgV.image = UIImage.init(named: "noticeNew")
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imgV)
        
        let titleL = UILabel()
        titleL.text = "通知提醒"
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        titleL.textColor = kTextColor
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(5)
            make.centerY.equalTo(imgV)
        }
        
        let div = UIView()
        div.backgroundColor = kdivisionColor
        self.addSubview(div)
        div.snp.updateConstraints { (make) in
            make.left.equalTo(titleL.snp.right).offset(5)
            make.centerY.equalTo(imgV)
            make.width.equalTo(2)
            make.height.equalTo(15)
        }
        
        let rightV = UIImageView()
        rightV.image = UIImage.init(named: "箭头")
        rightV.contentMode = UIViewContentMode.right
        self.addSubview(rightV)
        rightV.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(imgV)
            make.width.height.equalTo(20)
        }
        
        let moreL = UILabel()
        moreL.text = "更多"
        moreL.font = UIFont.init(name: kReguleFont, size: 13)
        moreL.textColor = kDefaultBlueColor
        moreL.textAlignment = NSTextAlignment.right
        self.addSubview(moreL)
        moreL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.right.equalTo(rightV.snp.left)
            make.width.equalTo(30)
        }
        
        self.addSubview(contentT)
        contentT.snp.updateConstraints { (make) in
            make.left.equalTo(div.snp.right).offset(5)
            make.width.equalTo(120)
            make.centerY.equalTo(imgV)
        }
        
        let divisionV = UIView()
        divisionV.backgroundColor = kdivisionColor
        self.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(imgV.snp.bottom).offset(9)
            make.height.equalTo(1)
        }
        
        let contV = UIView.init(frame: CGRect.init(x: 20, y: 40, width: SCREEN_WIDTH - 40, height: 50))
        contV.addSubview(tableV)
        
        self.addSubview(contV)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension NoticeView : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotiveViewTVCell
        cell.model = modelArr?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

