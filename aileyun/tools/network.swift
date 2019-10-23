//
//  network.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation


let HTTP_ROOT_URL = "https://www.ivfcn.com"

//let HTTP_ROOT_URL = "http://192.168.0.109:8084"

let IMAGE_URL = "https://www.ivfcn.com"



let HTTP_HOST_URL = HTTP_ROOT_URL.appending("/app/")

let HTTP_RESULT_SERVER_ERROR = "服务器出错！"
let HTTP_RESULT_NETWORK_ERROR = "网络出错，请检查网络连接！"

// 登录
let USER_LOGIN_URL = HTTP_HOST_URL + "patient/login.do"
//咨询列表详情
let PATIENT_CONSULT_CONSULTLIST = HTTP_HOST_URL + "patient/consult/consultList.do"
//医生详情评论
let PATIENT_CONSULT_GETREVIEW = HTTP_HOST_URL + "patient/consult/getReview.do"
//医生列表
let PATIENT_CONSULT_GETDOCTORLIST = HTTP_HOST_URL + "patient/consult/getDoctorList.do"
//提交问题上传图片
let COMMON_UPLOADIMAGE = HTTP_HOST_URL + "patient/consult/consult.do"
//获取评价
let PATIENT_CONSULT_GETEVALUATION = HTTP_HOST_URL + "patient/consult/getEvaluation.do"
//提交评价
let PATIENT_CONSULT_EVALUATIONdOCTOR = HTTP_HOST_URL + "patient/consult/evaluationDoctor.do"


//喜报
let GOOD_NEWS_URL = HTTP_HOST_URL + "patient/getGoodNews.do"


//上传更新deviceToken
let HC_DEVICE_TOKEN = HTTP_HOST_URL + "patient/updateDeviceToken.do"


// 上传图片
let USER_FILE_UPLOAD = HTTP_HOST_URL + "attach/upload.do"

//查询是否打开更新提示
let UPDATE_LOCK = HTTP_HOST_URL + "common/validateVersionInfo.do"








//支付宝
//let REQEST_GET_ALIPAY_CHARGE = HTTP_HOST_URL + "aliPay/getAlyCharge.do"    http://alyapp.tunnel.echomod.cn/app/aliPay/getAlyCharge.do
let REQEST_GET_ALIPAY_CHARGE = "http://www.ivfcn.com/app/aliPay/getAlyCharge.do"
//微信支付接口
let REQEST_GET_PREPAY_ID = HTTP_HOST_URL + "weixinPay/getAlyPerPayId.do"
//支付宝结果查询
//let CHECK_ALIPAY = HTTP_HOST_URL + "aliPay/getPayResult.do"
let CHECK_ALIPAY = "http://www.ivfcn.com/app/aliPay/getPayResult.do"
//微信支付结果
let CHECK_WEIXIN = HTTP_HOST_URL + "weixinPay/getPayResult.do"






// 论坛地址
let RECOMMEND_URL = "/view/recommend.html"
let GROUP_URL = "/view/forumCircle.html"

let ARTICLE_URL = "/view/myTopic.html"
let ATTENTION_URL = "/view/focusedForumCircleList.html"
let REPLY_URL = "/view/myReply.html"

let COLLECT_URL = "/view/collectionTopic.html"
let GROUP_DETAIL_URL = "/view/postTopicDetails.html"







// 单张图片上传
let HC_CE_URL = "http://file.ivfcn.com"

let UPLOAD_SINGLE_IMAGE = HC_CE_URL + "/common-file/api/fileUpload/singleImg"












//app请求地址
let HC_ROOT_URL = "http://app.ivfcn.com"


//let HC_ROOT_URL = "http://appa.tunnel.echomod.cn"


//let HC_ROOT_URL = "http://192.168.0.109:8084"




let HC_HOST_URL = HC_ROOT_URL.appending("/patient-api/")

//用户登录  get
let HC_LOGIN = HC_HOST_URL + "api/patient/login"

//用户注册 get
let HC_REGISTER = HC_HOST_URL + "api/patient/register"

//用户注销 get
let HC_LOGOUT = HC_HOST_URL + "api/patient/loginOut"

//找回密码 get
let HC_FINDPWD = HC_HOST_URL + "api/patient/findPwd"

//验证码 get
let HC_VALIDATECODE = HC_HOST_URL + "api/patient/validateCode"

