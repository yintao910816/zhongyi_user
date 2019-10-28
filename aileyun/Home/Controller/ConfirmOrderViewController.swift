//
//  ConfirmOrderViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/12.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ConfirmOrderViewController: BaseViewController {
    
   
    var consultId : NSNumber?
    
    var price : String?{
        didSet {
            priceL.text = price
            nameL.text = "发起咨询"
            defaultTool = 0
        }
    }
    var doctorName : String?{
        didSet{
            titleL.text = "咨询对象：" + doctorName!
        }
    }
    
    //为了model
    //doctorId : String?
    
    let nameL = UILabel()
    let titleL = UILabel()
    let priceL = UILabel()
    
    let alipayBtn = UIButton()
    let weixinBtn = UIButton()
    
    let payBtn = UIButton()
    
    var weixinPrepayId : String?
    
    var defaultTool : NSInteger? {
        didSet{
            if defaultTool == 0 {
                alipayBtn.isSelected = true
                weixinBtn.isSelected = false
            }else{
                alipayBtn.isSelected = false
                weixinBtn.isSelected = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "订单确认"
        
        initUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkAlipayResult), name: NSNotification.Name.init(ALIPAY_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkWeixinPayResult), name: NSNotification.Name.init(WEIXIN_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPayFail), name: NSNotification.Name.init(PAY_FAIL), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "返回灰"), style: .plain, target: self, action: #selector(goToRecordVC))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func goToRecordVC(){
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func checkAlipayResult(note : Notification){
        SVProgressHUD.show(withStatus: "正在查询支付结果...")
        
        let tradeNo = note.userInfo?["tradeNo"] as! String
        HttpRequestManager.shareIntance.checkAlipayResult(tradeNo: tradeNo) { (success, msg) in
            if success == true {
                HCShowInfo(info: msg)
                self.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
            }else{
                HCShowError(info: msg)
            }
        }
    }
    
    @objc func checkWeixinPayResult(){
        SVProgressHUD.show(withStatus: "正在查询支付结果...")
        
        HttpRequestManager.shareIntance.checkWeixinPayResult(prepayId: weixinPrepayId!) { (success, msg) in
            if success == true {
                HCShowInfo(info: msg)
                self.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
            }else{
                HCShowError(info: msg)
            }
        }
    }
    
    @objc func showPayFail(){
        HCShowError(info: "支付不成功")
    }


    func initUI(){
        
        let space = AppDelegate.shareIntance.space
        let contaiV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: 116))
        contaiV.backgroundColor = UIColor.white
        self.view.addSubview(contaiV)
        
        contaiV.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.left.top.equalTo(contaiV).offset(20)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 12)
        nameL.textColor = kLightTextColor
        
        contaiV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL)
            make.top.equalTo(nameL.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(25)
        }
        titleL.font = UIFont.init(name: kBoldFont, size: 18)
        titleL.textColor = kTextColor
        
        contaiV.addSubview(priceL)
        priceL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL)
            make.top.equalTo(titleL.snp.bottom)
            make.height.equalTo(25)
        }
        priceL.font = UIFont.init(name: kReguleFont, size: 16)
        priceL.textColor = kDefaultThemeColor
        
        let divi = UIView()
        contaiV.addSubview(divi)
        divi.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(contaiV)
            make.height.equalTo(10)
        }
        divi.backgroundColor = kdivisionColor
        
        //选择支付方式
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: 180, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        containerV.backgroundColor = UIColor.white
        self.view.addSubview(containerV)
        
        let chooseL = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: 100, height: 20))
        containerV.addSubview(chooseL)
        chooseL.font = UIFont.init(name: kReguleFont, size: 12)
        chooseL.textColor = kLightTextColor
        chooseL.text = "选择支付方式"
        
        let alipayImgV = UIImageView()
        containerV.addSubview(alipayImgV)
        alipayImgV.snp.updateConstraints { (make) in
            make.left.equalTo(chooseL)
            make.top.equalTo(chooseL.snp.bottom).offset(20)
            make.width.height.equalTo(30)
        }
        alipayImgV.image = UIImage.init(named: "支付宝")
        alipayImgV.contentMode = .scaleAspectFit
        
        let alipayL = UILabel()
        containerV.addSubview(alipayL)
        alipayL.snp.updateConstraints { (make) in
            make.centerY.equalTo(alipayImgV)
            make.left.equalTo(alipayImgV.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        alipayL.font = UIFont.init(name: kReguleFont, size: 16)
        alipayL.textColor = kTextColor
        alipayL.text = "支付宝"
        
        containerV.addSubview(alipayBtn)
        alipayBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(alipayImgV)
            make.right.equalTo(containerV).offset(-20)
            make.width.height.equalTo(30)
        }
        alipayBtn.setImage(UIImage.init(named: "未选中"), for: .normal)
        alipayBtn.setImage(UIImage.init(named: "选中"), for: .selected)
        alipayBtn.tag = 0
        alipayBtn.addTarget(self, action: #selector(chooseTool), for: .touchUpInside)
        
        let diviV = UIView()
        containerV.addSubview(diviV)
        diviV.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(20)
            make.bottom.equalTo(alipayImgV).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(0.5)
        }
        diviV.backgroundColor = klightGrayColor
    
        
        let weixinImgV = UIImageView()
        containerV.addSubview(weixinImgV)
        weixinImgV.snp.updateConstraints { (make) in
            make.left.width.height.equalTo(alipayImgV)
            make.top.equalTo(alipayImgV.snp.bottom).offset(20)
        }
        weixinImgV.image = UIImage.init(named: "微信支付")
        weixinImgV.contentMode = .scaleAspectFit
        
        let weixinL = UILabel()
        containerV.addSubview(weixinL)
        weixinL.snp.updateConstraints { (make) in
            make.centerY.equalTo(weixinImgV)
            make.left.equalTo(weixinImgV.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        weixinL.font = UIFont.init(name: kReguleFont, size: 16)
        weixinL.textColor = kTextColor
        weixinL.text = "微信支付"

        containerV.addSubview(weixinBtn)
        weixinBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(weixinImgV)
            make.right.equalTo(containerV).offset(-20)
            make.width.height.equalTo(30)
        }
        weixinBtn.setImage(UIImage.init(named: "未选中"), for: .normal)
        weixinBtn.setImage(UIImage.init(named: "选中"), for: .selected)
        weixinBtn.tag = 1
        weixinBtn.addTarget(self, action: #selector(chooseTool), for: UIControl.Event.touchUpInside)
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(containerV)
            make.top.equalTo(weixinImgV.snp.bottom).offset(20)
        }
        divisionV.backgroundColor = klightGrayColor
        
        self.view.addSubview(payBtn)
        payBtn.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(48)
            make.bottom.equalTo(self.view).offset(-space.bottomSpace)
        }
        payBtn.setTitle("确认支付", for: .normal)
        payBtn.titleLabel?.font = UIFont.init(name: kBoldFont, size: 16)
        payBtn.backgroundColor = kDefaultThemeColor
        
        payBtn.addTarget(self, action: #selector(pay), for: .touchUpInside)
    }
    

    @objc func chooseTool(btn : UIButton){
        defaultTool = btn.tag
    }
    
    @objc func pay(){
        
        let consultS = String.init(format: "%@", consultId!)
        if defaultTool == 0 {
            //支付宝
            var randomS = ""
            for _ in 0..<4 {
                randomS = randomS.appending(String.init(format: "%d", arc4random_uniform(10)))
            }
            let tradeNo = String.init(format: "%@%@%@", (UserManager.shareIntance.HCUser?.phone)!, Date.init().converteYYYYMMddHHmmss(), randomS)
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.alipay(objectId: consultS, tradeNo: tradeNo, callback: { [weak self](success, chargeS) in
                if success == true{
                    HCPrint(message: chargeS)
                    SVProgressHUD.dismiss()
                    AlipaySDK.defaultService().payOrder(chargeS, fromScheme: kScheme, callback: { (resultDic) in
                        HCPrint(message: resultDic)
                        let resultS = resultDic?["resultStatus"] as! String
                        
                        switch resultS {
                        case "4000":
                            HCShowError(info: "订单支付失败")
                        case "6001":
                            HCShowError(info: "用户中途取消")
                        case "6002":
                            HCShowError(info: "网络连接出错")
                        case "9000":
                            let s = resultDic?["result"] as! String
                            do{
                                let dic = try JSONSerialization.jsonObject(with: s.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                                let tempDic = dic["alipay_trade_app_pay_response"] as! [String : Any]
                                let tradeNo = tempDic["out_trade_no"] as! String
                                //支付成功  发送通知
                                
                                let not = Notification.init(name: NSNotification.Name.init(ALIPAY_SUCCESS), object: nil, userInfo: ["tradeNo" : tradeNo])
                                self?.checkAlipayResult(note: not)
                            }
                            catch{}
                        default:
                            HCShowError(info: "nothing")
                        }
                    })
                }else{
                    HCShowError(info: "支付失败！")
                }
            })
        }else{
            //微信
            HCShowInfo(info: "抱歉，暂不支持微信支付")
            
//            SVProgressHUD.show()
//            HttpRequestManager.shareIntance.weixinPay(objectId: consultS, account: (UserManager.shareIntance.HCUser?.phone)!, callback: { [weak  self](success, model) in
//                if success == true{
//                    SVProgressHUD.dismiss()
//                    self?.weixinPrepayId = model?.prepayid
//
//                    let req = PayReq.init()
//                    req.partnerId = model?.partnerid
//                    req.prepayId = model?.prepayid
//                    req.nonceStr = model?.noncestr
//                    req.timeStamp = UInt32((model?.timestamp)!)!
//                    req.package = model?.packageValue
//                    req.sign = model?.sign
//
//                    WXApi.send(req)
//                }else{
//                    HCShowError(info: "支付失败！")
//                }
//            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
