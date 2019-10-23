//
//  RecordTableViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

protocol GetPhotoCenterDelegate : NSObjectProtocol {
    //设置协议方法
    func getPhotoCenter()->CGPoint
    
    func getImage()->UIImage
}

class RecordTableViewController: UITableViewController {
    weak var photoCenterDelegate : GetPhotoCenterDelegate?
    weak var parentVC : UIViewController?
    
    //默认图片cell的大小
    let PhotoesWidth = (SCREEN_WIDTH - 77 - 40) / 3
    
    let tableVHeight = SCREEN_HEIGHT - 104
    
    var status : String?{
        didSet{
            dealWithStatus(status: status!)
        }
    }
    
    var dataModel : ConsultArrModel? {
        didSet{
            if dataModel?.status != status {
                tableData = dataModel?.dataSource
                dataArr = dataModel?.dataState
                pageNo = (dataModel?.pageNo)!
                status = dataModel?.status
            }
        }
    }
    
    //新接口
    var dataArr : [HC_consultArrModel]?
    
    var tableData : [[HC_consultViewmodel]]?{
        didSet{
            tableView.reloadData()
            if tableData != nil && (tableData?.count)! > 0 {
                nodataIV.isHidden = true
            }else{
                nodataIV.isHidden = false
            }
        }
    }
    
    var hasNext : Bool = true
    
    var pageNo : NSInteger = 1
    
    var clickBlock : ((UIViewController)->())?
    
    var convertPointBlock : ((CGPoint)->CGPoint)?
    
    //父控制器缓存数据
    var saveDataBlock : ((ConsultArrModel)->())?
    
    lazy var nodataIV : UIImageView = {
        let IV = UIImageView.init(frame: CGRect.init(x: 40, y: 100, width: SCREEN_WIDTH - 80, height: SCREEN_WIDTH - 80))
        IV.image = UIImage.init(named: "noData")
        IV.contentMode = UIViewContentMode.scaleAspectFit
        
        self.view.addSubview(IV)
        return IV
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: tableVHeight)
        
        self.tableView.register(ChatTextTableViewCell.self, forCellReuseIdentifier: TypeText)
        self.tableView.register(ChatPicTableViewCell.self, forCellReuseIdentifier: TypePic)
        self.tableView.register(ChatVoiceTableViewCell.self, forCellReuseIdentifier: TypeVoice)
        
        self.tableView.separatorStyle = .none
        
