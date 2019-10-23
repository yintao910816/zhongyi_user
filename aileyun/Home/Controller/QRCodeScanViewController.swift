//
//  QRCodeScanViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/10/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import AVKit

class QRCodeScanViewController: BaseViewController {
    
    lazy var containerV : UIView = {
        let c = UIView.init(frame: CGRect.init(x: (SCREEN_WIDTH - 300) / 2, y: (SCREEN_HEIGHT - 380) / 2, width: 300, height: 300))
        
        let img = UIImage.init(named: "qrcode_border")
        let borderimg = img?.stretchableImage(withLeftCapWidth: Int((img?.size.width)!) / 2, topCapHeight: Int((img?.size.height)!) / 2)
        let imgV = UIImageView.init(image: borderimg)
        imgV.frame = c.bounds
        c.addSubview(imgV)
        
        return c
    }()
    
    lazy var scanImgV : UIImageView = {
        let s = UIImageView.init(image: UIImage.init(named: "qrcode_scan"))
        return s
    }()
    
    lazy var input : AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let i = try? AVCaptureDeviceInput.init(device: device)
        return i
    }()
    
    lazy var output : AVCaptureMetadataOutput = {
        let o = AVCaptureMetadataOutput.init()
        return o
    }()
    
    lazy var session : AVCaptureSession = {
        let s = AVCaptureSession.init()
        s.sessionPreset = AVCaptureSessionPresetHigh
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        notNeedSeparateV()

        self.navigationItem.title = "扫一扫"
        
        initUI()
        prepareForScan()
        startScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !session.isRunning{
            session.startRunning()
        }
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
    }
   
    
    func initUI(){
        self.view.addSubview(containerV)
        scanImgV.frame = containerV.bounds
        containerV.addSubview(scanImgV)
        
        let infoL = UILabel.init()
        infoL.text = "请将二维码放入框内扫描"
        infoL.font = UIFont.init(name: kReguleFont, size: 16)
        infoL.textColor = UIColor.white
        
        self.view.addSubview(infoL)
        infoL.snp.updateConstraints { (make) in
            make.top.equalTo(containerV.snp.bottom).offset(20)
            make.centerX.equalTo(containerV)
            make.height.equalTo(20)
        }
    }
    
    func prepareForScan(){
        let viewRect = self.view.frame
        let containerRect = containerV.frame
        
        let x = containerRect.origin.y / viewRect.size.height
        let y = containerRect.origin.x / viewRect.size.width
        let width = containerRect.size.height / viewRect.size.height
        let height = containerRect.size.width / viewRect.size.width
        
        output.rectOfInterest = CGRect.init(x: x, y: y, width: width, height: height)
    }
    
    func startScan(){
        guard session.canAddInput(input) else {
            HCShowError(info: "未能获取摄像头")
            return
        }
        session.addInput(input)
        
        guard session.canAddOutput(output) else {
            return
        }
        session.addOutput(output)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.global())
        
        let previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(previewLayer!, at: 0)
        
        session.startRunning()
    }
    
    func isURL(content : String?){
        guard let s = content else{
            HCPrint(message: content)
            HCShowError(info: "二维码无效")
            self.navigationController?.popViewController(animated: true)
            return
        }
        let urlRegex = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        let predt = NSPredicate.init(format: "SELF MATCHES %@", urlRegex)
        if predt.evaluate(with:s){
            let webVC = WebViewController()
            webVC.url = s
            self.navigationController?.pushViewController(webVC, animated: true)
        }else{
            HCShowError(info: "二维码无效")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func startAnimation(){
        scanImgV.frame = CGRect.init(x: 0, y: 0, width: 300, height: 0)
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2) {[weak self]()in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self?.scanImgV.frame = CGRect.init(x: 0, y: 0, width: 300, height: 300)
            self?.view.layoutIfNeeded()
        }
    }
}

extension QRCodeScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let any = metadataObjects.last else{return}
        session.stopRunning()
        
        let obj = any as AnyObject
        
        DispatchQueue.main.async {
            self.isURL(content: obj.stringValue)
        }
        
    }
}
