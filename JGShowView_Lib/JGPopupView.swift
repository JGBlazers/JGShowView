//
//  JGPopupView.swift
//  JGShowView
//
//  Created by FCG on 2017/4/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

@objc protocol JGPopupViewDelegate {
    /// 点击默认工具栏确定按钮
    @objc optional func clickMormalCommitBtn(index: Int, msg: Any?)
}

enum JGLayoutStyle : Int {
    case toolBarInTop       = 0     // 默认工具条在上方
    case toolBarInBottom    = 1     // 工具条在下方
}

class JGPopupView: UIView {

    // MARK: --------  属性列表  --------
    
    /**  代理  */
    weak var delegate: JGPopupViewDelegate?
    
    // MARK: --------  提供给外界可选的属性  --------
    /**  背景颜色  */
    var bgColor : UIColor = UIColor.init(white: 0, alpha: 0.5) {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    /**  工具栏的高度  默认40  */
    var toolBarHeight : CGFloat = 50 {
        didSet {
            reSetShowBgViewFrame()
        }
    }
    
    /**  弹出的条件选择View的高度  默认200  */
    var subViewHeight : CGFloat = 200 {
        didSet {
            reSetShowBgViewFrame()
        }
    }
    
    /**  承接弹窗视图内容的背景View  如果本类的条件View无法满足需要，就自己创建一个View出来赋值给showSubView即可  */
    var showSubView : UIView? {
        didSet {
            
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let showSubView = showSubView {
                subViewHeight = showSubView.frame.height != 0 ? showSubView.frame.height : subViewHeight
                showBgView.addSubview(showSubView)
            }
        }
    }
    
    /**  工具栏  如果本类的工具栏满足需要，就自己创建一个View出来赋值给showSubView即可  */
    var toolBar : UIView? {
        didSet {
            
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let toolBar = toolBar {
                toolBarHeight = toolBar.frame.height != 0 ? toolBar.frame.height : toolBarHeight
                showBgView.addSubview(toolBar)
            }
        }
    }
    
    var toolBarStyle : JGLayoutStyle = .toolBarInTop {
        didSet {
            reSetShowBgViewFrame()
        }
    }
    
    
    // ------ begin -------  默认ToolBar向外提供以便修改的属性列表  ------ begin -------
    /**  背景颜色  */
    var toolBarBgColor : UIColor? {
        didSet {
            if let toolBarBgColor = toolBarBgColor {
                let toolBar = self.toolBar as? JGNormalToolBar
                toolBar?.bgColor = toolBarBgColor
            }
        }
    }
    /**  本类所有子控件的字体颜色  */
    var toolBarTitleColor : UIColor? {
        didSet {
            if let toolBarTitleColor = toolBarTitleColor {
                let toolBar = self.toolBar as? JGNormalToolBar
                toolBar?.titleColor = toolBarTitleColor
            }
        }
    }
    
    /**  中间提示标签的标题  */
    var toolBarAlertTitle : String? {
        didSet {
            if let toolBarAlertTitle = toolBarAlertTitle {
                let toolBar = self.toolBar as? JGNormalToolBar
                toolBar?.alertTitle = toolBarAlertTitle
            }
        }
    }
    // ------ end -------  默认ToolBar向外提供以便修改的属性列表  ------ end -------
    
    
    // ------ begin -------  默认 条件选择View 向外提供以便修改的属性列表  ------ begin -------
    var subViewTitleArray : [String]? {
        didSet {
            if subViewTitleArray != nil {
                let subView = self.showSubView as? JGNormalSubView
                subView?.titleArray = subViewTitleArray!
            }
        }
    }
    
    // ------ end -------  默认 条件选择View向外提供以便修改的属性列表  ------ end -------
    
    
    /**  承接弹窗视图内容的背景View  */
    fileprivate lazy var showBgView: UIView = UIView()
    
    /**  窗口  */
    fileprivate let app_window = UIApplication.shared.keyWindow!
    
    /**  是否已经弹出弹窗  */
    fileprivate var isShow : Bool = false
    
    /**  在默认的条件表单中的标题  */
    var normalTitle : String = ""
    /**  选中的索引  */
    var selectIndex : Int = -1
    
    /**
     初始化方法
     */
    class func sharePopupView() -> JGPopupView {
        return JGPopupView(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        let rect = (UIApplication.shared.keyWindow?.bounds)!
        super.init(frame: rect)
        
        // 创建、配置本类UI
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: --------  创建、配置本类UI  --------
extension JGPopupView {
    
    fileprivate func createUI() {
        
        // 弹出的窗口的背景View
        showBgView.backgroundColor = .white
        showBgView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: subViewHeight + toolBarHeight)
        addSubview(showBgView)
        
        // 初始化一个默认的ToolBar
        let normalToolBar = JGNormalToolBar(frame: CGRect(x: 0, y: 0, width: showBgView.frame.width, height: toolBarHeight)) { [unowned self] (isCommit) in
            self.finish()
            if isCommit {
                self.delegate?.clickMormalCommitBtn?(index: self.selectIndex, msg: self.normalTitle)
            }
        }
        showBgView.addSubview(normalToolBar)
        toolBar = normalToolBar
        
        // 初始化一个默认的条件选择View
        let normalSubView = JGNormalSubView(frame: CGRect.zero) { [unowned self] (index, title) in
            self.selectIndex = index
            self.normalTitle = title
        }
        showBgView.addSubview(normalSubView)
        showSubView = normalSubView
    }
}

// MARK: --------  弹出和下落 动画相关  --------
extension JGPopupView {
    
    /**
     重新配置  弹出的View和该View的子控件的frame
     */
    fileprivate func reSetShowBgViewFrame() {
        
        toolBar?.frame = CGRect(x: 0, y: (toolBarStyle == .toolBarInTop ? 0 : subViewHeight), width: frame.width, height: toolBarHeight)
        showSubView?.frame = CGRect(x: 0, y: (toolBarStyle == .toolBarInBottom ? 0 : toolBarHeight), width: frame.width, height: subViewHeight)
        
        self.backgroundColor = isShow == true ? UIColor.init(white: 0, alpha: 0) : self.bgColor
        UIView.animate(withDuration: 0.25, animations: {
            
            self.backgroundColor = self.isShow == false ? UIColor.init(white: 0, alpha: 0) : self.bgColor
            
            let showBgViewH = self.subViewHeight + self.toolBarHeight
            self.showBgView.frame.size.height = showBgViewH
            self.showBgView.frame.origin.y = self.isShow == false ? self.bounds.height : (self.bounds.height - showBgViewH)
            
        }, completion: { (_) in
            if self.isShow == false {
                for view in (self.app_window.subviews) {
                    if view == self {
                        self.toolBar?.removeFromSuperview()
                        self.showSubView?.removeFromSuperview()
                        self.showBgView.removeFromSuperview()
                        view.removeFromSuperview()
                    }
                }
            }
        })
        
    }
    
    // MARK: --------  弹出弹窗  --------
    func show() {
        isShow = true
        app_window.addSubview(self)
        reSetShowBgViewFrame()
    }
    
    // MARK: --------  弹窗完成了他的使命  --------
    func finish() {
        self.isShow = false
        reSetShowBgViewFrame()
    }
    
    // MARK: --------  点击空白消失  --------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1. 获取当前触摸的点
        let touch = (touches as NSSet).anyObject() as! UITouch
        let loc = touch.location(in: self)
        if !showBgView.frame.contains(loc) {
            finish()
        }
    }
}
