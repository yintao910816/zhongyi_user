//
//  HC_consultViewmodel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/25.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HC_consultViewmodel: NSObject {
    var bubbleF : CGRect?
    var headIVF : CGRect?
    var timeF : CGRect?
    
    var wordsF : CGRect?
    var picF : CGRect?
    var voiceF : CGRect?
    
    var cellHeight : CGFloat?
    
    var model : HC_consultCellModel? {
        didSet{
            
            let cellMargin : CGFloat = 10
            let cellPadding : CGFloat = 20
            let headToBubble : CGFloat = 10
            let headWidth : CGFloat = 40
            let bubblePadding : CGFloat = 10
            let wordMaxW = SCREEN_WIDTH - headWidth - 100
            let timeMargin : CGFloat = 15
            let timeH : CGFloat = 15
            
            
            if model?.isDoctor == "0"{//自己的消息
                if model?.type == TypeText{
                    let tempWordSize = HCGetSize(content: model?.content as! NSString, maxWidth: wordMaxW, font: UIFont.init(name: kReguleFont, size: 14)!)
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    var bubbleSize : CGSize
                    if tempWordSize.width > tempTimeSize.width{
                        bubbleSize = CGSize.init(width: tempWordSize.width + bubblePadding * 2, height: tempWordSize.height + bubblePadding * 2 + timeMargin + timeH)
                    }else{
                        bubbleSize = CGSize.init(width: tempTimeSize.width + bubblePadding * 2, height: tempWordSize.height + bubblePadding * 2 + timeMargin + timeH)
                    }
                    headIVF = CGRect.init(x: cellPadding, y: cellMargin, width: headWidth, height: headWidth)
                    bubbleF = CGRect.init(x: cellPadding + headWidth + headToBubble, y: cellMargin, width: bubbleSize.width, height: bubbleSize.height)
                    wordsF = CGRect.init(x: cellPadding + headWidth + headToBubble + bubblePadding, y: cellMargin + bubblePadding, width: tempWordSize.width + 2, height: tempWordSize.height + 2)
                    
                    timeF = CGRect.init(x: cellPadding + headWidth + headToBubble + bubblePadding, y: cellMargin + bubblePadding + tempWordSize.height + timeMargin, width: tempTimeSize.width + 5, height: timeH)
                    
                    cellHeight = (bubbleF?.maxY)! + cellMargin
                    
                }else if model?.type == TypePic{
                    let bubbleSize = CGSize.init(width: 150 + bubblePadding * 2, height: 150 + timeMargin + timeH + bubblePadding * 2)
                    headIVF = CGRect.init(x: cellPadding, y: cellMargin, width: headWidth, height: headWidth)
                    bubbleF = CGRect.init(x: cellPadding + headWidth + headToBubble, y: cellMargin, width: bubbleSize.width, height: bubbleSize.height)
                    picF = CGRect.init(x: cellPadding + headWidth + headToBubble + bubblePadding, y: cellMargin + bubblePadding, width: 150, height: 150)
                    
                    timeF = CGRect.init(x: cellPadding + headWidth + headToBubble + bubblePadding, y: cellMargin + bubblePadding + 150 + timeMargin, width: bubbleSize.width - bubblePadding * 2, height: timeH)
                    
                    cellHeight = (bubbleF?.maxY)! + cellMargin
                    
                }else if model?.type == TypeVoice{
                    let bubbleSize = CGSize.init(width: 150 + bubblePadding * 2, height: 30 + timeMargin + timeH + bubblePadding * 2)
                    headIVF = CGRect.init(x: cellPadding, y: cellMargin, width: headWidth, height: headWidth)
                    bubbleF = CGRect.init(x: cellPadding + headWidth + headToBubble, y: cellMargin, width: bubbleSize.width, height: bubbleSize.height)
                    voiceF = CGRect.init(x: cellPadding + headWidth + headToBubble + bubblePadding, y: cellMargin + bubblePadding, width: 150, height: 30)
                    
                    timeF = CGRect.init(x: cellPadding + headWidth + headToBubble + bubblePadding, y: cellMargin + bubblePadding + 30 + timeMargin, width: 150, height: timeH)
                    
                    cellHeight = (bubbleF?.maxY)! + cellMargin
                }
                
            }else{//来自医生的消息
                let headX = SCREEN_WIDTH - cellPadding - headWidth
                if model?.type == TypeText {
                    let tempWordSize = HCGetSize(content: model?.content as! NSString, maxWidth: wordMaxW, font: UIFont.init(name: kReguleFont, size: 14)!)
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    var bubbleSize : CGSize
                    if tempWordSize.width > tempTimeSize.width{
                        bubbleSize = CGSize.init(width: tempWordSize.width + bubblePadding * 2, height: tempWordSize.height + bubblePadding * 2 + timeMargin + timeH)
                    }else{
                        bubbleSize = CGSize.init(width: tempTimeSize.width + bubblePadding * 2, height: tempWordSize.height + bubblePadding * 2 + timeMargin + timeH)
                    }
                    headIVF = CGRect.init(x: headX, y: cellMargin, width: headWidth, height: headWidth)
                    bubbleF = CGRect.init(x: headX - headToBubble - bubbleSize.width, y: cellMargin, width: bubbleSize.width, height: bubbleSize.height)
                    wordsF = CGRect.init(x: headX - headToBubble - bubbleSize.width + bubblePadding, y: cellMargin + bubblePadding, width: tempWordSize.width + 2, height: tempWordSize.height + 2)
                    
                    timeF = CGRect.init(x: headX - headToBubble - bubbleSize.width + bubblePadding, y: cellMargin + bubblePadding + tempWordSize.height + timeMargin, width: tempTimeSize.width + 5, height: timeH)
                    
                    cellHeight = (bubbleF?.maxY)! + cellMargin
                    
                }else if model?.type == TypePic{
                    let bubbleSize = CGSize.init(width: 150 + bubblePadding * 2, height: 150 + timeMargin + timeH + bubblePadding * 2)
                    headIVF = CGRect.init(x: headX, y: cellMargin, width: headWidth, height: headWidth)
                    bubbleF = CGRect.init(x: headX - headToBubble - bubbleSize.width, y: cellMargin, width: bubbleSize.width, height: bubbleSize.height)
                    picF = CGRect.init(x: headX - headToBubble - bubbleSize.width + bubblePadding, y: cellMargin + bubblePadding, width: 150, height: 150)
                    
                    timeF = CGRect.init(x: headX - headToBubble - bubbleSize.width + bubblePadding, y: cellMargin + bubblePadding + 150 + timeMargin, width: 150, height: timeH)
                    
                    cellHeight = (bubbleF?.maxY)! + cellMargin
                }else if model?.type == TypeVoice{
                    let bubbleSize = CGSize.init(width: 150 + bubblePadding * 2, height: 30 + timeMargin + timeH + bubblePadding * 2)
                    headIVF = CGRect.init(x: headX, y: cellMargin, width: headWidth, height: headWidth)
                    bubbleF = CGRect.init(x: headX - headToBubble - bubbleSize.width, y: cellMargin, width: bubbleSize.width, height: bubbleSize.height)
                    voiceF = CGRect.init(x: headX - headToBubble - bubbleSize.width + bubblePadding, y: cellMargin + bubblePadding, width: 150, height: 30)
                    
                    timeF = CGRect.init(x: headX - headToBubble - bubbleSize.width + bubblePadding, y: cellMargin + bubblePadding + 30 + timeMargin, width: 150, height: timeH)
                    
                    cellHeight = (bubbleF?.maxY)! + cellMargin
                }
            }
        }
    }
    
}
