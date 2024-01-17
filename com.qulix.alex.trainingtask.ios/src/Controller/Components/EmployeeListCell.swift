//
//  EmployeeListCell.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

class EmployeeListCell: UITableViewCell {

    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    var updateTable: () -> Void = {}
    var present: (UIViewController) -> Void = {_ in}
    
    private var currentIndex: Int = -1
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var middleNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBAction func editTapped(_ sender: UIButton) {
        
    }
    
    func setup(forEmployeeAtIndex index: Int) {
        currentIndex = index
        let employee = employeeStore.items[index]
        nameLabel.text = employee.name
        surnameLabel.text = employee.surname
        middleNameLabel.text = employee.middleName
        positionLabel.text = employee.position
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
