//
//  DemoTwoVC.swift
//  JGShowView
//
//  Created by FCG on 2017/4/28.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class DemoTwoVC: UIViewController {
    
    deinit {
        print("DemoTwoVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let popView = JGPopupView()
        popView.show()
        popView.toolBarAlertTitle = "请选择贷款类型"
        popView.subViewTitleArray = ["业主贷", "车主贷", "寿险贷", "优房贷", "宅E贷"]
        
        popView.toolBarStyle = .toolBarInBottom
        popView.toolBar = CustomToolBar(frame: CGRect.zero) { [unowned self] in
            
            // 自己关闭弹窗容器
            popView.finish()
            
            let alertController = UIAlertController(title: "温馨提示", message: "选中的索引index == \(popView.selectIndex)，对应索引的默认条件弹窗的标题msg == \(popView.normalTitle)", preferredStyle: .alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
            
            let okAction = UIAlertAction(title: "朕知道了", style: .default, handler:nil)
            alertController.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
            self.present(alertController, animated: true, completion: nil)
        }
    }

}


class CustomToolBar: UIView {
    
    
    /**  确定按钮  */
    fileprivate lazy var commitBtn : UIButton = {
        let commitBtn = UIButton(type: .custom)
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        commitBtn.backgroundColor = .clear
        commitBtn.setTitle("确定", for: .normal)
        return commitBtn
    }()
    
    /**  回调  */
    var callBack: (() -> ())?
    
    convenience init(frame: CGRect, callBack: @escaping (() -> ())) {
        self.init(frame: frame)
        self.callBack = callBack
        backgroundColor = .black
        // 取消按钮
        commitBtn.setTitleColor(.white, for: .normal)
        commitBtn.addTarget(self, action: #selector(commitBtnClick), for: .touchUpInside)
        addSubview(commitBtn)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commitBtn.frame = bounds
    }
    
    @objc private func commitBtnClick() {
        callBack?()
    }
    
}
