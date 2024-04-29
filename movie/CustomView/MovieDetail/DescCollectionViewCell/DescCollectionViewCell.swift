//
//  DescCollectionViewCell.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import UIKit

class DescCollectionViewCell: UICollectionViewCell {
    
    static let templateDesc = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra orci sagittis eu volutpat odio facilisis mauris sit amet massa vitae tortor condimentum lacinia quis vel eros donec ac odio tempor orci dapibus ultrices in iaculis nunc sed augue lacus, viverra vitae congue eu, consequat ac felis donec et odio pellentesque diam volutpat commodo sed egestas egestas fringilla phasellus faucibus
        """
    
    static let templateHeight: Int = {
        
        let getSize =  NSString(string: DescCollectionViewCell.templateDesc).boundingRect(
            with:
                CGSize(
                    width:
                        (
                            UIScreen.main.bounds.width - (2 * 20)
                        ),
                    height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let total = getSize.height + (2 * 20)
        
        return Int(total)
    }()
    
    private let lblDesc: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.sizeToFit()
        return label
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
        self.contentView.addSubview(lblDesc)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["lblDesc": lblDesc]
        
        var constraints: [NSLayoutConstraint] = []
        
        lblDesc.translatesAutoresizingMaskIntoConstraints = false
        let v_lblDesc = "V:|-20-[lblDesc]"
        let h_lblDesc = "H:|-20-[lblDesc]-20-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_lblDesc, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_lblDesc, options: .alignAllTop, metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension DescCollectionViewCell {
    
    func setValue(value: MovieDetailEntity) {
        lblDesc.text = value.overview
    }
    
    func forTesting() {
        lblDesc.text = DescCollectionViewCell.templateDesc
    }
}
