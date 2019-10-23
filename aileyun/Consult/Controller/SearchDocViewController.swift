//
//  SearchDocViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/29.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class SearchDocViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    lazy var tableView : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return t
    }()
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var searchB : UISearchBar = {
        let s = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 100, height: 30))
        s.placeholder = "搜索医生"
        s.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        s.delegate = self
        //改变提示文字大小
        let textf = s.value(forKey: "searchField") as? UITextField //首先取出textfield
        let textl = textf?.value(forKey: "placeholderLabel") as? UILabel //然后取出textField的placeHolder
        textl?.font = UIFont.init(name: kReguleFont, size: 14)
        return s
    }()

    var searchResult : [DoctorModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    var currentPage = 1
    var hasNext = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavibar()
        
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(ConsultViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let footV = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SearchDocViewController.searchTheName))
        tableView.mj_footer = footV
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchB.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchB.resignFirstResponder()
    }
    
    func setupNavibar(){
        let containV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 100, height: 30))
        containV.layer.cornerRadius = 15
        containV.layer.borderWidth = 1
        containV.layer.borderColor = kLightTextColor.cgColor
        containV.addSubview(searchB)
        self.navigationController?.navigationBar.autoresizesSubviews = false
        self.navigationItem.titleView = containV
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConsultViewCell
        cell.model = searchResult?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DoctorIntroductionController()
        vc.docModel = searchResult?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchDocViewController : UISearchBarDelegate {
    
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchB.text != "" && searchB.text != nil else{
            HCShowError(info: "请输入医生名字")
            return
        }
        
        //每次搜索还原数据
        searchResult = nil
        hasNext = true
        currentPage = 1
        
        searchB.resignFirstResponder()
        searchTheName()
    }
    
    func searchTheName(){
        guard hasNext == true else{
            HCShowError(info: "已加载全部信息")
            return
        }
        
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_findDoctorFromName(docName: searchB.text!, pageNum: String.init(format: "%d", currentPage)) { (success, hasNext, arr, msg) in
            if success == true {
                if (arr?.count)! > 0 {
                    if let result = self.searchResult{
                        let total = result + arr!
                        self.searchResult = total
                    }else{
                        self.searchResult = arr
                    }
                    self.currentPage += 1
                    self.hasNext = hasNext
                    SVProgressHUD.dismiss()
                }else{
                    HCShowError(info: "搜索不到相关信息")
                }
            }else{
                HCShowError(info: msg)
            }
        }
    }
}
