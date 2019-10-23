//
//  ConsultViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class ConsultViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 92))
        self.view.addSubview(t)
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        return t
    }()

    let reuseIdentifier = "reuseIdentifier"

    var doctorArr : [DoctorModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
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
        
        self.tableView.register(ConsultViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 44, right: 0)
        
        let footV = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ConsultViewController.requestData))
        tableView.mj_footer = footV
        
        requestData()
    }

    func setupNavibar(){
        let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: 30))
        
        let searchBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 120, height: 30))
        searchBtn.setImage(UIImage.init(named: "搜索灰"), for: UIControlState.normal)
        searchBtn.setTitle("搜索医生", for: UIControlState.normal)
        searchBtn.setTitleColor(kLightTextColor, for: UIControlState.normal)
        searchBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        searchBtn.layer.cornerRadius = 15
        searchBtn.layer.borderColor = kLightTextColor.cgColor
        searchBtn.layer.borderWidth = 1
        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        searchBtn.addTarget(self, action: #selector(ConsultViewController.searchVC), for: .touchUpInside)
        
        contV.addSubview(searchBtn)

        let rightBtn = UIButton.init(frame: CGRect.init(x: SCREEN_WIDTH - 100, y: 0, width: 60, height: 30))
        rightBtn.setTitle("咨询记录", for: .normal)
        rightBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        rightBtn.setTitleColor(kLightTextColor, for: .normal)
        rightBtn.addTarget(self, action: #selector(ConsultViewController.consultRecord), for: .touchUpInside)
        
        contV.addSubview(rightBtn)
        
        self.navigationItem.titleView = contV
    }
    
    func searchVC(){
        self.navigationController?.pushViewController(SearchDocViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func requestData(){
        guard hasNext == true else{
            self.tableView.mj_footer.endRefreshing()
            HCShowError(info: "没有更多信息")
            return
        }
        
        self.tableView.mj_footer.endRefreshing()
        
        SVProgressHUD.show()
        
        //固定
        let hosId = 17  //中一
//        let hosId = 19   //鼓楼
        
//        var hosId = UserManager.shareIntance.HCUser?.hospitalId?.intValue
        
//        if hosId == 0 {
//            hosId = nil
//        }
        
        HttpRequestManager.shareIntance.HC_doctorList(hospitalId: hosId, pageNum: String.init(format: "%d", currentPage), callback: { [weak self](success, hasNext, arr, msg) in
            if success == true{
                if let doctorArr = self?.doctorArr {
                    let tempArr = doctorArr + arr!
                    self?.doctorArr = tempArr
                }else{
                    self?.doctorArr = arr
                }
                self?.hasNext = hasNext
                if hasNext {
                    self?.currentPage += 1
                    SVProgressHUD.dismiss()
                }else{
                    HCShowInfo(info: "数据已全部加载")
                }
            }else{
                HCShowError(info: msg)
            }
        })
    }


    func consultRecord(){
        self.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorArr?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConsultViewCell
        cell.model = doctorArr?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DoctorIntroductionController()
        vc.docModel = doctorArr?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

