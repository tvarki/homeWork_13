//
//  AddTextView.swift
//  homeWork_13
//
//  Created by Дмитрий Яковлев on 18.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit


class AddTeextView : UIView {
    private var nameTextField = UITextField(frame: CGRect(x: 5,y: 20,width: 400,height: 44))
    private var nameLabel = UILabel(frame: CGRect(x: 5,y: 49,width: 300,height: 44))

    private var errors : String = "Все поля обязательны к заполнению"
    
    private var textMask = ""
    var action: ((_ txtInput: String) -> String)?

    // MARK: - init
    init(frame: CGRect, action: @escaping (String) -> String) {
        super.init(frame: frame)
        self.action = action
        nameTextField.addTarget(self, action: #selector(checkText), for: [.editingChanged,.editingDidEnd])
        setup()
        
    }

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        setup()

    }
   
    // MARK: - setup
    private func setup(){

         nameTextField.placeholder = "Ввод"
         addSubview(nameTextField)
         nameLabel.textColor = UIColor.red
         nameLabel.text = "Error"
         nameLabel.numberOfLines = 0
         nameLabel.lineBreakMode = .byWordWrapping
         nameLabel.frame.size.width = 300
         nameLabel.isHidden = true
         nameLabel.textAlignment = .center
         addSubview(nameLabel)
     }
    
    
    func setMaskTextField(msk: String) {
        //MARK:- If Delete button click
        self.textMask = msk
        nameTextField.addTarget(self, action: #selector(setMask), for: .editingChanged)

    }
    
    // MARK: - text checking
    
    @objc private func checkText(){
        guard let txt = nameTextField.text else { return }
        guard action != nil else {return}
        
        let res = action!(txt)
        nameLabel.text = res
        errors = res;
        if(res != ""){
            nameLabel.isHidden = false
        }
        else {
            nameLabel.isHidden = true
        }
        
    }
    // MARK: - setters/getters

    
    @objc private func setMask(){
         let res = formattedNumber(number: nameTextField.text!, msk : textMask)
        nameTextField.text = res
    }
    
    func getErrors()->String{
        return errors
    }
    
    
    
    private func formattedNumber(number: String, msk: String) -> String {
        let cleanSerial = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = msk
        var result = ""
        var index = cleanSerial.startIndex
        for ch in mask where index < cleanSerial.endIndex {
            if ch == "X" {
                result.append(cleanSerial[index])
                index = cleanSerial.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    func setPlaceHolder(ph : String){
        nameTextField.placeholder = ph
    }
    
    func setInputType(inputType : UIKeyboardType){
        self.nameTextField.keyboardType = inputType
    }
    
    func getValue() -> String{
        guard let tmp = nameTextField.text else{return ""}
        return tmp
        
    }
    
}
