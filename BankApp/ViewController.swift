//
//  ViewController.swift
//  BankApp
//
//  Created by Zhanna Rolich on 02.08.2022.
//

import UIKit
import RealmSwift


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let idCell = "customCell"
    var bankAppTableView = UITableView()
    var transactionsResultReplenishment: Results<Transactions>!
    var transactionsResultWithdrawal: Results<Transactions>!
    
    @IBOutlet weak var bankAccountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
      
        let realm = RealmService.shared.rm
        let infoDeposit = realm.objects(Deposit.self).first
        
        bankAccountLabel.text = "Cумма на вашем депозите составляет: \(infoDeposit?.deposit ?? 0) USD"
        
        bankAppTableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      

        let realm = RealmService.shared.rm
        transactionsResultReplenishment =
        realm.objects(Transactions.self).filter("operation == 'goToReplenishDeposit'").sorted(byKeyPath: "timeAndDate", ascending: false)
        
        transactionsResultWithdrawal = realm.objects(Transactions.self).filter("operation in { 'goToGetCash', 'goToReplenishMobileAccount'} ").sorted(byKeyPath: "timeAndDate", ascending: false)
        
        
        createTableView()
        
        
    }
    @IBAction func replenishDeposit(_ sender: Any) {
    }
    
    @IBAction func getCashOperation(_ sender: Any) {
    }
    
    @IBAction func replenishMobileAccount(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MoneyActionsViewController {
            switch segue.identifier {
            case "goToReplenishDeposit":
                vc.operationType = "goToReplenishDeposit"
            case "goToGetCash":
                vc.operationType = "goToGetCash"
            case "goToReplenishMobileAccount":
                vc.operationType = "goToReplenishMobileAccount"
            default:
                vc.operationType = "break"
                break
            }
        }
    }
    
    func createTableView(){
        let tableViewFrame = CGRect(x:20, y:510, width: 370, height:330)
        bankAppTableView = UITableView(frame: tableViewFrame)
        bankAppTableView.register(UINib(nibName:"CustomTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
        bankAppTableView.dataSource = self
        bankAppTableView.delegate = self
        
        view.addSubview(bankAppTableView)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return transactionsResultReplenishment.count
        case 1:
            return transactionsResultWithdrawal.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! CustomTableViewCell
        
        
        switch indexPath.section {
        case 0:
            cell.configureCell(with: transactionsResultReplenishment[indexPath.row])
        case 1:
            cell.configureCell(with: transactionsResultWithdrawal[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Пополнения"
        case 1:
            return "Снятия"
        default:
            break
        }
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}








