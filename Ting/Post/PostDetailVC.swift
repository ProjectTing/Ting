//
//  PostDetailVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

class PostDetailVC: UIViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let statusTagsStackView = UIStackView()
    private let activityTimeLabel = UILabel()
    private let availableTimeLabel = UILabel()
    private let availableTimeValueLabel = UILabel()
    private let timeStateLabel = UILabel()
    private let timeStateValueLabel = UILabel()
    private let urgencyLabel = UILabel()
    private let urgencyValueLabel = UILabel()
    private let techStackLabel = UILabel()
    private let techStacksStackView = UIStackView()
    private let projectTypeLabel = UILabel()
    private let projectTypeStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let applyButton = UIButton()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        setupBasic()
        setupComponents()
        setupConstraints()
    }
    
    private func setupBasic() {
        view.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.93, alpha: 1.0)
        scrollView.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.93, alpha: 1.0)
        scrollView.showsVerticalScrollIndicator = true
    }
    
    private func setupComponents() {
        setupLabels()
        setupStackViews()
        setupButton()
        addSubviews()
    }
    
    private func setupLabels() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        
        activityTimeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        activityTimeLabel.textColor = .black
        
        availableTimeLabel.font = .systemFont(ofSize: 16)
        availableTimeLabel.textColor = .darkGray
        
        availableTimeValueLabel.font = .systemFont(ofSize: 16)
        availableTimeValueLabel.textColor = .black
        availableTimeValueLabel.textAlignment = .right
        
        timeStateLabel.font = .systemFont(ofSize: 16)
        timeStateLabel.textColor = .darkGray
        
        timeStateValueLabel.font = .systemFont(ofSize: 16)
        timeStateValueLabel.textColor = .black
        timeStateValueLabel.textAlignment = .right
        
        urgencyLabel.font = .systemFont(ofSize: 16)
        urgencyLabel.textColor = .darkGray
        
        urgencyValueLabel.font = .systemFont(ofSize: 16)
        urgencyValueLabel.textColor = .black
        urgencyValueLabel.textAlignment = .right
        
        techStackLabel.font = .systemFont(ofSize: 18, weight: .medium)
        techStackLabel.textColor = .black
        
        projectTypeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        projectTypeLabel.textColor = .black
        
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .black
        
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.textColor = .black
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
    }
    
    private func setupStackViews() {
        [statusTagsStackView, techStacksStackView, projectTypeStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
    }
    
    private func setupButton() {
        applyButton.backgroundColor = UIColor(red: 0.76, green: 0.18, blue: 0.07, alpha: 1.0)
        applyButton.layer.cornerRadius = 8
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, statusTagsStackView, activityTimeLabel,
         availableTimeLabel, availableTimeValueLabel,
         timeStateLabel, timeStateValueLabel,
         urgencyLabel, urgencyValueLabel,
         techStackLabel, techStacksStackView,
         projectTypeLabel, projectTypeStackView,
         descriptionLabel, descriptionTextView].forEach { contentView.addSubview($0) }
         
        view.addSubview(applyButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(applyButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        applyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        statusTagsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        activityTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(statusTagsStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        availableTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(activityTimeLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        availableTimeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(availableTimeLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        timeStateLabel.snp.makeConstraints { make in
            make.top.equalTo(availableTimeLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
        }
        
        timeStateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeStateLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        urgencyLabel.snp.makeConstraints { make in
            make.top.equalTo(timeStateLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
        }
        
        urgencyValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(urgencyLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        techStackLabel.snp.makeConstraints { make in
            make.top.equalTo(urgencyLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        techStacksStackView.snp.makeConstraints { make in
            make.top.equalTo(techStackLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        projectTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(techStacksStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        projectTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(projectTypeLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(projectTypeStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-80)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    TestPostDetailVC()
}
