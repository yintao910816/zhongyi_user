//
//  HospitalListViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/2.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class HospitalListViewController: UIViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    
    var chooseBlock : ((HospitalListModel)->())?
    
    lazy var searchBarV : UIView = {
        let s = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        return s
    }()
    
    lazy var searchB : UISearchBar = {
        let s = UISearchBar.init(frame: CGRect.init(x: 2, y: 2, width: SCREEN_WIDTH, height: 40))
        s.layer.cornerRadius = 20
        s.layer.borderWidth = 1
        s.layer.borderColor = kdivisionColor.cgColor
        s.placeholder = "搜索生殖中心"
        s.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        s.delegate = self
        return s
    }()
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - 44))
        t.dataSource = self
        t.delegate = self
        t.tableFooterView = UIView()
        return t
    }()
    
    var isSearch : Bool = false {
        didSet{
            tableV.reloadData()
        }
    }
    
    var searchResultArr = [HospitalListModel]()
    
    var hospitalArr : [HospitalListModel]?{
        didSet{
            tableV.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "生殖中心列表"
        self.view.backgroundColor = kDefaultThemeColor
        
        tableV.register(HospitalListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        searchBarV.addSubview(searchB)
        tableV.tableHeaderView = searchBarV
        
        self.view.addSubview(tableV)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension HospitalListViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == false{
            return hospitalArr?.count ?? 0
        }else{
            return searchResultArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HospitalListTableViewCell
        if isSearch == false{
            cell.model = hospitalArr?[indexPath.row]
        }else{
            cell.model = searchResultArr[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chooseBlock = chooseBlock {
            if isSearch == false{
                chooseBlock((hospitalArr?[indexPath.row])!)
            }else{
                chooseBlock(searchResultArr[indexPath.row])
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension HospitalListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.characters.count)! > 0{
            searchBar.setShowsCancelButton(true, animated: true)
            let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
            uiButton.setTitle("取消", for: .normal)
        }else{
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        HCPrint(message: "searchBarTextDidEndEditing")
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        HCPrint(message: "searchBarBookmarkButtonClicked")
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        HCPrint(message: "searchBarResultsListButtonClicked")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        isSearch = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchB.text != "" && searchB.text != nil else{
            HCShowError(info: "请输入名称")
            return
        }
        
        //每次搜索还原数据
        searchResultArr.removeAll()
        
        searchB.resignFirstResponder()
        
        searchTheName()
    }
    
    func searchTheName(){
        let searchPredicate = NSPredicate.init(format: "self.name contains[cd] %@", searchB.text!)
        if hospitalArr != nil {
            let tempArray = hospitalArr as! NSArray
            searchResultArr = tempArray.filtered(using: searchPredicate) as! [HospitalListModel]
            //刷新表格
            isSearch = true
        }
    }
}

