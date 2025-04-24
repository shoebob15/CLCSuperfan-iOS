//
//  CustomCell.swift
//  jaybe
//
//  Created by JOHN GARIEPY on 4/17/25.
//

import UIKit

class CustomCell: UITableViewCell {

    let label1 = UILabel()
    let label2 = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(label1)
        contentView.addSubview(label2)

        label1.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label2.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label2.textColor = .gray
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        label1.frame = CGRect(x: 16, y: 10, width: contentView.frame.width - 32, height: 20)
        label2.frame = CGRect(x: 16, y: label1.frame.maxY + 5, width: contentView.frame.width - 32, height: 18)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
