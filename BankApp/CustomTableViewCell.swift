//
//  CustomTableViewCell.swift
//  BankApp
//
//  Created by Zhanna Rolich on 16.08.2022.
//

import UIKit
import RealmSwift

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeDateLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var sumLabel: UILabel!
    
    func configureCell(with model: Transactions){
        timeDateLabel.text = model.timeAndDate
        targetLabel.text = model.target
        sumLabel.text = "\(model.sum)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