//校验验证码 get
let HC_VALIDATE = HC_HOST_URL + "api/patient/validate"

//用户信息 get
let HC_USERINFO = HC_HOST_URL + "api/patient/findInfo"

//banner
let HC_BANNER = HC_HOST_URL + "api/patient/index/bannerList"

//首页功能导航
let HC_FUNCTIONLIST = HC_HOST_URL + "api/patient/index/functionList"

// 第三方登录
let HC_THIRD_LOGIN = HC_HOST_URL + "api/patient/oauthLogin"

//信息绑定
let HC_THIRD_BIND = HC_HOST_URL + "api/patient/oauthBind"

//根据当前位置排序生殖中心
let HC_SORT_HOSPITAL = HC_HOST_URL + "api/patient/hospital/sortList"

//绑定生殖中心
let HC_BIND_CARD = HC_HOST_URL + "api/patient/hospital/bindCard"

//解绑生殖中心
let HC_UNBIND = HC_HOST_URL + "api/patient/hospital/unBindCard"

//更新用户信息
let HC_UPDATE_USERINFO = HC_HOST_URL + "api/patient/updateInfo"

//获取关注的医生列表
let HC_ATTENTION_DOCTOR_LIST = HC_HOST_URL + "api/patient/attentionDoctorList"

//获取医生列表
let HC_DOCTOR_LIST = HC_HOST_URL + "api/patient/consult/doctorList"

//获取医生评价
let HC_DOCTOR_REVIEW = HC_HOST_URL + "api/patient/consult/doctorReviewList"

//查询患者问诊记录
let HC_PATIENT_CONSULT_LIST = HC_HOST_URL + "api/patient/consult/patientConsultList"

//查询是否已绑定生殖中心
let HC_CHECK_HOSPITAL_BIND = HC_HOST_URL + "api/patient/hospital/hospitalBind"

//添加关注的医生
let HC_ADD_DOCTOR = HC_HOST_URL + "api/patient/attentionDoctorAdd"

//查询已绑定的第三方平台
let HC_CHECK_THIRD_BIND = HC_HOST_URL + "api/patient/groupPatientOauth"

//今日知识
let HC_KNOWLEDGE_LIST = HC_HOST_URL + "api/patient/wechat/KnowledgeTypeList"

//知识库分类
let HC_TREASURY_TYPE = HC_HOST_URL + "api/patient/wechat/KnowledgeType"

//知识库各类列表
let HC_TREASURY_LIST = HC_HOST_URL + "api/patient/wechat/findKnowledgeList"

// 导航列表  拼接hospitalId
let HC_NAVI_LIST = HC_HOST_URL + "api/patient/hospital/hospitalNavigation/"

// 消息组
let HC_MESSAGE_GROUP = HC_HOST_URL + "api/patient/me/appMessageList"

//消息列表
let HC_MESSAGE_LIST = HC_HOST_URL + "api/patient/me/MessageDetailList"

// 消息标记已读
let HC_READ_MSG = HC_HOST_URL + "api/patient/me/readMessage"

// 删除消息
let HC_DEL_MSG = HC_HOST_URL + "api/patient/me/delMessage"

// 删除未支付咨询
let HC_DEL_CONSULT = HC_HOST_URL + "api/patient/consult/patientConsultDel"

//修改未支付咨询
let HC_EDIT_CONSULT = HC_HOST_URL + "api/patient/consult/patientConsultEdit"

//咨询评价
let HC_REVIEW_CONSULT = HC_HOST_URL + "api/patient/consult/patientReviewAdd"

//提交咨询问题
let HC_ADD_CONSULT = HC_HOST_URL + "api/patient/consult/patientConsultAdd"

//论坛H5界面地址  keyCode
let HC_HREF_H5 = HC_HOST_URL + "api/patient/index/hrefH5"

//喜报
let HC_GOODNEWS = HC_HOST_URL + "api/patient/index/prosperity"

// 消息未读数量
let HC_NOTREAD_NUM = HC_HOST_URL + "api/patient/me/getUnReadNum"

//清除未读状态
let HC_CLEAR_STATUS = HC_HOST_URL + "api/patient/me/readMessageByType"

//点击统计
let HC_CLICK_COUNT = HC_HOST_URL + "api/patient/sysApplication/addClickCount/"

//首页公告
let HC_NOTICE = HC_HOST_URL + "api/patient/index/noticeCom"


