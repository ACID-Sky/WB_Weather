//
//  ButtonTableViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    func dismissController()
}

final class ButtonTableViewCell: UITableViewCell {

    private lazy var button = UIButton()
    weak var delegate: ButtonTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = .red
        self.setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupButton() {

        self.button.setTitle("Save", for: .normal)
        self.button.setTitleColor(.systemBackground, for: .normal)
        self.button.backgroundColor = .systemOrange
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action:  #selector(buttonTapped), for: .touchUpInside)

        self.contentView.addSubview(self.button)

        NSLayoutConstraint.activate([
            self.button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.button.heightAnchor.constraint(equalToConstant: 40),
            self.button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
        ])

        self.button.layer.cornerRadius = 10
    }

    @objc private func buttonTapped () {
        print("✅")
        delegate?.dismissController()
        
    }

}
