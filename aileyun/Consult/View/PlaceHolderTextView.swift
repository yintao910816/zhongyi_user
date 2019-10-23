//
//  PlaceHolderTextView.swift
//  aileyun
//
//  Created by huchuang on 2017/7/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class PlaceHolderTextView: UITextView {

    var placeholdS : String?{
        didSet{
            let size = HCGetSize(content: (placeholdS! as NSString), maxWidth: self.frame.size.width, font: UIFont.init(name: kReguleFont, size: textFont)!)
            let tempRect = placeholdL.frame
            placeholdL.frame = CGRect.init(x: 3, y: 0, width: tempRect.size.width, height: size.height + 20)
            placeholdL.text = placeholdS
        }
    }
    
    var textFont : CGFloat = 14
    
    lazy var placeholdL : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.init(red: 199/255.0, green: 199/255.0, blue: 205/255.0, alpha: 1)
        l.numberOfLines = 0
        return l
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.addSubview(placeholdL)
        placeholdL.font = UIFont.init(name: kReguleFont, size: textFont)
        placeholdL.frame = self.bounds
        
        self.contentInset = UIEdgeInsets.init(top: 0, left: -3, bottom: 0, right: 0)
        
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension PlaceHolderTextView : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != ""{
            placeholdL.isHidden = true
        }else{
            placeholdL.isHidden = false
        }
    }
    
}

