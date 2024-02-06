//
//  MyProgressView.swift
//  trainingtask
//
//  Created by Alex on 6.02.24.
//

import UIKit
import CoreImage.CIFilterBuiltins

class MyProgressView: UIView {
    let message = UILabel()
    let spinner = UIActivityIndicatorView()
    let statusImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isOpaque = false
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.backgroundColor = .clear
        blurEffectView.alpha = 0.5
        addSubview(blurEffectView)
        
        let banner = UIView()
        let vstack = UIStackView()
        let zstack = UIView()
        
        
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        zstack.addSubview(spinner)
        
        statusImage.tintColor = .label
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        zstack.addSubview(statusImage)
        
        zstack.translatesAutoresizingMaskIntoConstraints = false
        zstack.backgroundColor = .clear
        vstack.addArrangedSubview(zstack)
        
        message.translatesAutoresizingMaskIntoConstraints = false
        message.textAlignment = .center
        message.font = .preferredFont(forTextStyle: .headline)
        message.numberOfLines = 0
        vstack.addArrangedSubview(message)
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.axis = .vertical
        vstack.alignment = .center
        vstack.distribution = .equalSpacing
        vstack.spacing = DrawingConstants.standardSpacing
        vstack.backgroundColor = .clear
        banner.addSubview(vstack)
        
        banner.backgroundColor = .systemFill
        banner.layer.cornerRadius = DrawingConstants.bigCornerRadius
        banner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(banner)
        
        
        
        NSLayoutConstraint.activate([
            blurEffectView.widthAnchor.constraint(equalTo: widthAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: heightAnchor),
            blurEffectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurEffectView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusImage.widthAnchor.constraint(equalToConstant: DrawingConstants.progressImageSize),
            statusImage.heightAnchor.constraint(equalToConstant: DrawingConstants.progressImageSize),
            statusImage.centerXAnchor.constraint(equalTo: zstack.centerXAnchor),
            statusImage.centerYAnchor.constraint(equalTo: zstack.centerYAnchor),
            
            spinner.widthAnchor.constraint(equalToConstant: DrawingConstants.progressImageSize),
            spinner.heightAnchor.constraint(equalToConstant: DrawingConstants.progressImageSize),
            spinner.centerXAnchor.constraint(equalTo: zstack.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: zstack.centerYAnchor),
            
            zstack.widthAnchor.constraint(greaterThanOrEqualTo: statusImage.widthAnchor),
            zstack.widthAnchor.constraint(greaterThanOrEqualTo: spinner.widthAnchor),
            zstack.heightAnchor.constraint(equalTo: statusImage.heightAnchor),
            zstack.heightAnchor.constraint(equalTo: spinner.heightAnchor),
            
            vstack.leadingAnchor.constraint(greaterThanOrEqualTo: banner.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            vstack.topAnchor.constraint(greaterThanOrEqualTo: banner.topAnchor, constant: DrawingConstants.doubleSpacing),
            banner.trailingAnchor.constraint(greaterThanOrEqualTo: vstack.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            banner.bottomAnchor.constraint(greaterThanOrEqualTo: vstack.bottomAnchor, constant: DrawingConstants.doubleSpacing),
            
            banner.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            banner.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: DrawingConstants.doubleSpacing),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: banner.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            self.bottomAnchor.constraint(greaterThanOrEqualTo: banner.bottomAnchor, constant: DrawingConstants.doubleSpacing),
            banner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            banner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
