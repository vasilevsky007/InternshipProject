//
//  TableControlButtons.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

/// элемент интерфейса, включающий в себя кнопки обновления и добавления нового элемента.
/// использует констрейнты.
/// - Important: задайте   ``addAction`` и ``reloadAction`` для  работы кнопок
class TableControlButtons: UIView {
    // MARK: - Properties
    /// действие, которое происходит при нажатии на кнопку обновления
    var reloadAction: () -> Void = {}
    /// действие, которое происходит при нажатии на кнопку добавления новго элемента
    var addAction: () -> Void = {}
    
    private var reload = UIButton()
    private var add = UIButton()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Methods
    @objc private func reloadTapped() {
        reloadAction()
    }
    @objc private func addTapped() {
        addAction()
    }
    
    private func setupUI() {
        let stack = UIStackView()
        
        reload.setImage(UIImage(systemName: Strings.reloadImage), for: .normal)
        reload.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
        stack.addArrangedSubview(reload)
        
        add.setImage(UIImage(systemName: Strings.addImage), for: .normal)
        add.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        stack.addArrangedSubview(add)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.doubleSpacing
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: self.widthAnchor),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}
