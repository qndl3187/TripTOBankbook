//
//  PreconditionController.swift
//  TripToBankbook
//
//  Created by 박지은 on 29/07/2019.
//  Copyright © 2019 박지은. All rights reserved.
//

import Foundation
import UIKit

class PreconditionController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    var num = Int(0)
    var arealist = ["서울특별시","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시","울산광역시","세종특별자치시","경기도","강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주특별자치도"]
    
    @IBOutlet var departureday: UITextField!
    
    @IBOutlet var lastday: UITextField!
    
    @IBOutlet var num_minus: UIButton!
    @IBOutlet var num_plus: UIButton!
    
    @IBOutlet var num_people: UILabel!
    
    @IBOutlet var area_field: UITextField!
    
    
    @IBOutlet var shopping: UIButton!
    @IBOutlet var food: UIButton!
    @IBOutlet var tourism: UIButton!
    
    @IBAction func plus_click(_ sender: Any) {
        num += 1
        num_people.text = String(num)
        print(num)
    }
    @IBAction func minus_click(_ sender: Any) {
        num -= 1
        num_people.text = String(num)
    }
    @IBOutlet var input_money: UITextField!{didSet {input_money.delegate=self}}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   /* @objc func keyboardWillShow(_ sender: Notification) {
        
        
        
        self.view.frame.origin.y = -150 // Move view 150 points upward
        
        
        
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input_money.resignFirstResponder()
        return true
    }
    /*
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }*/
    // 생성할 컴포넌트의 개수 정의
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 컴포넌트가 가질 목록의 길이
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arealist.count
    }
    
    // 컴포넌트의 목록 각 행에 출력될 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arealist[row]
    }
    
    // 컴포넌트의 행을 선택했을 때 실행할 액션
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let area_field = self.arealist[row]
        self.area_field.text = area_field
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = hexStringToUIColor(hex:"FFCC33")
      //  self.view.layer.borderColor = UIColor.white.cgColor
      //  self.view.layer.borderWidth = 10
       // self.view.layer.addBorder([.top, .bottom], color: UIColor.white, width: 80.0)
        
        shopping.layer.borderColor = hexStringToUIColor(hex:"FFEA67").cgColor
        shopping.layer.borderWidth = 3
        shopping.layer.cornerRadius = 5
        
        food.layer.borderColor = hexStringToUIColor(hex:"FFEA67").cgColor
        food.layer.borderWidth = 3
        food.layer.cornerRadius = 5
        
        tourism.layer.borderColor = hexStringToUIColor(hex:"FFEA67").cgColor
        tourism.layer.borderWidth = 3
        tourism.layer.cornerRadius = 5
       /* NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        */
        //input_money.layer.borderColor = hexStringToUIColor(hex:"FFCC33").cgColor
        //input_money.layer.borderWidth = 3
        
        //지역 설정 피커
        let area_picker = UIPickerView()
        area_picker.delegate = self
        area_picker.dataSource = self
        area_picker.showsSelectionIndicator = true
        self.area_field.inputView = area_picker
        
        //날짜 설정 피커
        let departure_picker = UIDatePicker()
        departure_picker.datePickerMode = UIDatePicker.Mode.date
        departure_picker.addTarget(self, action: #selector(departurepickerChanged(sender:)), for:UIControl.Event.valueChanged)
        departureday.inputView=departure_picker
        let last_picker = UIDatePicker()
        last_picker.datePickerMode = UIDatePicker.Mode.date
        last_picker.addTarget(self, action: #selector(lastpickerChanged(sender:)), for:UIControl.Event.valueChanged)
        lastday.inputView=last_picker
        

 
     
    }
    @objc func departurepickerChanged(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle=DateFormatter.Style.none
        departureday.text = formatter.string(from: sender.date)
        
    }
    @objc func lastpickerChanged(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle=DateFormatter.Style.none
        lastday.text = formatter.string(from: sender.date)
        
    }
    
    
}
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
