//
//  UserInfoViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        t.backgroundColor = klightGrayColor
        t.dataSource = self
        t.delegate = self
        t.isScrollEnabled = false
        t.tableFooterView = UIView()
        self.view.addSubview(t)
        return t
    }()
    
    let titleArr : [String] = ["头像", "昵称", "性别", "生日", "个性签名"]
    
    var userInfoM : HCUserInfoModel?{
        didSet{
            tableV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人资料"
        
        userInfoM = UserManager.shareIntance.HCUserInfo
        
        tableV.register(UserInfoTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserInfoViewController.setUserInfo), name: NSNotification.Name.init(UPDATE_USER_INFO), object: nil)
    }
    
    func setUserInfo(){
        userInfoM = UserManager.shareIntance.HCUserInfo
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UserInfoViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserInfoTableViewCell
        cell.titleL.text = titleArr[indexPath.row]
        
        let row = indexPath.row
        if row == 0 {
            if let imgS = userInfoM?.imgUrl{
                cell.headImgV.HC_setImageFromURL(urlS: imgS, placeHolder: "默认头像")
            }else{
                cell.headImgV.image = UIImage.init(named: "默认头像")
            }
        }else if row == 1{
            cell.contentL.text = userInfoM?.nickname
        }else if row == 2{
            if userInfoM?.sex?.intValue == 1 {
                cell.contentL.text = "男"
            }else{
                cell.contentL.text = "女"
            }
        }else if row == 3{
            cell.contentL.text = userInfoM?.birthday
        }else if row == 4{
            cell.contentL.text = userInfoM?.userSign
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let editVC = EditTextViewController()
        if row == 0 {
            editVC.modifyType = ModifyItemName.HeadImg
        }else if row == 1{
            editVC.modifyType = ModifyItemName.Nickname
        }else if row == 2{
            editVC.modifyType = ModifyItemName.Sex
        }else if row == 3{
            editVC.modifyType = ModifyItemName.Birthday
        }else if row == 4{
            editVC.modifyType = ModifyItemName.Sign
        }
        self.navigationController?.pushViewController(editVC, animated: true)
        
        
    }
}
