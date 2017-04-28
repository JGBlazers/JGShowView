//
//  DemoOneVC.swift
//  JGShowView
//
//  Created by FCG on 2017/4/28.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class DemoOneVC: UIViewController, JGPopupViewDelegate {
    
    deinit {
        print("DemoOneVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let popView = JGPopupView()
        popView.delegate = self
        popView.show()
        popView.toolBarAlertTitle = "请选择贷款类型"
        popView.subViewTitleArray = ["业主贷", "车主贷", "寿险贷", "优房贷", "宅E贷"]
    }
    
    // MARK: --------  JGPopupViewDelegate  --------
    func clickMormalCommitBtn(index: Int, msg: Any?) {
        
        let alertController = UIAlertController(title: "温馨提示", message: "选中的索引index == \(index)，对应索引的默认条件弹窗的标题msg == \(msg ?? "")", preferredStyle: .alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
        let okAction = UIAlertAction(title: "朕知道了", style: .default, handler:nil)
        alertController.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(alertController, animated: true, completion: nil)
    }

}
