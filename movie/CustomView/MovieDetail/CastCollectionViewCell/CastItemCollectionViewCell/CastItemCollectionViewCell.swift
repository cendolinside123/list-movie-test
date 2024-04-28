//
//  CastItemCollectionViewCell.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import UIKit

class CastItemCollectionViewCell: UICollectionViewCell {
    
    private let stackViewCore: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    
    private let imgMovie: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
        return view
    }()
    
    private let lblName: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
        label.sizeToFit()
        return label
    }()
    
    static let widthDefault: Int = {
        return 80
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.001)
        self.contentView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        self.contentView.addSubview(stackViewCore)
        stackViewCore.addArrangedSubview(imgMovie)
        stackViewCore.addArrangedSubview(lblName)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["stackViewCore": stackViewCore]
        
        var constraints: [NSLayoutConstraint] = []
        
        stackViewCore.translatesAutoresizingMaskIntoConstraints = false
        let v_stackViewCore = "V:|-5-[stackViewCore]-5-|"
        let h_stackViewCore = "H:|-5-[stackViewCore]-5-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_stackViewCore, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_stackViewCore, options: .alignAllTop, metrics: nil, views: views)
        
        imgMovie.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: imgMovie, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(CastItemCollectionViewCell.widthDefault))]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCorner() {
        imgMovie.layoutIfNeeded()
        imgMovie.layer.cornerRadius = imgMovie.bounds.height / 2
        imgMovie.clipsToBounds = true
    }
    
}

extension CastItemCollectionViewCell {
    func forTesting() {
        setupCorner()
        lblName.text = "Dave Franco"
    }
}
