//
//  UserTableViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserTableViewController: UIViewController {

    let reuseIdentifier = "reuseIdentifier"
    
    let titleArr : [[String]] = [["绑定机构"], ["我的消息", "我的关注", "我的论坛"], ["设置", "软件分享", "用户反馈"]]
    
    var feedbackURL : String?
    
    lazy var tableView : UITableView = {
        let space = AppDelegate.shareIntance.space
        let tv =  UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 48))
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.bounces = false
        self.view.addSubview(tv)
        return tv
    }()
    
    lazy var tableHeadV : UserHeadView = {
        let t = UserHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 180))
        t.userInfoM = UserManager.shareIntance.HCUserInfo
        return t
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kDefaultThemeColor
        
        self.navigationItem.title = ""
        
        tableView.tableHeaderView = tableHeadV
        tableHeadV.naviVC = self.navigationController
        
        tableView.backgroundColor = klightGrayColor
        tableView.tableFooterView = UIView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
        tableView.contentInset = UIEdgeInsets.init(top: -44, left: 0, bottom: 0, right: 0)
        
        initFooterView()
        
        requestData()   
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserTableViewController.setUserInfo), name: NSNotification.Name.init(UPDATE_USER_INFO), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUserInfo(){
        tableHeadV.userInfoM = UserManager.shareIntance.HCUserInfo
    }
    
    func initFooterView(){
        let footContainerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        
        self.tableView.tableFooterView = footContainerV
        
        let logoutBtn = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: 44))
        logoutBtn.backgroundColor = UIColor.white
        logoutBtn.setTitle("退出登录", for: UIControlState.normal)
        logoutBtn.setTitleColor(kDefaultThemeColor, for: .normal)
        logoutBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize)
        
        logoutBtn.addTarget(self, action: #selector(UserTableViewController.logout), for: UIControlEvents.touchUpInside)
        footContainerV.addSubview(logoutBtn)
        
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as! String
        
        let versionL = UILabel()
        versionL.text = "当前版本号：" + currentVersion
        versionL.textColor = UIColor.lightGray
        versionL.font = UIFont.init(name: kReguleFont, size: 12)
        versionL.sizeToFit()
        footContainerV.addSubview(versionL)
        versionL.snp.updateConstraints { (make) in
            make.centerX.equalTo(footContainerV)
            make.bottom.equalTo(footContainerV).offset(-10)
        }
    }
    
    func logout(){
        let alertController = UIAlertController(title: "提醒",
                                                message: "退出登录会清空个人信息", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "确定退出", style: .cancel) { (action) in
            UserManager.shareIntance.logout()
        }
        let okAction = UIAlertAction(title: "取消", style: .default, handler: {(action)->() in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func requestData(){
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "DOCTOR_ADVICE_URL_2017") { [weak self](success, info) in
            if success == true {
                self?.tableHeadV.doctorAdvice = info
            }else{
                HCShowError(info: info)
            }
        }
        
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "PATIENT_FEEDBACK") { [weak self](success, info) in
            if success == true {
                self?.feedbackURL = info
            }else{
                HCShowError(info: info)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UserTableViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.titleL.text = titleArr[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            if UserManager.shareIntance.BindedModel != nil {
                let bindedVC = BindedViewController()
                bindedVC.bindedM = UserManager.shareIntance.BindedModel
                self.navigationController?.pushViewController(bindedVC, animated: true)
            }else{
                SVProgressHUD.show()
                HttpRequestManager.shareIntance.HC_checkHospitalBind(patientId: (UserManager.shareIntance.HCUser!.id?.intValue)!) {[weak self](success, model) in
                    if success == true {
                        SVProgressHUD.dismiss()
                        let bindedVC = BindedViewController()
                        bindedVC.bindedM = model
                        self?.navigationController?.pushViewController(bindedVC, animated: true)
                    }else{
                        HCShowInfo(info: "还未绑定生殖中心")
                        self?.navigationController?.pushViewController(BindHospitalViewController(), animated: true)
                    }
                }
            }
        }else if indexPath.section == 1 && indexPath.row == 0{
            self.navigationController?.pushViewController(MessageViewController(), animated: true)
        }else if indexPath.section == 1 && indexPath.row == 1{
            self.navigationController?.pushViewController(MyDoctorViewController(), animated: true)
        }else if indexPath.section == 1 && indexPath.row == 2{
            self.navigationController?.pushViewController(MyBBSViewController(), animated: true)
        }else if indexPath.section == 2 && indexPath.row == 0{
            self.navigationController?.pushViewController(SettingViewController(), animated: true)
        }else if indexPath.section == 2 && indexPath.row == 1{
            self.navigationController?.pushViewController(ShowShareViewController(), animated: true)
        }else if indexPath.section == 2 && indexPath.row == 2{
            if let url = feedbackURL {
                let webVC = WebViewController()
                webVC.url = url
                self.navigationController?.pushViewController(webVC, animated: true)
            }else{
                HCShowError(info: "网络出错")
            }
            
        }
    }
}
