//
//  FastisMonthHeader.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 RetailDriver LLC. All rights reserved.
// Created By Rashmi Dhanotiya

import UIKit
import SnapKit
import JTAppleCalendar

class MonthHeader: JTACMonthReusableView {
    
    // MARK: - Outlets
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "Month name"
        return label
    }()
   
    private lazy var weekView: WeekView = {
        return WeekView(config: self.config.weekView)
    }()
    
    // MARK: - Variables
    private let config: FastisConfig = .default
    internal var calculatedHeight: CGFloat = 0
    internal var tapHandler: (() -> Void)?
    private var insetConstraint: Constraint?
    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    private lazy var veryShortWeekdaySymbols: DateFormatter = {
        let formatter1 = DateFormatter()
        return formatter1
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(FastisConfig.default.monthHeader)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configureSubviews() {
        self.addSubview(self.monthLabel)
        self.addSubview(self.weekView)
    }
    
    private func configureConstraints() {
        self.monthLabel.snp.makeConstraints { (maker) in
            self.insetConstraint = maker.edges.lessThanOrEqualToSuperview().constraint
        }
        self.weekView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().inset(5)
            maker.left.right.equalToSuperview()
        }
    }
    
    internal func configure(for date: Date) {
        self.monthLabel.text = self.monthFormatter.string(from: date).uppercased()
        self.setTextSpacingBy(value: 2.8)
       
    }
  
    
    // MARK: - Actions
    
    internal func applyConfig(_ config: FastisConfig.MonthHeader) {
        self.monthFormatter.dateFormat = config.monthFormat
        self.monthFormatter.locale = config.monthLocale
        self.monthLabel.font = config.labelFont
        self.monthLabel.textColor = config.labelColor
        self.monthLabel.textAlignment = config.labelAlignment
        self.setTextSpacingBy(value: 3.5)
        self.insetConstraint?.update(inset: config.insets)
    }

   
    
    func setTextSpacingBy(value: Double) {
      if let textString =  self.monthLabel.text {
        let attributedString = NSMutableAttributedString(string: textString)
          attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
        self.monthLabel.attributedText = attributedString
      }
    }
    @objc private func viewTapped() {
        self.tapHandler?()
    }
}

extension FastisConfig {
        public struct MonthHeader {
        public var labelAlignment: NSTextAlignment = .left
        public var labelColor: UIColor = UIColor.init(red: 5/255, green: 19/255, blue: 30/255, alpha: 1)
        public var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 4, right: 16)
        public var monthFormat: String = "LLLL yyyy"
        public var monthLocale: Locale = .current
        public var labelFont: UIFont = UIFont(name: "Poppins-Bold", size: 18.0) ?? .systemFont(ofSize: 18, weight: .bold)
        public var size: MonthSize = .init(defaultSize: 75)
    }
}





//
