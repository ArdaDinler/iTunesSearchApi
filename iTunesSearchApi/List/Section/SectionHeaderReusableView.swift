//
//  SectionHeaderReusableView.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
            weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: readableContentGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
