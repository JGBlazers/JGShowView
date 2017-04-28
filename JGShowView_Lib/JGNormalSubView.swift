//
//  JGNormalSubView.swift
//  JGShowView
//
//  Created by FCG on 2017/4/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class JGNormalSubView: UIView {
    
    // MARK: --  内部使用的属性
    /**  表  */
    lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: .plain)
    }()
    
    /**  选中了哪行  */
    var selectIndex : Int = -1
    
    /**  条件数组  */
    var titleArray : [String] = [String]() {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    /**  回调  */
    var selectBlock: ((_ index: Int, _ title: String) -> ())?
    

    convenience init(frame: CGRect, selectBlock: @escaping ((_ index: Int, _ title: String) -> ())) {
        self.init(frame: frame)
        
        self.selectBlock = selectBlock
        
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }

}

// MARK: --------  表UITableView的数据源DataSource和代理Delegate方法  --------
extension JGNormalSubView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "CELL"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
            cell?.selectionStyle = .none
        }
        
        if selectIndex == indexPath.row {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell?.textLabel?.text = titleArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row
        tableView.reloadData()
        selectBlock?(indexPath.row, titleArray[indexPath.row])
    }
}
