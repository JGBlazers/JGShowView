//
//  DemoThreeVC.swift
//  JGShowView
//
//  Created by FCG on 2017/4/28.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class DemoThreeVC: UIViewController, JGPopupViewDelegate {
    
    deinit {
        print("DemoThreeVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let popView = JGPopupView()
        popView.delegate = self
        popView.show()
        popView.toolBarAlertTitle = "请选择贷款类型"
        
        popView.showSubView = CustomShowSubView(frame: CGRect(x: 0, y: 0, width: 0, height: 35 * 2 + 20 * 3), titleArray: ["业主贷", "车主贷", "寿险贷", "优房贷", "宅E贷"]) { (index, title) in
            popView.selectIndex = index
            popView.normalTitle = title
        }
    }
    
    // MARK: --------  JGPopupViewDelegate  --------
    func clickMormalCommitBtn(index: Int, msg: Any?) {
        
        let alertController = UIAlertController(title: "温馨提示", message: "选中的索引index == \(index)，对应索引的默认条件弹窗的标题msg == \(msg ?? "")", preferredStyle: .alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
        
        let okAction = UIAlertAction(title: "朕知道了", style: .default, handler:nil)
        alertController.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(alertController, animated: true, completion: nil)
    }

}

class CustomShowSubView: UIView {
    
    /**  按钮数组  */
    lazy var btnArray : [UIButton] = [UIButton]()
    
    /**  当前选中的按钮  */
    var currentBtn : UIButton?
    
    
    /**  回调  */
    var selectBlock: ((_ index: Int, _ title: String) -> ())?
    
    convenience init(frame: CGRect, titleArray: [String], selectBlock: @escaping ((_ index: Int, _ title: String) -> ())) {
        self.init(frame: frame)
        
        self.selectBlock = selectBlock
        
        for i in 0 ..< titleArray.count {
            
            let btn = UIButton(type: .custom)
            btn.setTitle(titleArray[i], for: .normal)
            btn.setTitleColor(UIColor.orange, for: .normal)
            btn.setTitleColor(UIColor.red, for: .selected)
            btn.tag = i
            clipBtn(btn: btn, isSelect: btn.isSelected)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            addSubview(btn)
            btnArray.append(btn)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let intevalX : CGFloat = 20
        let btnW = (frame.width - intevalX * 4) / 3
        let btnH : CGFloat = 35
        
        for i in 0 ..< btnArray.count {
            
            let countX = i % 3
            let countY = i / 3
            
            let btnX = intevalX + (intevalX + btnW) * CGFloat(countX)
            let btnY = intevalX + (intevalX + btnH) * CGFloat(countY)
            
            let btn = btnArray[i]
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        }
        
    }
    
    @objc fileprivate func btnClick(btn: UIButton) {
        selectBlock?(btn.tag, (btn.titleLabel?.text ?? ""))
        currentBtn?.isSelected = false
        clipBtn(btn: currentBtn, isSelect: currentBtn?.isSelected ?? false)
        btn.isSelected = true
        clipBtn(btn: btn, isSelect: btn.isSelected)
        currentBtn = btn
    }
    
    private func clipBtn(btn: UIView?, isSelect: Bool) {
        guard let btn = btn else {
            return
        }
        btn.layer.borderColor = (isSelect == true ? UIColor.red : UIColor.orange).cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
    }
    
}
