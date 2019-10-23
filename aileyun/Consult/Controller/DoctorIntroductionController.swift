//
//  DoctorIntroductionController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class DoctorIntroductionController: BaseViewController {
    
    var doctorId : NSInteger?{
        didSet{
            requestData()
        }
    }
    
    var docModel : DoctorModel?{
        didSet{
            if docModel?.imgUrl != nil {
                headV.HC_setImageFromURL(urlS: (docModel?.imgUrl)!, placeHolder: "默认头像")
            }
            nameL.text = docModel?.realName
            jobL.text = docModel?.doctorRole
            hospitalL.text = docModel?.hospitalName
            replyCountL.text = String.init(format: "%d", (docModel?.replyCount?.intValue)!) + "次"
            
            priceL.text = docModel?.docPrice
            
            numOfCommentL.text = "用户评价:(" + String.init(format: "%d", (docModel?.reviewNum?.intValue)!) + ")"
            
            commentStarV.numForStar = (docModel?.reviewStar?.intValue)!
            
            doctorId = docModel?.doctorId?.intValue
        }
    }
    
    var pageNo = 1
    
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 92))
        return t
    }()
    
    let doctorIntroCell = "doctorIntroCell"
    let commentCell = "commentCell"
    
    var dataArr : [CommentDocModel]?{
        didSet{
            tableV.reloadData()
        }
    }
    
    var hasNext = true
    
    let headV = UIImageView()
    let nameL = UILabel()
    let jobL = UILabel()
    let hospitalL = UILabel()
    
    let replyCountL = UILabel()
    let priceL = UILabel()
    
    let numOfCommentL = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 120, height: 30))
    let commentStarV = starView.init(frame: CGRect.init(x: 150, y: 0, width: 100, height: 30))
    
    lazy var consultBtn : UIButton = {
        let space = AppDelegate.shareIntance.space
        let b = UIButton.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - 48 - space.bottomSpace, width: SCREEN_WIDTH, height: 48))
        b.setTitle("立即咨询", for: UIControlState.normal)
        b.titleLabel?.font = UIFont.init(name: kReguleFont, size: 16)
        b.backgroundColor = kDefaultThemeColor
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "医生简介"
        tableV.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 48, right: 0)
        
        let footV = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(DoctorIntroductionController.requestData))
        tableV.mj_footer = footV
    
        initUI()
    }

    func initUI(){
        self.view.addSubview(tableV)
        tableV.dataSource = self
        tableV.delegate = self
        
        tableV.backgroundColor = kdivisionColor
        tableV.estimatedRowHeight = 100
        
        tableV.register(DoctorIntroTableViewCell.self, forCellReuseIdentifier: doctorIntroCell)
        tableV.register(DoctorCommentTVCell.self, forCellReuseIdentifier: commentCell)
        
        self.view.addSubview(consultBtn)
        consultBtn.addTarget(self, action: #selector(DoctorIntroductionController.consult), for: UIControlEvents.touchUpInside)
        
        initHeaderView()
    }
    
    func consult(){
        let vc = SubmitViewController()
        vc.docModel = docModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestData(){
        guard hasNext == true else{
            tableV.mj_footer.endRefreshing()
            HCShowError(info: "没有更多信息")
            return
        }
        
        if docModel == nil {
            HttpRequestManager.shareIntance.HC_findDoctorFromId(doctorId: doctorId!, callback: { [weak self](success, arr, msg) in
                if success == true {
                    self?.docModel = arr?[0]
                }else{
                    HCShowError(info: msg)
                }
            })
        }
        
        SVProgressHUD.show()
        
        HttpRequestManager.shareIntance.HC_doctorReview(doctorId: doctorId!, pageNum: String.init(format: "%d", pageNo)) { [weak self](success, hasNext, arr, msg) in
            if success == true{
                if let dataArr = self?.dataArr {
                    let tempArr = dataArr + arr!
                    self?.dataArr = tempArr
                }else{
                    self?.dataArr = arr
                }
                self?.hasNext = hasNext
                if hasNext {
                    self?.pageNo += 1
                }
                SVProgressHUD.dismiss()
            }else{
                HCShowError(info: msg)
            }
            self?.tableV.mj_footer.endRefreshing()        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DoctorIntroductionController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return docModel != nil ? 1 : 0
        }else{
            return dataArr?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: doctorIntroCell, for: indexPath) as! DoctorIntroTableViewCell
            cell.model = docModel
            cell.updateConstraints()
            cell.updateConstraintsIfNeeded()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCell, for: indexPath) as! DoctorCommentTVCell
            cell.model = dataArr?[indexPath.row]
            cell.updateConstraints()
            cell.updateConstraintsIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }else{
            return sectionTitleV1()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension DoctorIntroductionController {
    
    func sectionTitleV1()-> UIView{
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        v.backgroundColor = UIColor.white
        
        numOfCommentL.font = UIFont.init(name: kReguleFont, size: 14)
        numOfCommentL.textColor = kTextColor
        v.addSubview(numOfCommentL)
        
        commentStarV.leftAligment = true
        v.addSubview(commentStarV)
        
        let diviV = UIView.init(frame: CGRect.init(x: 0, y: 29, width: SCREEN_WIDTH, height: 1))
        diviV.backgroundColor = kdivisionColor
        v.addSubview(diviV)
        
        return v
    }
    
    func initHeaderView(){
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 220))
        containerV.backgroundColor = UIColor.white
        
        containerV.addSubview(headV)
        headV.snp.updateConstraints { (make) in
            make.top.equalTo(containerV).offset(20)
            make.centerX.equalTo(containerV)
            make.width.height.equalTo(80)
        }
        headV.layer.cornerRadius = 40
        headV.contentMode = UIViewContentMode.scaleAspectFill
        headV.clipsToBounds = true
        
        containerV.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.right.equalTo(containerV.snp.centerX).offset(-10)
            make.top.equalTo(headV.snp.bottom).offset(10)
            make.height.equalTo(16)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 14)
        nameL.textColor = kTextColor
        
        containerV.addSubview(jobL)
        jobL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV.snp.centerX)
            make.bottom.equalTo(nameL)
            make.height.equalTo(13)
        }
        jobL.font = UIFont.init(name: kReguleFont, size: 12)
        jobL.textColor = kLightTextColor
        
        containerV.addSubview(hospitalL)
        hospitalL.snp.updateConstraints { (make) in
            make.centerX.equalTo(containerV)
            make.top.equalTo(nameL.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        hospitalL.font = UIFont.init(name: kReguleFont, size: 13)
        hospitalL.textColor = kLightTextColor
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.equalTo(containerV)
            make.top.equalTo(hospitalL.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        divisionV.backgroundColor = kdivisionColor
        
        let titleL = UILabel()
        containerV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.centerX.equalTo(containerV).offset(-SCREEN_WIDTH / 4)
            make.top.equalTo(divisionV.snp.bottom).offset(10)
            make.height.equalTo(13)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: 12)
        titleL.textColor = kLightTextColor
        titleL.text = "回复次数"
        
        containerV.addSubview(replyCountL)
        replyCountL.snp.updateConstraints { (make) in
            make.centerX.equalTo(titleL)
            make.top.equalTo(titleL.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        replyCountL.font = UIFont.init(name: kReguleFont, size: 14)
        replyCountL.textColor = kDefaultThemeColor
        
        let titleL2 = UILabel()
        containerV.addSubview(titleL2)
        titleL2.snp.updateConstraints { (make) in
            make.centerX.equalTo(containerV).offset(SCREEN_WIDTH / 4)
            make.top.equalTo(titleL)
            make.height.equalTo(13)
        }
        titleL2.font = UIFont.init(name: kReguleFont, size: 12)
        titleL2.textColor = kLightTextColor
        titleL2.text = "咨询价格"
        
        containerV.addSubview(priceL)
        priceL.snp.updateConstraints { (make) in
            make.centerX.equalTo(titleL2)
            make.top.equalTo(titleL2.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        priceL.font = UIFont.init(name: kReguleFont, size: 14)
        priceL.textColor = kDefaultThemeColor
        
        let divisionV2 = UIView()
        containerV.addSubview(divisionV2)
        divisionV2.snp.updateConstraints { (make) in
            make.left.right.equalTo(containerV)
            make.bottom.equalTo(containerV)
            make.height.equalTo(5)
        }
        divisionV2.backgroundColor = kdivisionColor
        
        tableV.tableHeaderView = containerV
    }

}
