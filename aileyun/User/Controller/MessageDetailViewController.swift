//
//  MessageDetailViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class MessageDetailViewController: BaseViewController {
    
    var type : NSInteger?{
        didSet{
            requestData()
        }
    }
    
    var hasNext = true
    
    var pageNum : NSInteger = 1

    let reuseIdentifier = "reuseIdentifier"
    
    let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        t.backgroundColor = klightGrayColor
        t.dataSource = self
        t.delegate = self
        t.tableFooterView = UIView()
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 80
        self.view.addSubview(t)
        return t
    }()

    let selectAllBtn = UIButton.init(frame: CGRect.init(x: 20, y: 4, width: 100, height: 40))
    let deleteBtn = UIButton.init(frame: CGRect.init(x: SCREEN_WIDTH - 120, y: 4, width: 100, height: 40))
    
    lazy var editV : UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 48))
        v.backgroundColor = UIColor.white
        self.view.addSubview(v)
        return v
    }()
    
    var messageArr = [MessageDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "消息"
        
        rightBtn.setTitle("编辑", for: .normal)
        rightBtn.setTitle("完成", for: .selected)
        rightBtn.setTitleColor(kTextColor, for: .normal)
        rightBtn.setTitleColor(kDefaultBlueColor, for: .selected)
        rightBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        rightBtn.addTarget(self, action: #selector(MessageDetailViewController.editAction), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        tableV.register(MessageTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableV.allowsMultipleSelectionDuringEditing = true
        
        let footV = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MessageDetailViewController.requestData))
        tableV.mj_footer = footV
        
        selectAllBtn.setTitle("全选", for: .normal)
        selectAllBtn.setTitleColor(kTextColor, for: .normal)
        selectAllBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        editV.addSubview(selectAllBtn)
        
        selectAllBtn.addTarget(self, action: #selector(MessageDetailViewController.selectAllAction), for: .touchUpInside)
        
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(kDefaultThemeColor, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        editV.addSubview(deleteBtn)
        
        deleteBtn.addTarget(self, action: #selector(MessageDetailViewController.deleteAction), for: .touchUpInside)
    }
    
    @objc func selectAllAction(){
        let count = messageArr.count
        for i in 0..<count{
            let index = IndexPath.init(row: i, section: 0)
            tableV.selectRow(at: index, animated: true, scrollPosition: .bottom)
        }
    }
    
    @objc func deleteAction(){
        let selecteRows = tableV.indexPathsForSelectedRows
        guard selecteRows != nil else {
            HCShowError(info: "请选择需要删除的消息")
            return
        }
        
        var idsArr = [String]()
        if let indexArr = selecteRows {
            for i in indexArr{
                idsArr.append(String.init(format: "%d", (messageArr[i.row].id?.intValue)!))
            }
        }
        let ids = idsArr.joined(separator: ",")
        
        deleteMessage(ids: ids)
    }
    
    @objc func editAction(sender : UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            tableV.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.25, animations: { [weak self]()in
                self?.editV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 48, width: SCREEN_WIDTH, height: 48)
            })
        }else{
            tableV.setEditing(false, animated: true)
            UIView.animate(withDuration: 0.25, animations: { [weak self]()in
                self?.editV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 48)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func requestData(){
        guard type != nil else{return}
        guard hasNext == true else{
            return
        }
        
        SVProgressHUD.show()
        let To = String.init(format: "%d", (UserManager.shareIntance.HCUser?.id?.intValue)!)
        HttpRequestManager.shareIntance.HC_messageList(To: To, Type: type!, pageNum: pageNum) { [weak self](success, hasNext, arr)in
            if success == true{
                self?.pageNum += 1
                if hasNext == false {
                    self?.hasNext = hasNext
                    self?.tableV.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.tableV.mj_footer.endRefreshing()
                }
                self?.messageArr += arr!
                self?.tableV.reloadData()
            }else{
                HCShowError(info: "网络故障")
                self?.tableV.mj_footer.endRefreshing()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func deleteMessage(ids : String){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_delMsg(notifiIds: ids) {[weak self](success, msg) in
            if success == true {
                HCShowInfo(info: msg)
                self?.messageArr.removeAll()
                self?.hasNext = true
                self?.requestData()
            }else{
                HCShowError(info: msg)
            }
        }
    }
}

extension MessageDetailViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageTableViewCell
        cell.model = messageArr[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    
}
