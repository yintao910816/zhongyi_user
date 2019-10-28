//
//  HttpRequestManager.swift
//  
//
//  Created by pg on 2017/4/24.
//
//

import Foundation
import HandyJSON

class HttpRequestManager {
    
    // 设计成单例
    static let shareIntance : HttpRequestManager = {
        let tools = HttpRequestManager()
        return tools
    }()
    
    // 获取咨询消息
    func consultRecord(pageNo : String,  pageSize : NSInteger, status : String, callback : @escaping (_ success : Bool, _ dicArr : [[String : Any]]?, _ message : String)->()){
        
        let dic = NSDictionary.init(dictionary: ["pageNp" : pageNo, "pageSize" : pageSize, "status" : status])
        
        HttpClient.shareIntance.POST(PATIENT_CONSULT_CONSULTLIST, parameters: dic) { (result, ccb) in
            
            if ccb.success() {
                let dicArr = ccb.data as! [[String : Any]]
                callback(true, dicArr, "获取信息成功！")
            }else{
                callback(false, nil, ccb.msg)
            }
        }
    }
    
    //登录
    func loginBy(userName : String, password : String, callback : @escaping (Bool, LocalUserModel?)->()){
        let dic = NSDictionary.init(dictionary: ["uname" : userName, "pwd" : password])
        HttpClient.shareIntance.POST(USER_LOGIN_URL, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
//                let model = LocalUserModel.init(dic)
                let model = JSONDeserializer<LocalUserModel>.deserializeFrom(dict: dic)
                callback(true, model)
            }else{
                callback(false, nil)
            }
        }
    }
    
    //获取对医生的评价
    func doctorComment(doctorId : String, pageNo : String, callback : @escaping (Bool, ConsultDoctorModel?, [DoctorCommentModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["doctorId" : doctorId, "pageNo" : pageNo, "pageSize" : 10])
        HttpClient.shareIntance.POST(PATIENT_CONSULT_GETREVIEW, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
                let tempArr = dic["review"] as? Array<[String : Any]>
                guard tempArr != nil else{
                    callback(true, nil, nil)
                    return
                }
                var arr = [DoctorCommentModel]()
                for dic in tempArr! {
//                    let model = DoctorCommentModel.init(dic)
                    if let model = JSONDeserializer<DoctorCommentModel>.deserializeFrom(dict: dic) {
                        arr.append(model)
                    }
                }
                
                var docModel : ConsultDoctorModel?
                if pageNo == "1" {
                    let tempDic = dic["doctorDeatil"] as? [String : Any]
//                    docModel = ConsultDoctorModel.init(tempDic!)
                    docModel = JSONDeserializer<ConsultDoctorModel>.deserializeFrom(dict: tempDic)
                }
                
                callback(true, docModel, arr)
            }else{
                callback(false, nil, nil)
            }
        }
    }
    
    //获取医生列表
    func doctorList(pageNo : String, callback : @escaping (Bool, [ConsultedModel]?, [ConsultDoctorModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["pageNo" : pageNo, "pageSize" : 10])
        HttpClient.shareIntance.POST(PATIENT_CONSULT_GETDOCTORLIST, parameters: dic) { (result, ccb) in
            if ccb.success(){
                var consultedArr = [ConsultedModel]()
                var doctorArr = [ConsultDoctorModel]()
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    let didArr = dic["consulted"] as? [[String : Any]]
                    if let arr = didArr {
                        for i in arr{
//                            let model = ConsultedModel.init(i)
                            if let model = JSONDeserializer<ConsultedModel>.deserializeFrom(dict: i) {
                                consultedArr.append(model)
                            }
                        }
                    }
                    let arr = dic["all"] as? [[String : Any]]
                    if let arr = arr {
                        for i in arr{
//                            let model = ConsultDoctorModel.init(i)
                            if let model = JSONDeserializer<ConsultDoctorModel>.deserializeFrom(dict: i) {
                                doctorArr.append(model)
                            }
                        }
                    }
                }
                callback(true, consultedArr, doctorArr)
            }else{
                callback(false, nil, nil)
            }
        }
    }
    
    //发起咨询
    func uploadImg(doctorId : String, content : String, realName : String, imgArr : [UIImage], callback : @escaping (Bool, [String : Any]?)->()){
        let dic = NSDictionary.init(dictionary: ["doctorId" : doctorId, "content" : content, "realName" : realName])
        HttpClient.shareIntance.uploadImage(COMMON_UPLOADIMAGE, parameters: dic, imageArr: imgArr) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                callback(true, dic)
            }else{
                callback(false, nil)
            }
        }
    }
    
    //获取消息评价
    func getCommentFor(consultId : String, callback : @escaping (Bool, DoctorCommentModel?)->()){
        let dic = NSDictionary.init(dictionary: ["consultId" : consultId])
        HttpClient.shareIntance.POST(PATIENT_CONSULT_GETEVALUATION, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
//                let model = DoctorCommentModel.init(dic!)
                let model = JSONDeserializer<DoctorCommentModel>.deserializeFrom(dict: dic)
                callback(true, model)
            }else{
                callback(false, nil)
            }
        }
    }
    
    //提交评价
    func comment(consultId : String, content : String, startNum : String, callback : @escaping (Bool)->()){
        let dic = NSDictionary.init(dictionary: ["consultId" : consultId, "content" : content, "startNum" : startNum])
        HttpClient.shareIntance.POST(PATIENT_CONSULT_EVALUATIONdOCTOR, parameters: dic) { (result, ccb) in
            if ccb.success(){
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    

        
    //支付宝
    func alipay(objectId : String, tradeNo : String, callback : @escaping (Bool, String?)->()){
        let dic =  NSDictionary.init(dictionary: ["objectId" : objectId, "tradeNo" : tradeNo])
        HttpClient.shareIntance.POST(REQEST_GET_ALIPAY_CHARGE, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                let s = ccb.data as! String
                callback(true, s)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //支付宝结果查询
    func checkAlipayResult(tradeNo : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["tradeNo" : tradeNo])
        HttpClient.shareIntance.POST(CHECK_ALIPAY, parameters: dic) { (result, ccb) in
            if ccb.success() {
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //微信生成预付单
    func weixinPay(objectId : String, account : String, callback : @escaping (Bool, weixinPrepayModel?)->()){
        let dic = NSDictionary.init(dictionary: ["objectId" : objectId, "account" : account])
        HttpClient.shareIntance.POST(REQEST_GET_PREPAY_ID, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                guard let dic = ccb.data as? [String : Any] else{
                    callback(false, nil)
                    return
                }
//                let model = weixinPrepayModel.init(dic)
                let model = JSONDeserializer<weixinPrepayModel>.deserializeFrom(dict: dic)
                callback(true, model)
            }else{
                callback(false, nil)
            }
        }
    }
    
    //微信支付结果 
    func checkWeixinPayResult(prepayId : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["prepayId" : prepayId])
        HttpClient.shareIntance.POST(CHECK_WEIXIN, parameters: dic) { (result, ccb) in
            if ccb.success() {
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }

    
    
    
    
    
    
    // **************  新接口  ****************
    
    
    func HC_uploadHeadImg(img : UIImage, callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.uploadImage(USER_FILE_UPLOAD, parameters: nil, imageArr: [img]) { (result, ccb) in
            if ccb.success() {
                let array = ccb.data as! [[String : Any]]
                var replyPathArr = [String]()
                for i in array{
                    let uploadPath = i["path"] as! String
                    replyPathArr.append(uploadPath)
                }
                callback(true, replyPathArr[0])
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //上传单张图片
    func HC_uploadSingleImg(img : UIImage, callback : @escaping (Bool, String)->()){
        
        HttpClient.shareIntance.uploadSingleImage(UPLOAD_SINGLE_IMAGE, parameters: nil, img: img) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                let s = dic["filePath"] as! String
                callback(true, s)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
    //登录

    func HC_login(uname : String, pwd : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["uname" : uname, "pwd" : pwd])
        HttpClient.shareIntance.GET(HC_LOGIN, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    
                    UserDefaults.standard.set(dic, forKey: kUserDic)
                    
//                    let model = HCUserModel.init(dic)
                    let model = JSONDeserializer<HCUserModel>.deserializeFrom(dict: dic)
                    UserManager.shareIntance.HCUser = model
                }
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //注册

    func HC_register(uname : String, code : String, pwd : String, pwd2 : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["uname" : uname, "code" : code, "pwd" : pwd, "pwd2" : pwd2])
        HttpClient.shareIntance.GET(HC_REGISTER, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    //保存phoneNumber
                    let phone = dic["phone"] as? String
                    if let phone = phone {
                        HCPrint(message: "setted  phone")
                        UserDefaults.standard.set(phone, forKey: kUserPhone)
                    }
                    
//                    let model = HCUserModel.init(dic)
                    let model = JSONDeserializer<HCUserModel>.deserializeFrom(dict: dic)
                    UserManager.shareIntance.HCUser = model
                }

                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //注销
    func HC_logout(patientId : NSInteger, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId])
        HttpClient.shareIntance.GET(HC_LOGOUT, parameters: dic) { (resutl, ccb) in
            if ccb.success(){
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //找回密码
    func HC_findPwd(phone : String, pwd : String, code : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["phone" : phone, "pwd" : pwd, "code" : code])
        HttpClient.shareIntance.GET(HC_FINDPWD, parameters: dic) { (result, ccb) in
            if ccb.success(){
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //获取验证码
    func HC_validateCode(phone : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["phone" : phone])
        HttpClient.shareIntance.GET(HC_VALIDATECODE, parameters: dic) { (result, ccb) in
            if ccb.success(){
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    // 校验验证码
    func HC_validate(phone : String, code : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["phone" : phone, "code" : code])
        HttpClient.shareIntance.GET(HC_VALIDATE, parameters: dic) { (result, ccb) in
            if ccb.success(){
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //用户信息
    func HC_userInfo(callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.GET(HC_USERINFO, parameters: nil) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    UserDefaults.standard.set(dic, forKey: kUserInfoDic)
//                    let infoModel = HCUserInfoModel.init(dic)
                    let infoModel = JSONDeserializer<HCUserInfoModel>.deserializeFrom(dict: dic)
                    UserManager.shareIntance.HCUserInfo = infoModel
                }
                
                //获取BBSToken
                self.HC_getBBSToken(callback: {(_, _)in
                })
                
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //首页banner
    func HC_banner(callback : @escaping (Bool, [HomeBannerModel]?, String)->()){
        HttpClient.shareIntance.GET(HC_BANNER, parameters: nil) { (result, ccb) in
            if ccb.success(){
                let dicArr = ccb.data as? [[String : Any]]
                if let dicArr = dicArr {
                    var arr = [HomeBannerModel]()
                    for dic in dicArr {
//                        let m = HomeBannerModel.init(dic)
                        if let m = JSONDeserializer<HomeBannerModel>.deserializeFrom(dict: dic) {
                            arr.append(m)
                        }
                    }
                    callback(true, arr, ccb.msg)
                }else{
                    callback(false, nil, ccb.msg)
                }
            }else{
                callback(false, nil, ccb.msg)
            }
        }
    }
    
    //首页功能导航

    func HC_functionList(callback : @escaping (Bool, [HomeFunctionModel]?, String)->()){
        HttpClient.shareIntance.GET(HC_FUNCTIONLIST, parameters: nil) { (result, ccb) in
            if ccb.success(){
                let dicArr = ccb.data as? [[String : Any]]
                if let dicArr = dicArr {
                    var arr = [HomeFunctionModel]()
                    for dic in dicArr {
//                        let m = HomeFunctionModel.init(dic)
                        if let m = JSONDeserializer<HomeFunctionModel>.deserializeFrom(dict: dic) {
                            arr.append(m)
                        }
                    }
                    callback(true, arr, ccb.msg)
                }else{
                    callback(false, nil, ccb.msg)
                }
            }else{
                callback(false, nil, ccb.msg)
            }
        }  
    }
    
    //第三方登录
    func HC_thirdLogin(accessToken : String, openId : String, loginType : String, appid : String, callback : @escaping (Bool, NSInteger, String)->()){
        let dic = NSDictionary.init(dictionary: ["accessToken" : accessToken, "openId" : openId, "loginType" : loginType, "appid" : appid])
        HttpClient.shareIntance.GET(HC_THIRD_LOGIN, parameters: dic) { (result, ccb) in
            
            HCPrint(message: ccb.data)
            
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    //保存phoneNumber
//                    let phone = dic["phone"] as? String
//                    if let phone = phone {
//                        HCPrint(message: "setted  phone")
//                        UserDefaults.standard.set(phone, forKey: kUserPhone)
//                    }
                    
//                    let model = HCUserModel.init(dic)
                    let model = JSONDeserializer<HCUserModel>.deserializeFrom(dict: dic)
                    UserManager.shareIntance.HCUser = model
                    UserDefaults.standard.set(dic, forKey: kUserDic)
                }
                callback(true, ccb.code, ccb.msg)
            }else{
                callback(false, ccb.code, ccb.msg)
            }
        }
    }
    
    //绑定手机号
    func HC_bindPhone(accessToken : String, openId : String, code : String, phone : String, loginType : String, appId : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["accessToken" : accessToken, "openId" : openId, "code" : code, "phone" : phone, "loginType" : loginType, "appid" : appId])
        HttpClient.shareIntance.GET(HC_THIRD_BIND, parameters: dic) { (result, ccb) in
            HCPrint(message: ccb.data)
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    //保存phoneNumber
//                    let phone = dic["phone"] as? String
//                    if let phone = phone {
//                        UserDefaults.standard.set(phone, forKey: kUserPhone)
//                    }
                    
//                    let model = HCUserModel.init(dic)
                    let model = JSONDeserializer<HCUserModel>.deserializeFrom(dict: dic)
                    UserManager.shareIntance.HCUser = model
                }
                callback(true, "绑定成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //获取生殖中心列表
    func HC_getHospitalList(lng : Double?, lat : Double?, callback : @escaping (Bool, [HospitalListModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["lng" : lng, "lat" : lat])
        HCPrint(message: "hospitalList")
        HttpClient.shareIntance.GET(HC_SORT_HOSPITAL, parameters: dic) { (result, ccb) in
            HCPrint(message: ccb.data)
            if ccb.success() {
                let dataDic = ccb.data as! [String : Any]
                let arr = dataDic["hospitalList"] as! [[String : Any]]
                var resultArr = [HospitalListModel]()
                for dic in arr {
//                    FindRealClassForDicValue(dic: dic)
//                    resultArr.append(HospitalListModel.init(dic))
                    if let m = JSONDeserializer<HospitalListModel>.deserializeFrom(dict: dic) {
                        resultArr.append(m)
                    }
                }
                callback(true, resultArr)
            }else{
                callback(false, nil)
            }
        }
    }
    
    //绑定生殖中心
    func HC_bindCard(hospitalId : NSInteger, medCard : String, idNo : String, userName : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["hospitalId" : hospitalId, "medCard" : medCard, "idNo" : idNo, "userName" : userName])
        HttpClient.shareIntance.GET(HC_BIND_CARD, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                callback(true, "")
                
                //重新获取个人信息
                self.HC_userInfo(callback: { (success, info) in
                    //
                })
            }else{
                let dic = result as! [String : Any]
                let s = dic["message"] as! String
                HCPrint(message: s)
                callback(false, s)
            }
        }
    }
    
    //解绑生殖中心
    func HC_unbind(hospitalId : NSInteger, medCard : String, idNo : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["hospitalId" : hospitalId, "medCard" : medCard, "idNo" : idNo])
        HttpClient.shareIntance.GET(HC_UNBIND, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                //移除本地数据
                UserDefaults.standard.removeObject(forKey: kBindDic)
                UserManager.shareIntance.BindedModel = nil
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
    //修改用户信息
    func HC_updateUserInfo(dic : NSDictionary, callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.GET(HC_UPDATE_USERINFO, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                callback(true, "")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //获取关注的医生列表
    func HC_attentionDocList(patientId : NSInteger, pageNum : String, callback : @escaping (Bool, _ hasNext : Bool, [DoctorAttentionModel]?, String)->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "pageNum" : pageNum, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_ATTENTION_DOCTOR_LIST, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! NSArray
                var tempArr = [DoctorAttentionModel]()
                for i in arr {
                    let tempDic = i as! [String : Any]
//                    tempArr.append(DoctorAttentionModel.init(tempDic))
                    if let m = JSONDeserializer<DoctorAttentionModel>.deserializeFrom(dict: tempDic) {
                        tempArr.append(m)
                    }
                }
                //是否有下一页
                let hasNextS = dic["hasNextPage"] as! NSNumber
                let hasNext = hasNextS.intValue == 1 ? true : false
                callback(true, hasNext, tempArr, ccb.msg)
            }else{
                callback(false, false, nil, ccb.msg)
            }
        }
    }
    
    
    //获取医生列表
    func HC_doctorList(hospitalId : NSInteger?, pageNum : String, callback : @escaping (Bool, _ hasNext : Bool, [DoctorModel]?, String)->()){
        let dic = NSDictionary.init(dictionary: ["hospitalId" : hospitalId, "pageNum" : pageNum, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_DOCTOR_LIST, parameters: dic) { (result, ccb) in
            if ccb.success(){
            
                HCPrint(message: result)
                
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! NSArray
                var tempArr = [DoctorModel]()
                for i in arr {
                    let tempDic = i as! [String : Any]
//                    FindRealClassForDicValue(dic: tempDic)
//                    tempArr.append(DoctorModel.init(tempDic))
                    if let m = JSONDeserializer<DoctorModel>.deserializeFrom(dict: tempDic) {
                        tempArr.append(m)
                    }
                }
                //是否有下一页
                let hasNextS = dic["hasNextPage"] as! NSNumber
                let hasNext = hasNextS.intValue == 1 ? true : false
                callback(true, hasNext, tempArr, ccb.msg)
            }else{
                callback(false, false, nil, ccb.msg)
            }
        }
    }
    
    
    //获取医生评价   
    func HC_doctorReview(doctorId : NSInteger, pageNum : String, callback : @escaping (Bool, _ hasNext : Bool, [CommentDocModel]?, String)->()){
        let dic = NSDictionary.init(dictionary: ["doctorId" : doctorId, "pageNum" : pageNum, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_DOCTOR_REVIEW, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! NSArray
                var tempArr = [CommentDocModel]()
                for i in arr {
                    let tempDic = i as! [String : Any]
//                    tempArr.append(CommentDocModel.init(tempDic))
                    if let m = JSONDeserializer<CommentDocModel>.deserializeFrom(dict: tempDic) {
                        tempArr.append(m)
                    }
                }
                //是否有下一页
                let hasNextS = dic["hasNextPage"] as! NSNumber
                let hasNext = hasNextS.intValue == 1 ? true : false
                callback(true, hasNext, tempArr, ccb.msg)
            }else{
                callback(false, false, nil, ccb.msg)
            }
        }
    }
    
    
    //查询患者问诊记录
    func HC_patientConsultList(patientId : NSInteger, status : String, pageNum : String, callback : @escaping (Bool, _ hasNext : Bool, [[String : Any]]?)->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "status" : status, "pageNum" : pageNum, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_PATIENT_CONSULT_LIST, parameters: dic) { (result, ccb) in

            if ccb.success() {
                let dic = ccb.data as! [String : Any]
                let dicArr = dic["list"] as! [[String : Any]]
                let hasNext = (dic["hasNextPage"] as! NSNumber).intValue == 0 ? false : true
                callback(true, hasNext, dicArr)
            }else{
                callback(false, false, nil)
            }
        }
    }
    
    //查询是否已绑定生殖中心
    func HC_checkHospitalBind(patientId : NSInteger, callback : @escaping (Bool, BindedModel?)->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId])
        HttpClient.shareIntance.GET(HC_CHECK_HOSPITAL_BIND, parameters: dic) { (result, ccb) in
        
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
                HCPrint(message: dic)
                UserDefaults.standard.setValue(dic, forKey: kBindDic)
//                let model = BindedModel.init(dic)
                let model = JSONDeserializer<BindedModel>.deserializeFrom(dict: dic)
                UserManager.shareIntance.BindedModel = model
                callback(true, model)
            }else{
                callback(false, nil)
            }
            
        }
    }
    
    
//    //添加关注的医生  未使用
    func HC_attentionDoctor(patientId : NSInteger, doctorId : NSInteger, callback : @escaping ()->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "doctorId" : doctorId])
        HttpClient.shareIntance.GET(HC_ADD_DOCTOR, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
        }
    }
    
    
    //查询已绑定的第三方平台
    func HC_checkThirdBind(patientId : NSInteger, callback : @escaping (Bool, [String]?)->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId])
        HttpClient.shareIntance.GET(HC_CHECK_THIRD_BIND, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                let arr = ccb.data as! NSArray
                var tempArr = [String]()
                for i in arr{
                    let dic = i as! [String : Any]
                    let s = dic["type"] as! String
                    tempArr.append(s)
                }
                callback(true, tempArr)
            }else{
                callback(false, nil)
            }
        }
    }
    
    
    
    
    //今日知识
    
    func HC_knowledgeList(hospitalId : NSInteger, callback : @escaping (Bool, [KnowledgeListModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["hospitalId" : hospitalId])
        HttpClient.shareIntance.GET(HC_KNOWLEDGE_LIST, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let tempArr = ccb.data as! [[String: Any]]
                var arr = [KnowledgeListModel]()
                for i in tempArr {
//                    let m = KnowledgeListModel.mj_object(withKeyValues: i)
                    if let m = JSONDeserializer<KnowledgeListModel>.deserializeFrom(dict: i) {
                        arr.append(m)
                    }
                }
                callback(true, arr)
            }else{
                callback(false, nil)
            }
        }
    }
    
    
    //知识库分类
    
    func HC_treasuryType(hospitalId : NSInteger, callback : @escaping (Bool, [TreasuryTypeModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["hospitalId" : hospitalId])
        HttpClient.shareIntance.GET(HC_TREASURY_TYPE, parameters: dic) { (result, ccb) in
            
            if ccb.success() {
                let tempArr = ccb.data as! NSArray
                var arr = [TreasuryTypeModel]()
                for i in tempArr {
                    let j = i as! [String : Any]
//                    let m = TreasuryTypeModel.init(j)
                    if let m = JSONDeserializer<TreasuryTypeModel>.deserializeFrom(dict: j) {
                        arr.append(m)
                    }
                }
                callback(true, arr)
            }else{
                callback(false, nil)
            }
        }
    }
    
    
    //知识库各类列表
    
    func HC_treasuryList(hospitalId : NSInteger, pageNum : NSInteger, pageSize : NSInteger, callback : @escaping (Bool, TreasuryListModel?)->()){
        let dic = NSDictionary.init(dictionary: ["hospitalId" : hospitalId, "pageNum" : pageNum, "pageSize" : pageSize])
        HttpClient.shareIntance.GET(HC_TREASURY_LIST, parameters: dic) { (result, ccb) in
            
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
                let m = TreasuryListModel.mj_object(withKeyValues: dic)
                callback(true, m)
            }else{
                callback(false, nil)
            }
        }
    }
    
    
        // 鼓楼医院 导航列表  拼接hospitalId
//    func HC_naviList(callback : @escaping (Bool, [PlacePositionModel]?)->()){
//        let fullurlS = HC_NAVI_LIST + String.init(format: "%d", 19)
//        HttpClient.shareIntance.GET(fullurlS, parameters: nil) { (result, ccb) in
//            if ccb.success() {
//                let arr = ccb.data as! [[String : Any]]
//                var tempArr = [PlacePositionModel]()
//                for i in arr {
//                    let m = PlacePositionModel.init(i)
//                    if m.isTop?.intValue == 1 {
//                        tempArr.append(m)
//                    }
//                }
//                callback(true, tempArr)
//            }else{
//                callback(false, nil)
//            }
//
//        }
//    }
    
    // 消息组
    func HC_messageGroup(To : String, callback : @escaping (Bool, [messageGroupModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["to" : To])
        HttpClient.shareIntance.GET(HC_MESSAGE_GROUP, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let arr = ccb.data as! [[String : Any]]
                var tempArr = [messageGroupModel]()
                for i in arr {
//                    let m = messageGroupModel.init(i)
                    if let m = JSONDeserializer<messageGroupModel>.deserializeFrom(dict: i) {
                        tempArr.append(m)
                    }
                }
                callback(true, tempArr)
            }else{
                callback(false, nil)
            }
            
        }
    }
    
    
    //消息列表
    func HC_messageList(To : String, Type : NSInteger, pageNum : NSInteger, callback : @escaping (Bool, _ hasNext : Bool, [MessageDetailModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["to" : To, "type" : Type, "pageNum" : pageNum, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_MESSAGE_LIST, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! [[String : Any]]
                let hasNext = (dic["hasNextPage"] as! NSNumber).intValue == 0 ? false : true
                var tempArr = [MessageDetailModel]()
                for i in arr {
//                    let m = MessageDetailModel.init(i)
                    if let m = JSONDeserializer<MessageDetailModel>.deserializeFrom(dict: i) {
                        tempArr.append(m)
                    }
                }
                callback(true, hasNext, tempArr)
            }else{
                callback(false, false, nil)
            }
            
        }
    }
    
    // 消息标记已读   消息ids集成，半角逗号拼接
    func HC_readMsg(notifilds : String, callback : @escaping ()->()){
        let dic = NSDictionary.init(dictionary: ["notifilds" : notifilds])
        HttpClient.shareIntance.GET(HC_READ_MSG, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
        }
    }
    
    
    
    // 删除消息
    func HC_delMsg(notifiIds : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["notifiIds" : notifiIds])
        HttpClient.shareIntance.GET(HC_DEL_MSG, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
    // 删除未支付咨询
    func HC_delConsult(consultId : NSInteger, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["consultId" : consultId])
        HttpClient.shareIntance.GET(HC_DEL_CONSULT, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
    //修改未支付咨询
    func HC_editConsult(consultId : NSInteger, content : String, imageList : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["consultId" : consultId, "content" : content, "imageList" : imageList])
        HttpClient.shareIntance.GET(HC_EDIT_CONSULT, parameters: dic) { (result, ccb) in
            if ccb.success() {
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
    //咨询评价
    func HC_reviewConsult(consultId : NSInteger, content : String, doctorId : String, count : NSInteger, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["consultId" : consultId, "content" : content, "doctorId" : doctorId, "count" : count])
        HttpClient.shareIntance.GET(HC_REVIEW_CONSULT, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                callback(true, ccb.msg)
            }else{
                callback(false, ccb.msg)
            }
        }
    }

    
    //根据name 查询医生
    func HC_findDoctorFromName(docName : String, pageNum : String, callback : @escaping (Bool, _ hasNext : Bool, [DoctorModel]?, String)->()){
        let dic = NSDictionary.init(dictionary: ["docName" : docName, "pageNum" : pageNum, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_DOCTOR_LIST, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! NSArray
                var tempArr = [DoctorModel]()
                for i in arr {
                    let tempDic = i as! [String : Any]
                    if let m = JSONDeserializer<DoctorModel>.deserializeFrom(dict: tempDic) {
                        tempArr.append(m)
                    }
                }
                //是否有下一页
                let hasNextS = dic["hasNextPage"] as! NSNumber
                let hasNext = hasNextS.intValue == 1 ? true : false
                callback(true, hasNext, tempArr, ccb.msg)
            }else{
                callback(false, false, nil, ccb.msg)
            }
        }
    }

    
    //根据id 查询医生
    func HC_findDoctorFromId(doctorId : NSInteger, callback : @escaping (Bool, [DoctorModel]?, String)->()){
        let dic = NSDictionary.init(dictionary: ["doctorId" : doctorId, "pageNum" : "1", "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_DOCTOR_LIST, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! NSArray
                var tempArr = [DoctorModel]()
                for i in arr {
                    let tempDic = i as! [String : Any]
//                    tempArr.append(DoctorModel.init(tempDic))
                    if let m = JSONDeserializer<DoctorModel>.deserializeFrom(dict: tempDic) {
                        tempArr.append(m)
                    }
                }
                callback(true, tempArr, ccb.msg)
            }else{
                callback(false, nil, ccb.msg)
            }
        }
    }
    
    //提交咨询问题
    func HC_addConsult(content : String, doctorId : NSInteger, realName : String, age : NSInteger, imageList : String, callback : @escaping (Bool, HC_consultAddModel?, String)->()){
        let dic = NSDictionary.init(dictionary: ["content" : content, "doctorId" : doctorId, "realName" : realName, "age" : age, "imageList" : imageList])
        HttpClient.shareIntance.GET(HC_ADD_CONSULT, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success() {
                let dic = ccb.data as! [String : Any]
//                let model = HC_consultAddModel.init(dic)
                let model = JSONDeserializer<HC_consultAddModel>.deserializeFrom(dict: dic)
                callback(true, model, ccb.msg)
            }else{
                callback(false, nil, ccb.msg)
            }
        }
    }
    
    
    
    //上传图片 提交问题
    func HC_uploadImgs(img : [UIImage], callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.uploadImage(USER_FILE_UPLOAD, parameters: nil, imageArr: img) { (result, ccb) in
            if ccb.success() {
                let array = ccb.data as! [[String : Any]]
                var replyPathArr = [String]()
                for i in array{
                    let uploadPath = i["path"] as! String
                    replyPathArr.append(uploadPath)
                }
                if replyPathArr.count > 1 {
                    let s = replyPathArr.joined(separator: ",")
                    callback(true, s)
                }else{
                    callback(true, replyPathArr[0])
                }
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
    //获取 BBSToken 
    func HC_getBBSToken(callback : @escaping (Bool, String)->()){
        
        let dic = NSMutableDictionary.init()
        dic["token"] = UserManager.shareIntance.HCUser?.token
        
        let bbsTokenUrl = UserManager.shareIntance.HCUserInfo?.getBbsTokenUrl
        
        guard bbsTokenUrl != nil else{
            callback(false, "没有BBSToken地址")
            return
        }
        
        HttpClient.shareIntance.GET_BBS_token(bbsTokenUrl!, parameters: dic) { (success, bbsToken) in
            if success == true{
                UserDefaults.standard.set(bbsToken, forKey: kBBSToken)
                UserManager.shareIntance.HCUserInfo?.BBSToken = bbsToken
                callback(true, "获取BBSToken成功")
            }else{
                callback(false, "获取BBSToken失败")
            }
        }
    }
    
    
    // 获取Ht5地址  keyCode
    func HC_getHrefH5URL(callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["keyCode" : "BBS_REQUEST_URL_2017"])
        HttpClient.shareIntance.GET(HC_HREF_H5, parameters: dic) { (result, ccb) in
            if ccb.success() {
                
                let dic = ccb.data as? [String : Any]
                guard dic != nil else{
                    callback(false, "数据解析失败")
                    return
                }
                
                let json = dic!["value"] as! NSString
                
                let data = json.data(using: String.Encoding.utf8.rawValue)
                let tempObj = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                guard tempObj != nil else{
                    callback(false, "数据解析异常")
                    return
                }
                
                let tempDic = tempObj as! [String : Any]
                
                let bbsFgiUrl = tempDic["bbsFgiUrl"] as! String
                UserDefaults.standard.set(bbsFgiUrl, forKey: kbbsFgiUrl)
                UserManager.shareIntance.HCUserInfo?.bbsFgiUrl = bbsFgiUrl
                
                let getBbsTokenUrl = tempDic["getBbsTokenUrl"] as! String
                UserDefaults.standard.set(getBbsTokenUrl, forKey: kgetBbsTokenUrl)
                UserManager.shareIntance.HCUserInfo?.getBbsTokenUrl = getBbsTokenUrl
                
                let findLastestTopics = tempDic["findLastestTopics"] as! String
                UserDefaults.standard.set(findLastestTopics, forKey: kfindLastestTopics)
                UserManager.shareIntance.HCUserInfo?.findLastestTopics = findLastestTopics
                
                callback(true, "成功")
            }else{
                callback(false, "失败")
            }
        }
    }
    
    func HC_findLastestTopics(callback : @escaping (Bool, [HCCircleModel]?, String)->()){
        if let findLastestTopics = UserManager.shareIntance.HCUserInfo?.findLastestTopics {
            //中一
            let dic = NSDictionary.init(dictionary: ["hospitalId" : 17])
            HttpClient.shareIntance.GET(findLastestTopics, parameters: dic, callBack: { (result, ccb) in
                if ccb.success() {
                    let dicArr = ccb.data as! [[String : Any]]
                    var modelArr = [HCCircleModel]()
                    for dic in dicArr {
                        let model = HCCircleModel.init(dic)
                        modelArr.append(model)
                    }
                    callback(true, modelArr, ccb.msg)
                }else{
                    callback(false, nil, ccb.msg)
                }
            })
        }else{
            callback(false, nil, "没有findLastestTopics地址")
        }
    }
    
    // 获取Ht5地址  keyCode
    func HC_getH5URL(keyCode : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["keyCode" : keyCode])
        HttpClient.shareIntance.GET(HC_HREF_H5, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as? [String : Any]
                guard dic != nil else{
                    callback(false, "数据解析失败")
                    return
                }
                let urlS = dic!["value"] as! String
                callback(true, urlS)
            }else{
                callback(false, "失败")
            }
        }
    }
    
    //上传更新deviceToken
    func HC_updateDeviceToken(infoDic : NSDictionary, callback : @escaping (_ success : Bool, _ message : String)->()){
        
        HttpClient.shareIntance.POST(HC_DEVICE_TOKEN, parameters: infoDic) { (result, ccb) in
            HCPrint(message: result)
            HCPrint(message: ccb.msg)
            if ccb.success() {
                callback(true, "修改成功！")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    func HC_getUpdateLock(callback : @escaping (Bool)->()){
        let dic = NSDictionary.init(dictionary: ["type" : 3])
        HttpClient.shareIntance.POST(UPDATE_LOCK, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = result as! [String : Any]
                
                guard dic["data"] != nil else {
                    callback(true)
                    return
                }
                let dataDic = dic["data"] as! [String : Any]
                let isOn = dataDic["isOn"] as! NSNumber
                if isOn.intValue == 1{
                    callback(true)
                }else{
                    callback(false)
                }
            }else{
                callback(false)
            }
        }
    }
    
    
    func HC_notice(callback : @escaping ([NoticeHomeVModel]?, String)->()){  //pageNum=1&pageSize=10
        let dic = NSDictionary.init(dictionary: ["pageNum" : 1, "pageSize" : 10])
        HttpClient.shareIntance.GET(HC_NOTICE, parameters: dic) { (result, ccb) in
//            HCPrint(message: result)
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                let arr = dic["list"] as! NSArray
                if arr.count > 0{
                    var strArr = [NoticeHomeVModel]()
                    for i in arr{
                        let j = i as! [String : Any]
//                        let m = NoticeHomeVModel.init(j)
                        if let m = JSONDeserializer<NoticeHomeVModel>.deserializeFrom(dict: j) {
                            strArr.append(m)
                        }
                    }
                    callback(strArr, "获取成功")
                }else{
                    callback(nil, "没有数据")
                }
            }else{
                callback(nil, "请求失败")
            }
        }
    }
    
    func HC_goodnews(callback : @escaping([GoodNewsModel]?, String)->()){
        HttpClient.shareIntance.GET(HC_GOODNEWS, parameters: nil) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
                let arr = dic["prosperityList"] as? NSArray
                if let arr = arr{
                    var modelArr = [GoodNewsModel]()
                    for i in arr {
                        let j = i as! [String : Any]
//                        let m = GoodNewsModel.init(j)
                        if let m = JSONDeserializer<GoodNewsModel>.deserializeFrom(dict: j) {
                            modelArr.append(m)
                        }
                    }
                    callback(modelArr, "请求成功")
                }else{
                    callback(nil, "没有数据")
                }
            }else{
                callback(nil, "请求失败")
            }
        }
    }
    
    func HC_unreadNum(callback : @escaping(UnreadModel?, String)->()){
        HttpClient.shareIntance.GET(HC_NOTREAD_NUM, parameters: nil) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.data as! [String : Any]
//                let m = UnreadModel.init(dic)
                let m = JSONDeserializer<UnreadModel>.deserializeFrom(dict: dic)
                callback(m, "请求成功")
            }else{
                callback(nil, "请求失败")
            }
        }
    }
    
    func HC_clearMsgStatus(type : NSInteger, callback : @escaping(Bool)->()){
        let dic = NSDictionary.init(dictionary: ["type" : type])
        HttpClient.shareIntance.GET(HC_CLEAR_STATUS, parameters: dic) { (result, ccb) in
            if ccb.success(){
                callback(true)
            }else{
                HCPrint(message: "清除状态失败！")
                callback(false)
            }
        }
    }
    
    
    func HC_clickCount(id : NSInteger, callback : @escaping(Bool)->()){
        let url = String.init(format: "%@%d", HC_CLICK_COUNT, id)
//        HCPrint(message: url)
        HttpClient.shareIntance.POST(url, parameters: nil) { (result, ccb) in
//            HCPrint(message: result)
            if ccb.success(){
                callback(true)
            }else{
                HCPrint(message: "点击统计失败！")
                callback(false)
            }
        }
    }
}



