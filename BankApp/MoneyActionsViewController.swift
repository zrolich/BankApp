//
//  MoneyActionsViewController.swift
//  BankApp
//
//  Created by Zhanna Rolich on 08.08.2022.
//

import UIKit
import RealmSwift

class MoneyActionsViewController: UIViewController, UITextFieldDelegate {
    
    var operationType: String!
    var moneyActionsTextField = UITextField()
    var phoneNumberTextField = UITextField()
    var moneyActionsButton = UIButton()
    
    enum AppError: Error {
        case depositCount
        case nilError
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton()
        moneyActionsTextField.delegate = self
        
        switch operationType != nil {
        case operationType == "goToReplenishDeposit":
            setMoneyActionTextField(placeholder:"Укажите сумму пополнения")
            
        case operationType == "goToGetCash":
            setMoneyActionTextField(placeholder:"Укажите сумму снятия")
            
        case operationType == "goToReplenishMobileAccount" :
            setMoneyActionTextField(placeholder:"Укажите сумму пополнения")
            setPhoneNumberTextField()
            
        default:
            break
        }
    }
    
    func createButton(){
        moneyActionsButton = UIButton (type: .roundedRect)
        moneyActionsButton.frame = CGRect(x: 150, y: 500, width: 100, height: 44)
        moneyActionsButton.backgroundColor = .systemGray6
        moneyActionsButton.setTitle("Подтвердить", for: .normal)
        moneyActionsButton.setTitleColor(.black, for: .normal)
        moneyActionsButton.setTitleColor(.black, for: .highlighted)
        moneyActionsButton.addTarget(self, action: #selector(buttonIsPressed), for: .touchDown)
        
        view.addSubview(moneyActionsButton)
    }
    
    
    @objc func buttonIsPressed (sender: UIButton) throws {
        do {
            let realm = RealmService.shared.rm
            let transactions = Transactions()
            let date: Date = Date()
            let dateformater = DateFormatter()
            dateformater.dateFormat = "MMM d, h:mm a"
            let dateOfOperation = dateformater.string(from: date)
            transactions.timeAndDate = "\(dateOfOperation)"
            transactions.operation = operationType
            //        print(realm.configuration.fileURL)
            
            let infoDeposit = realm.objects(Deposit.self).first
            var value: Float = 0
            
            let currentDeposit = infoDeposit?.deposit ?? 0
            let count = Float(moneyActionsTextField.text!)!
            
            if (moneyActionsTextField.text == ""){
                throw AppError.nilError
            }
            
            
            switch operationType != nil {
            case operationType == "goToReplenishDeposit":
                value = currentDeposit + count
                transactions.target = "Пополнение депозита"
                transactions.sum = String(count)
                
            case operationType == "goToGetCash":
                if (count > currentDeposit ){
                    throw AppError.depositCount
                }
                value = currentDeposit - count
                transactions.target = "Снятие наличных"
                transactions.sum = "-\(count)"
                
            case operationType == "goToReplenishMobileAccount":
                if (count > currentDeposit ){
                    throw AppError.depositCount
                }
                value = currentDeposit - count
                transactions.target = "Пополнение баланса телефона"
                transactions.sum = "-\(count)"
                
            default:
                break
            }
            
            let dict: [String: Any] = ["deposit": value]
            
            RealmService.shared.create(transactions)
            if infoDeposit != nil {
                RealmService.shared.update(infoDeposit!, dictionary: dict)
            } else {
                let newDeposit = Deposit()
                newDeposit.deposit = value
                RealmService.shared.create(newDeposit)
            }
            
           
        } catch AppError.depositCount {
            setMoneyActionTextField(placeholder: "Недостаточно средств")
            return
        }
        catch AppError.nilError {
            setMoneyActionTextField(placeholder: "Заполните поле")
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setMoneyActionTextField (placeholder:String) {
        let textFieldFrame = CGRect(x:0, y:0, width: 370, height:31)
        moneyActionsTextField = UITextField(frame: textFieldFrame)
        moneyActionsTextField.borderStyle = .roundedRect
        moneyActionsTextField.contentVerticalAlignment = .center
        moneyActionsTextField.textAlignment = .center
        moneyActionsTextField.keyboardType = .numbersAndPunctuation
        moneyActionsTextField.center = self.view.center
        moneyActionsTextField.placeholder = placeholder
        
        view.addSubview(moneyActionsTextField)
    }
    
    func setPhoneNumberTextField(){
        let textFieldFrame = CGRect(x:21, y:380, width: 370, height:31)
        phoneNumberTextField = UITextField(frame: textFieldFrame)
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.contentVerticalAlignment = .center
        phoneNumberTextField.textAlignment = .center
        phoneNumberTextField.keyboardType = .numbersAndPunctuation
        phoneNumberTextField.placeholder = "Введите номер телефона"
        
        view.addSubview(phoneNumberTextField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
}

