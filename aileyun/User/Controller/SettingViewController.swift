//
//  SettingViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        t.backgroundColor = klightGrayColor
        t.dataSource = self
        t.delegate = self
        self.view.addSubview(t)
        return t
    }()
    
    let titleArr : [String] = ["修改密码", "第三方账号绑定"]
    
    var thirdArr : [String]? {
        didSet{
            tableV.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "设置"
        tableV.isScrollEnabled = false
        tableV.register(SettingTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        initUI()
        
        requestData()   
    }


    func initUI(){
        let tableHeadV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 150))
        
        let x = (SCREEN_WIDTH - 200) / 2
        let imgV = UIImageView.init(frame: CGRect.init(x: x, y: 20, width: 200, height: 100))
        imgV.image = UIImage.init(named: shareImgName)
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        tableHeadV.addSubview(imgV)
        
        tableV.tableHeaderView = tableHeadV
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestData(){
        let id = UserManager.shareIntance.HCUser?.id?.intValue
        HttpRequestManager.shareIntance.HC_checkThirdBind(patientId: id!) { [weak self](success, arr) in
            if success == true {
                self?.thirdArr = arr
            }else{
                HCShowError(info: "网络出错")
            }
        }
    }
    
}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingTableViewCell
        cell.titleL.text = titleArr[indexPath.row]
        
        if indexPath.row == 0 {
            cell.RightImgV.isHidden = false
            cell.thirdArr = nil
        }else{
            cell.RightImgV.isHidden = true
            cell.thirdArr = thirdArr
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.navigationController?.pushViewController(findViewController(), animated: true)
        }
    }
}
