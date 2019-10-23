//
//  MessageViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class MessageViewController: BaseViewController {

    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        t.backgroundColor = klightGrayColor
        t.dataSource = self
        t.delegate = self
        t.tableFooterView = UIView()
        t.separatorStyle = .none
        t.rowHeight = UITableViewAutomaticDimension
        t.estimatedRowHeight = 110
        self.view.addSubview(t)
        return t
    }()
    
    lazy var nodataIV : UIImageView = {
        let IV = UIImageView.init(frame: CGRect.init(x: 40, y: 100, width: SCREEN_WIDTH - 80, height: SCREEN_WIDTH - 80))
        IV.image = UIImage.init(named: "noData")
        IV.contentMode = UIViewContentMode.scaleAspectFit
        
        self.view.addSubview(IV)
        return IV
    }()
    
    var messageGroupArr = [messageGroupModel]() {
        didSet{
            nodataIV.isHidden = true
            tableV.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "消息中心"
        
        tableV.register(MessageGroupViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        nodataIV.isHidden = false
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.requestData), name: NSNotification.Name.init(CLEAR_MSG_STATUS), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestData(){
        SVProgressHUD.show()
        let To = String.init(format: "%d", (UserManager.shareIntance.HCUser?.id?.intValue)!)
        HttpRequestManager.shareIntance.HC_messageGroup(To: To) { [weak self](success, arr) in
            if success == true{
                if (arr?.count)! > 0 {
                    self?.messageGroupArr = arr!
                }else{
                    HCShowInfo(info: "没有信息")
                }
            }else{
                HCShowError(info: "网络故障")
            }
            SVProgressHUD.dismiss()
        }
    }
}

extension MessageViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageGroupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageGroupViewCell
        cell.model = messageGroupArr[indexPath.row]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetailVC = MessageDetailViewController()
        let t = messageGroupArr[indexPath.row].type?.intValue ?? 0
        messageDetailVC.type = t
        self.navigationController?.pushViewController(messageDetailVC, animated: true)
        
        clearStatus(type: t)
    }
    
    func clearStatus(type : NSInteger){
        HttpRequestManager.shareIntance.HC_clearMsgStatus(type: type){(b)in
            if b == true{
                let not = Notification.init(name: NSNotification.Name.init(CLEAR_MSG_STATUS), object: nil, userInfo: nil)
                NotificationCenter.default.post(not)
            }
        }
    }
}
