//
//  AHHomeCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/23.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeCell: UITableViewCell {

    @IBOutlet weak var editorBtn: UIButton!
    
    @IBOutlet weak var timeBtn: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    var moreButtonClickedClouse: ((_ indexPath: IndexPath) -> Void)?
    
    var indexPath: IndexPath! {
        didSet {
            self.separatorLine.isHidden = (indexPath.row == 0)
        }
    }
    
    var gankModel: AHHomeGankModel! {
        didSet {
            contentLabel.text = gankModel.desc!
            contentLabel.numberOfLines = 0
            
            editorBtn.setTitle(gankModel.user, for: .normal)
            editorBtn.isHidden = (gankModel.user == nil) ? true : false
            
            timeBtn.setTitle(gankModel.publishedAt, for: .normal)
            
            moreBrn.frame = gankModel.moreBtnFrame
            moreBrn.isHidden = !gankModel.isShouldShowMoreButton
            
            // cell是否展开
            if gankModel.isOpen {
                self.contentLabel.numberOfLines = 0
                self.moreBrn.setTitle("收起", for: .normal)
            } else {
                self.contentLabel.numberOfLines = 3
                self.moreBrn.setTitle("全文", for: .normal)
            }
        }
    }
    
    lazy var moreBrn: UIButton = {
        let moreBrn = UIButton()
        moreBrn.setTitle("全文", for: .normal)
        moreBrn.setTitle("收起", for: .selected)
        moreBrn.titleLabel?.font = FontSize(size: 15)
        moreBrn.titleLabel?.textAlignment = .left
        moreBrn.setTitleColor(UIColorMainBlue, for: .normal)
        self.contentView.addSubview(moreBrn)
        moreBrn.addTarget(self, action: #selector(moreBtnClicked), for: .touchUpInside)
        return moreBrn
    }()
    
    func moreBtnClicked () {
        self.gankModel._cellH = nil
        
        if moreButtonClickedClouse != nil {
            moreButtonClickedClouse!(self.indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editorBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        timeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension AHHomeCell: ViewNameReusable {}
