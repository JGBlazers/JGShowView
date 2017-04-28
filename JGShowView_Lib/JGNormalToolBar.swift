//
//  JGNormalToolBar.swift
//  JGShowView
//
//  Created by FCG on 2017/4/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class JGNormalToolBar: UIView {
    
    // MARK: --------  属性列表  --------
    // MARK:  -- 提供给外界调用的属性
    /**  背景颜色  */
    var bgColor : UIColor = UIColor(red: 37.0/256.0, green: 45.0/256.0, blue: 54.0/256.0, alpha: 1) {
        didSet {
            backgroundColor = bgColor
        }
    }
    /**  本类所有子控件的字体颜色  */
    var titleColor : UIColor = UIColor.white {
        didSet {
            rightBtn.setTitleColor(titleColor, for: .normal)
            leftBtn.setTitleColor(titleColor, for: .normal)
            alertLabel.textColor = titleColor
        }
    }
    
    /**  中间提示标签的标题  */
    var alertTitle : String = "请选择" {
        didSet {
            alertLabel.text = alertTitle
        }
    }
    
    // MARK:  -- 只允许本类调用的属性
    /**  取消按钮  */
    fileprivate lazy var leftBtn : UIButton = {
        let leftBtn = UIButton(type: .custom)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        leftBtn.backgroundColor = .clear
        leftBtn.setTitle("取消", for: .normal)
        return leftBtn
    }()
    
    /**  确定按钮  */
    fileprivate lazy var rightBtn : UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        rightBtn.backgroundColor = .clear
        rightBtn.setTitle("确定", for: .normal)
        return rightBtn
    }()
    
    /**  提示标题标签  */
    fileprivate lazy var alertLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    /**  回调  */
    var btnClickBlock: ((_ isCommit: Bool) -> ())?
    
    
    convenience init(frame: CGRect, btnClickBlock: @escaping ((_ isCommit: Bool) -> ())) {
        self.init(frame: frame)
        backgroundColor = bgColor
        
        self.btnClickBlock = btnClickBlock
        
        // 取消按钮
        leftBtn.setTitleColor(titleColor, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        addSubview(leftBtn)
        
        // 确定按钮
        rightBtn.setTitleColor(titleColor, for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        addSubview(rightBtn)
        
        // 提示标题标签
        alertLabel.textColor = titleColor
        alertLabel.text = alertTitle
        addSubview(alertLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW : CGFloat = 60
        let btnH : CGFloat = frame.height
        
        // 取消按钮
        leftBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: btnH)
        
        // 确定按钮
        rightBtn.frame = CGRect(x: frame.width - btnW, y: 0, width: btnW, height: btnH)
        
        // 提示标题标签
        alertLabel.frame = CGRect(x: leftBtn.frame.maxX, y: 0, width: frame.width - 2 * btnW, height: btnH)
    }
    
    

}

// MARK: --------  监听事件  --------
extension JGNormalToolBar {
    
    @objc fileprivate func leftBtnClick() {
        self.btnClickBlock?(false)
    }
    
    @objc fileprivate func rightBtnClick() {
        self.btnClickBlock?(true)
    }
}
