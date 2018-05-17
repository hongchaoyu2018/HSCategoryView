//
//  ViewController.swift
//  HSCategoryView
//
//  Created by 洪超宇 on 2018/5/15.
//  Copyright © 2018年 superman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let categories = ["跟进状态","成交状态","客户来源","客户级别"]
    let subcategories = ["不限","客户介绍","陌生拜访","网络广告","线下广告","电话咨询"]


    // MARK:- 懒加载属性
    private lazy var lrTableView : LeftRightTableView = LeftRightTableView.lrTableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray

        
        // 初始化LRTableView
        setupLRTableView()
        

        
    }



}
// MARK:- 初始化左右TableView
extension ViewController {
    private func setupLRTableView() {
        
        // 添加tableView
        view.addSubview(lrTableView)
        
        // 设置frame
        lrTableView.frame = CGRect(x: 30, y: 100, width: view.bounds.width - 60, height: 500)
        
        // 设置左右tableview的属性
        lrTableView.datasource = self
        lrTableView.delegate = self
    
        
    }
}

// MARK:- 设置数据源
extension ViewController: LRTableViewDatasource {
    
    
    func numbersOfLeftRowsInLRTableView(lrTableView: LeftRightTableView) -> Int {
        return categories.count
    }
    
    func titleForLeftRowInLRTableView(lrTableView: LeftRightTableView, leftRow: Int) -> String {
        
        let category = categories[leftRow]
        
        return category
    }
    
    func subdataForRightRowInLRTableView(lrTableView: LeftRightTableView, leftRow: Int) -> [String]? {
      
        return subcategories
    }
    

}

// MARK:- 设置代理方法
extension ViewController: LRTableViewDelegate {
    
    func didSelectedLeftRowInLRTableView(lrtTableView: LeftRightTableView, leftRow: Int) {
        print("leftRow:---\(leftRow)")
    }
    
    func didSelectedRightRowInLRTableView(lrtTableView: LeftRightTableView, leftRow: Int, rightRow: Int) {
        print("leftRow:---\(leftRow)", "rightRow:---\(rightRow)")
    }
    
    func didSelectedConfirmButton(lrtTableView: LeftRightTableView, leftRow: Int, rightRow: Int) {
        print("leftRow:---\(leftRow)", "rightRow:---\(rightRow)")
    }
}






