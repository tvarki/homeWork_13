//
//  AddViewController.swift
//  homeWork_13
//
//  Created by Дмитрий Яковлев on 18.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit

// MARK: - AddViewDelegate

protocol AddViewDelegate : AnyObject{
    func addData(post:Post)
}

class AddViewController: UIViewController {
    
    
    weak var delegate: AddViewDelegate?
    
    var tvTitle = AddTeextView()
    var tvBody = AddTeextView()
    var tvID = AddTeextView()
    var tvUserID = AddTeextView()
    
    // MARK: - isValid

    var isValid: Bool {
        return checkErrors(item: tvTitle) && checkErrors(item: tvBody) && checkErrors(item: tvID) && checkErrors(item: tvUserID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - setup

    func setup(){
           tvTitle = AddTeextView(frame: CGRect(x: 25,y: 70,width: 400,height: 68),action: testTitle)
           tvTitle.setPlaceHolder(ph: "Введите Заголовок")
           view.addSubview(tvTitle)
           
           tvBody = AddTeextView(frame: CGRect(x: 25,y: 145,width: 400,height: 68),action: testBody)
           tvBody.setPlaceHolder(ph: "Введите Тело")
           view.addSubview(tvBody)
           
           tvID = AddTeextView(frame: CGRect(x: 25,y: 220,width: 400,height: 68),action: testID)
           tvID.setPlaceHolder(ph: "Введите Идентификатор")
           tvID.setInputType(inputType: UIKeyboardType.numberPad)
           view.addSubview(tvID)
           
           tvUserID = AddTeextView(frame: CGRect(x: 25,y: 295,width: 400,height: 68),action: testUserID)
           tvUserID.setPlaceHolder(ph: "Введите Идентификатор пользователя")
           tvUserID.setInputType(inputType: UIKeyboardType.numberPad)
           view.addSubview(tvUserID)
           
           view.backgroundColor = .white
           
           let readyButton  = UIButton(frame: CGRect(x: 0,y: 370,width: 400,height: 68))
           readyButton.setTitle("Добавить", for: .normal )
           readyButton.setTitleColor(UIColor.blue, for: .normal)
           
           view.addSubview(readyButton)
           readyButton.addTarget(self, action: #selector(addClicked), for: .touchDown)
           
    }
    // MARK: - button Add Click
    @objc private func addClicked(){
        if isValid{
            guard
                let id = Int(tvID.getValue()),
                let uid = Int(tvUserID.getValue())
                else {return}
            let title = tvTitle.getValue()
            let body = tvBody.getValue()
            delegate?.addData(post: Post(userId: uid, id: id, title: title, body: body))
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - input Error check
    func checkErrors(item: AddTeextView)->Bool{
        guard item.getErrors() == "" else{
            makeAlert(title: "Внимание", text: item.getErrors())
            return false;
        }
        return true;
    }
    
    func makeAlert(title: String , text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
        
    // MARK: - title rules
    func testTitle(txtInput : String)->String {
        guard txtInput.count != 0 else{ return "Поле Заголовок не заполнено"}
        return ""
    }
    
    // MARK: - body rules
    func testBody(txtInput : String)->String {
        guard txtInput.count != 0 else{ return "Поле Тело не заполнено"}
        return ""
    }
    
    // MARK: - id rules
    func testID(txtInput : String)->String {
        guard txtInput.count != 0 else{ return "Поле Идентификатор не заполнено"}
        return ""
    }
    
    // MARK: - uid rules
    func testUserID(txtInput : String)->String {
        guard txtInput.count != 0 else{ return "Поле Идентификатор пользователя не заполнено"}
        return ""
    }
    
    
    
}
