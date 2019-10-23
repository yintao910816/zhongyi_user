//
//  GoodNewsView.swift
//  aileyun
//
//  Created by huchuang on 2017/10/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class GoodNewsView: UIView {
    
    let dicArr : [[String : Any]] = [["name" : "****8558", "deliver" : "2017-11-11", "type" : "pregnant"], ["name" : "****0508", "deliver" : "2017-11-10", "type" : "childbirth"], ["name" : "****2653", "deliver" : "2017-11-10", "type" : "pregnant"]]
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let t = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 140, height: 50))
        t.isUserInteractionEnabled = false
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    var modelArr : [GoodNewsModel]?{
        didSet{
            tableV.reloadData()
            timer?.invalidate()
            startShow()
        }
    }
    
    var timer : Timer?
    
    var row = 1 {
        didSet{
            if row >= (modelArr?.count)! {
                row = 0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        initUI()
        
        defaultData()
        
        tableV.register(GoodNewsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func defaultData(){
        var modelA = [GoodNewsModel]()
        let dateS = Date.init().converteYYYYMMdd()
        for var d in dicArr {
            d["deliver"] = dateS
            let m = GoodNewsModel.init(d)
            modelA.append(m)
        }
        modelArr = modelA
    }
    
    func startShow(){
        guard (modelArr?.count)! > 1 else{return}
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self](t) in
                let indexP = IndexPath.init(row: (self?.row)!, section: 0)
                self?.tableV.scrollToRow(at: indexP, at: .top, animated: true)
                self?.row = (self?.row)! + 1
            })
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        } else {
        }
    }
    
    func initUI(){
        let imgV = UIImageView.init(frame: CGRect.init(x: 20, y: 10, width: 20, height: 20))
        imgV.image = UIImage.init(named: "标题")
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imgV)
        
        let titleL = UILabel()
        titleL.text = "喜报"
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        titleL.textColor = kTextColor
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(10)
            make.centerY.equalTo(imgV)
        }
        
        let babyV = UIImageView.init(frame: CGRect.init(x: SCREEN_WIDTH - 110, y: 10, width: 100, height: 80))
        babyV.image = UIImage.init(named: "goodnewsBaby")
        babyV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(babyV)
        
        let contV = UIView.init(frame: CGRect.init(x: 20, y: 40, width: SCREEN_WIDTH - 140, height: 50))
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

extension GoodNewsView : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GoodNewsTableViewCell
        cell.model = modelArr?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
