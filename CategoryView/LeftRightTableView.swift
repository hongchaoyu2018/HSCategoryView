//
//  LeftRightTableView.swift
//  HSCategoryView
//
//  Created by 洪超宇 on 2018/5/15.
//  Copyright © 2018年 superman. All rights reserved.
//

import UIKit

@objc protocol LRTableViewDatasource : class {
    
    func numbersOfLeftRowsInLRTableView(lrTableView : LeftRightTableView) -> Int
    func titleForLeftRowInLRTableView(lrTableView : LeftRightTableView, leftRow : Int) -> String
    func subdataForRightRowInLRTableView(lrTableView : LeftRightTableView, leftRow : Int) -> [String]?
}

@objc protocol LRTableViewDelegate : class {
    
    @objc optional func didSelectedLeftRowInLRTableView(lrtTableView : LeftRightTableView, leftRow : Int)
    @objc optional func didSelectedRightRowInLRTableView(lrtTableView : LeftRightTableView, leftRow : Int, rightRow : Int)
    @objc optional func didSelectedConfirmButton(lrtTableView : LeftRightTableView, leftRow : Int, rightRow : Int)
}



class LeftRightTableView: UIView {
    
    // MARK:- 创建cell的标识
    let LeftCellID = "LeftCellID"
    let RightCellID = "RightCellID"
    
    
    // MARK:- 定义属性
    weak var datasource : LRTableViewDatasource?
    weak var delegate : LRTableViewDelegate?
    var subData : [String]? // 存放右边列表数据
    var leftCurrentIndex : Int = 0 // 左边cell被点击角标
    var rightCurrentIndex : Int = 0 // 右边cell被点击角标
    var iconArray = [AnyObject]() // 存放右边cell的图标
    

    
    // MARK:- 左右tableView控件属性
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    
    // MARK:- 重置、确定按钮属性
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cinfirmBtn: UIButton!
    

    // MARK:- 重置按钮点击
    @IBAction func resetBtnClick(_ sender: Any) {
        // 角标置零
        leftCurrentIndex = 0
        rightCurrentIndex = 0
//        print("leftRow:---\(leftCurrentIndex)", "rightRow:---\(rightCurrentIndex)")
        
        // 将图标设为未点击状态,刷新列表
        let num: Int = iconArray.count
        for i in 0..<num {
            iconArray[i] = UIImageView(image: UIImage(named: "check_nor"))
        }
        rightTableView.reloadData()
        
        
    }
    
    // MARK:- 确定按钮点击
    @IBAction func confirmBtnClick(_ sender: Any) {
        
        delegate?.didSelectedConfirmButton?(lrtTableView: self, leftRow: leftCurrentIndex, rightRow: rightCurrentIndex)
        
    }
    
    override func awakeFromNib() {
        
        // 设置底部按钮
        resetBtn.layer.cornerRadius = 4
        resetBtn.clipsToBounds = true
        resetBtn.layer.borderWidth = 1
        resetBtn.layer.borderColor = UIColor(hexStr: "D7D7D7").cgColor
        
        cinfirmBtn.layer.cornerRadius = 4
        cinfirmBtn.clipsToBounds = true
        
        // 去除多余的分割线
        leftTableView.tableFooterView = UIView()
        rightTableView.tableFooterView = UIView()
    }

}

    // MARK:- 加载view的方法
extension LeftRightTableView {

    class func lrTableView() -> LeftRightTableView {
        return Bundle.main.loadNibNamed("LeftRightTableView", owner: nil, options: nil)!.first as! LeftRightTableView
    }
  
}

// MARK:- 数据源方法
extension LeftRightTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == leftTableView {
            return datasource?.numbersOfLeftRowsInLRTableView(lrTableView: self) ?? 0
        } else {
            return subData?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if tableView == leftTableView {
            // 创建Cell
            cell = tableView.dequeueReusableCell(withIdentifier: LeftCellID)
            

            // 判断cell是否有值
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: LeftCellID)
            }

            // 给cell设置数据
            cell?.textLabel?.text = datasource?.titleForLeftRowInLRTableView(lrTableView: self, leftRow: indexPath.row)
            cell?.textLabel?.textColor = UIColor(hex: 333333)
            
            cell?.backgroundColor = UIColor(hex: 0xFAFAFA)
            cell?.selectedBackgroundView = UIView(frame: (cell?.frame)!)
            cell?.selectedBackgroundView?.backgroundColor = UIColor(hexStr: "FFFFFF")
            
            
        } else {

            // 创建Cell
            cell = tableView.dequeueReusableCell(withIdentifier: RightCellID)
            
            // 判断cell是否有值
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: RightCellID)
            }
            
            // 设置cell右边图标
            let iconView = iconArray[indexPath.row]
            iconView.sizeToFit()
            cell?.accessoryView = (iconView as! UIView)
            
            // 给cell设置数据
            cell?.textLabel?.text = subData![indexPath.row]
            cell?.textLabel?.textColor = UIColor(hex: 333333)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
           
        }

        return cell!
    }
}

// MARK:- 代理方法
extension LeftRightTableView : UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == leftTableView {
            
            subData = datasource?.subdataForRightRowInLRTableView(lrTableView: self, leftRow: indexPath.row)
            
            // 清空数组,设置图标为未选中状态
            iconArray.removeAll()
            let num: Int = (subData?.count)!
            for _ in 0..<num {
                let iconImageView = UIImageView(image: UIImage(named: "check_nor"))
                iconArray.append(iconImageView)
            }
            
            // 记录左侧选中下标值
            leftCurrentIndex = indexPath.row
            
            // 右边下标置零,刷新列表
            rightCurrentIndex = 0
            rightTableView.reloadData()
            
            // 通知代理
            delegate?.didSelectedLeftRowInLRTableView?(lrtTableView: self, leftRow: indexPath.row)
            
        } else {
            delegate?.didSelectedRightRowInLRTableView?(lrtTableView: self, leftRow: leftCurrentIndex, rightRow: indexPath.row)
            // 记录右侧选中下标值
            rightCurrentIndex = indexPath.row
            // cell点击,改变图标
            selectedRow(indexPath: indexPath as NSIndexPath)
            
            
        }
        
    }
    
}

// MARK:- 点击cell,处理图标变化
extension LeftRightTableView {

    func selectedRow(indexPath: NSIndexPath) {
        
        let count: Int = iconArray.count
        for i in 0..<count {
            let icon = iconArray[i] as! UIImageView
            if i == indexPath.row {
                icon.image = UIImage(named: "check_click")
                icon.sizeToFit()
            }else {
                icon.image = UIImage(named: "check_nor")
                icon.sizeToFit()
            }
        }
  
    }
 
}