        let footV = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(RecordTableViewController.moreData))
        tableView.mj_footer = footV
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0   , right: 0)
        
        self.tableView.backgroundColor = kdivisionColor
    }
    
    func dealWithStatus(status : String){
        guard dataArr != nil else {
            initData()
            return
        }
        
        guard (dataArr?.count)! > 0 else {
            initData()
            return
        }
        
        guard status != "" else{
            return
        }

        switch status {
        case "-1":
            if dataArr?[0].currentStatus?.intValue != -1 {
                initData()
            }
        case "0":
            if dataArr?[0].currentStatus?.intValue != 0 {
                initData()
            }
        case "1,2":
            if dataArr?[0].currentStatus?.intValue != 1 && dataArr?[0].currentStatus?.intValue != 2 {
                initData()
            }
        case "3,4":
            if dataArr?[0].currentStatus?.intValue != 3 && dataArr?[0].currentStatus?.intValue != 4 {
                initData()
            }
        default:
            HCShowError(info: "数据错误")
        }
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension RecordTableViewController {
    
    func initData(){
        pageNo = 1
        hasNext = true
        
        dataArr?.removeAll()
        tableData?.removeAll()
        
        SVProgressHUD.show()
        requestDate(status: status!) { [weak self](success, s) in
            if success == true {
                SVProgressHUD.dismiss()
                guard (self?.dataArr?.count)! > 0 && (self?.tableData?.count)! > 0 else{return}
                self?.produceDataModel()
            }else{
                HCShowError(info: s)
            }
        }
    }
    
    func moreData(){
        self.tableView.mj_footer.endRefreshing()
        
        SVProgressHUD.show()
        requestDate(status: status!) { [weak self](success, s) in
            if success == true {
                self?.produceDataModel()
                SVProgressHUD.dismiss()
            }else{
                HCShowError(info: s)
            }
        }
    }
    
    //网络请求结果更新数据
    func produceDataModel(){
        dataModel = ConsultArrModel.init(stateArr: self.dataArr!, sourceArr: self.tableData!, status: self.status!, pageNo: self.pageNo)
        
        if let saveDataBlock = saveDataBlock{
            saveDataBlock(dataModel!)
        }
    }
    
    func requestDate(status : String, callback : @escaping (Bool, String) -> ()){
        guard hasNext == true else{
            callback(false, "已全部加载")
            return
        }
        
        let paId = UserManager.shareIntance.HCUser?.id?.intValue
        HttpRequestManager.shareIntance.HC_patientConsultList(patientId: paId!, status: status, pageNum: String.init(format: "%d", pageNo)) { [weak self](success, hasNext, dicArr) in
            if success == true{
                self?.hasNext = hasNext
                self?.pageNo += 1
                if let dicArr = dicArr {
                    var dataArr = [HC_consultArrModel]()
                    for i in dicArr{
                        let model = HC_consultArrModel.mj_object(withKeyValues: i)
                        dataArr.append(model!)
                    }
                    //保存模型
                    if self?.dataArr != nil {
                        var tempArr = (self?.dataArr)!
                        tempArr += dataArr
                        self?.dataArr = tempArr
                    }else{
                        self?.dataArr = dataArr
                    }
                    
                    //生成viewmodel
                    if self?.tableData != nil {
                        var tempArr = (self?.tableData)!
                        tempArr += (self?.convertToViewmodel(arr: dataArr))!
                        self?.tableData = tempArr
                    }else{
                        self?.tableData = self?.convertToViewmodel(arr: dataArr)
                    }
                    
                    callback(true, "请求成功")
                }else{
                    callback(false, "没有相关数据")
                }
            }else{
                callback(false, "网络异常")
            }
        }
    }

}


extension RecordTableViewController {
    func convertToViewmodel(arr : [HC_consultArrModel]) -> [[HC_consultViewmodel]]{
        
        var viewmodelArr = [[HC_consultViewmodel]]()
        
        for secModel in arr {
            var secVMArr = [HC_consultViewmodel]()
            
            let patientImg = UserManager.shareIntance.HCUserInfo?.imgUrl
            
            if let cont = secModel.content {
                let tempdic = ["type" : TypeText, "content" : cont, "createTime" : secModel.createTime, "isDoctor" : "0", "headImg" : patientImg] as [String : Any]
                let model = HC_consultCellModel.init(tempdic)
                let viewmodel = HC_consultViewmodel.init()
                viewmodel.model = model
                secVMArr.append(viewmodel)
            }
            
            if let imgS = secModel.imageList{
                if imgS.contains(","){
                    let arr = imgS.components(separatedBy: ",")
                    for i in arr{
                        if i != "" && i != nil {
                            let tempdic = ["type" : TypePic, "imageList" : i, "createTime" : secModel.createTime, "isDoctor" : "0", "headImg" : patientImg] as [String : Any]
                            let model = HC_consultCellModel.init(tempdic)
                            let viewmodel = HC_consultViewmodel.init()
                            viewmodel.model = model
                            secVMArr.append(viewmodel)
                        }
                    }
                }else if imgS.hasSuffix(".jpg"){
                    let tempdic = ["type" : TypePic, "imageList" : imgS, "createTime" : secModel.createTime, "isDoctor" : "0", "headImg" : patientImg] as [String : Any]
                    let model = HC_consultCellModel.init(tempdic)
                    let viewmodel = HC_consultViewmodel.init()
                    viewmodel.model = model
                    secVMArr.append(viewmodel)
                }
            }
            
            guard (secModel.replyList?.count)! > 0 else{
                viewmodelArr.append(secVMArr)
                continue
            }
            
            let replyArr = secModel.replyList as! [HC_consultListModel]
            for replyModel in replyArr {
                
                if replyModel.content != nil && replyModel.content != ""{
                    let tempdic = ["type" : TypeText, "content" : replyModel.content, "createT" : replyModel.createTime, "isDoctor" : "1", "headImg" : secModel.doctorImg] as [String : Any]
                    let model = HC_consultCellModel.init(tempdic)
                    let viewmodel = HC_consultViewmodel.init()
                    viewmodel.model = model
                    secVMArr.append(viewmodel)
                }
                
                if let imgS = replyModel.imageList{
                    if imgS.contains(","){
                        let arr = imgS.components(separatedBy: ",")
                        for i in arr{
                            let tempdic = ["type" : TypePic, "imageList" : i, "createT" : replyModel.createTime, "isDoctor" : "1", "headImg" : secModel.doctorImg] as [String : Any]
                            let model = HC_consultCellModel.init(tempdic)
                            let viewmodel = HC_consultViewmodel.init()
                            viewmodel.model = model
                            secVMArr.append(viewmodel)
                        }
                    }else if imgS.hasSuffix(".jpg"){
                        let tempdic = ["type" : TypePic, "imageList" : imgS, "createT" : replyModel.createTime, "isDoctor" : "1", "headImg" : secModel.doctorImg] as [String : Any]
                        let model = HC_consultCellModel.init(tempdic)
                        let viewmodel = HC_consultViewmodel.init()
                        viewmodel.model = model
                        secVMArr.append(viewmodel)
                    }else if imgS.hasSuffix(".amr"){
                        let tempdic = ["type" : TypeVoice, "imageList" : imgS, "createT" : replyModel.createTime, "isDoctor" : "1", "headImg" : secModel.doctorImg] as [String : Any]
                        let model = HC_consultCellModel.init(tempdic)
                        let viewmodel = HC_consultViewmodel.init()
                        viewmodel.model = model
                        secVMArr.append(viewmodel)
                    }
                }
            }
            viewmodelArr.append(secVMArr)
        }
        return viewmodelArr
    }
}




extension RecordTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData![section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = tableData?[indexPath.section]
        let viewmodel = arr?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: (viewmodel?.model?.type)!, for: indexPath) as! BaseChatTableViewCell
        cell.viewModel = viewmodel
        cell.showPhotoBlock = {[weak self](urlArr)in
            let showPhotoVC = ShowPhotoViewController()
            showPhotoVC.urlArr = urlArr
            
            self?.photoCenterDelegate = cell
            
            self?.parentVC?.navigationController?.delegate = self
            self?.parentVC?.navigationController?.pushViewController(showPhotoVC, animated: true)
        }
        cell.convertBlock = {(p)in
            return cell.convert(p, to: tableView)
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = tableData?[indexPath.section]
        let viewmodel = arr?[indexPath.row]
        return viewmodel!.cellHeight ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = dataArr?[section]
        let status = model?.currentStatus
        if status?.intValue == 0 {
            return 8
        }else{
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataArr?[section]
        return ConsultHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50), name: model?.doctorName, status: model?.currentStatus?.intValue)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = dataArr?[section]
        let status = model?.currentStatus?.intValue
        
        if let status = status {
            if status == 0 {
                return UIView()
            }else{
                var type = ""
                switch status {
                case -1:
                    type = "未支付"
                case 1,2:
                    type = "已回复"
                case 3,4:
                    type = "已退回"
                default:
                    type = ""
                }

                return ConsultFootView.init(CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 80), type: type, isEvaluation: (model?.reviewStatus?.intValue)!, price : (model?.docPrice)!, callback: { [weak self](i) in
                    
                    let model = self?.dataArr?[section]
                    
                    if i == 101 {
                        HCPrint(message: "马上支付")
                        if let block = self?.clickBlock{
                            let vc = ConfirmOrderViewController()
                            vc.consultId =  model?.Id
                            vc.price = model?.docPrice
                            vc.doctorName = model?.doctorName
                            block(vc)
                        }
                    }else if i == 102{
                        HCPrint(message: "修改咨询")
                        if let block = self?.clickBlock{
                            let vc = SubmitViewController()
                            vc.price =  model?.docPrice
                            vc.doctorId = model?.doctorId
                            vc.doctorName = model?.doctorName
                            vc.listConsult = model?.content
                            vc.consultId = model?.Id?.intValue
                            vc.isModify = true
                            block(vc)
                        }
                    }else if i == 103{
                        HCPrint(message: "再次咨询")
                        if let block = self?.clickBlock{
                            let vc = SubmitViewController()
                            vc.price = model?.docPrice
                            vc.doctorId = model?.doctorId
                            vc.doctorName = model?.doctorName
                            block(vc)
                        }
                    }else if i == 104{
                        HCPrint(message: "马上评价")
                        if let block = self?.clickBlock{
                            let vc = CommentDocViewController()
                            vc.consultId =  model?.Id
                            vc.doctorId = model?.doctorId
                            vc.doctorName = model?.doctorName
                            block(vc)
                        }
                    }else if i == 105{
                        HCPrint(message: "查看评价")
                        if let block = self?.clickBlock{
                            let vc = CommentDocViewController()
                            vc.consultId =  model?.Id
                            vc.doctorName = model?.doctorName
                            vc.isCheck = true
                            block(vc)
                        }
                    }else if i == 106{
                        HCPrint(message: "删除未支付")
                        HttpRequestManager.shareIntance.HC_delConsult(consultId: (model?.Id?.intValue)!, callback: {(success, msg) in
                            if success == true{
                                HCShowInfo(info: msg)
                                self?.initData()
                            }else{
                                HCShowError(info: msg)
                            }
                        })
                    }
                })
            }
        }else{
            return UIView()
        }
    }
}

extension RecordTableViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let pushTransition = PushAnimation()
        
        let oriCenter = photoCenterDelegate?.getPhotoCenter()
        var scP = CGPoint.zero
        if let block = convertPointBlock {
            scP = block(oriCenter!)
            HCPrint(message: scP)
        }
        
        if operation == UINavigationControllerOperation.push{
            pushTransition.aniType = .kAnimatorTransitionTypePush
            pushTransition.itemCenter = scP
        }else{
            pushTransition.aniType = .kAnimatorTransitionTypePop
            pushTransition.itemCenter = scP
        }
        
        pushTransition.itemSize = CGSize.init(width: PhotoesWidth, height: PhotoesWidth)
        pushTransition.image = photoCenterDelegate?.getImage()
        
        return pushTransition
    }
}

