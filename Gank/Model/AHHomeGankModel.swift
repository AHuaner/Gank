//
//  AHHomeGankModel.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AHHomeGankModel: NSObject, NSCoding{
    fileprivate var separatorLineH: CGFloat = 1
    
    fileprivate var editorLabelH: CGFloat = 15
    
    var id: String?
    
    var publishedAt: String?
    
    var desc: String?
    
    var url: String?
    
    var user: String?
    
    var type: String?
    
    var isShouldShowMoreButton: Bool = false
    
    var moreBtnFrame: CGRect = CGRect.zero
    
    var isOpen: Bool = false
    
    var _cellH: CGFloat?
    // cell的整体高度
    var cellH: CGFloat {
        if _cellH == nil {
            
            _cellH = separatorLineH + editorLabelH + 5
            
            // 文字的高度
            let maxSize = CGSize(width: cellMaxWidth, height: CGFloat(MAXFLOAT))
            let descTextH = desc?.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)], context: nil).size.height
            
            var contentTextH: CGFloat = descTextH!
            
            // 文字大于三行
            if descTextH! > UIFont.systemFont(ofSize: 14).lineHeight * 3 {
                contentTextH = UIFont.systemFont(ofSize: 14).lineHeight * 3
                isShouldShowMoreButton = true
            }
            
            if isOpen {
                contentTextH = descTextH!
            }
            
            _cellH = _cellH! + 5 + contentTextH
            
            if isShouldShowMoreButton {
                let moreBtnX = cellMargin * 0.5
                let moreBtnY = _cellH!
                let moreBtnW: CGFloat = 40.0
                let moreBtnH: CGFloat = 20.0
                self.moreBtnFrame = CGRect(x: moreBtnX, y: moreBtnY, width: moreBtnW, height: moreBtnH)
                
                _cellH = _cellH! + moreBtnH
            }
            
            _cellH = _cellH! + cellMargin
        }
        return _cellH!
    }
    
    init(dict: JSON) {
        super.init()
        for (index, subJson) : (String, JSON) in dict {
            switch index {
            case _idKey:
                self.id = subJson.string
            case descKey:
                self.desc = subJson.string
            case publishedAtKey:
                self.publishedAt = subJson.string
            case urlKey:
                self.url = subJson.string
            case typeKey:
                self.type = subJson.string
            case userKey:
                self.user = subJson.string
            default: break
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.publishedAt = aDecoder.decodeObject(forKey: "publishedAt") as? String
        self.desc = aDecoder.decodeObject(forKey: "desc") as? String
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        self.user = aDecoder.decodeObject(forKey: "user") as? String
        self.type = aDecoder.decodeObject(forKey: "type") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(publishedAt, forKey: "publishedAt")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(type, forKey: "type")
    }
}
