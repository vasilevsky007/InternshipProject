//
//  ListView.swift
//  trainingtask
//
//  Created by Alex on 1.02.24.
//

import UIKit

class ListView: UIView {

    var controls = TableControlButtons()
    var table = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground

        controls.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controls)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        addSubview(table)
        
        NSLayoutConstraint.activate([
            controls.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DrawingConstants.standardSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: controls.trailingAnchor, constant: DrawingConstants.standardSpacing),
            
            table.topAnchor.constraint(equalTo: controls.bottomAnchor, constant: DrawingConstants.standardSpacing),
            
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: table.trailingAnchor, constant: DrawingConstants.standardSpacing),
            table.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.standardSpacing),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: table.bottomAnchor, constant: DrawingConstants.standardSpacing)
        ])
    }
}
