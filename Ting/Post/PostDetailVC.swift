//
//  PostDetailVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//


import UIKit
import SnapKit

extension UIView {
   func addSubviews(_ views: [UIView]) {
       views.forEach { addSubview($0) }
   }
}

class PostDetailVC: UIViewController {
   // MARK: - UI Components
   private let scrollView = UIScrollView()
   private let contentView = UIView()
   private let whiteCardView = UIView()
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
   private let reportButton = UIButton()
   
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
       view.backgroundColor = .background
       scrollView.backgroundColor = .clear
       
       whiteCardView.backgroundColor = .white
       whiteCardView.layer.cornerRadius = 12
       whiteCardView.layer.shadowColor = UIColor.black.cgColor
       whiteCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
       whiteCardView.layer.shadowRadius = 4
       whiteCardView.layer.shadowOpacity = 0.1
       whiteCardView.clipsToBounds = false
   }
   
   private func setupComponents() {
       setupLabels()
       setupStackViews()
       setupButton()
       addSubviews()
   }
   
   private func setupLabels() {
       titleLabel.text = "프론트엔드 개발자 구직중" // 타이틀 - 추후 데이터값을 받고 내부값 수정 필요
       titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
       titleLabel.textColor = .deepCocoa
       
       activityTimeLabel.text = "활동 가능 상태"
       activityTimeLabel.font = .systemFont(ofSize: 18, weight: .medium)
       activityTimeLabel.textColor = .deepCocoa
       
       availableTimeLabel.text = "가능한 기간"
       availableTimeLabel.font = .systemFont(ofSize: 16)
       availableTimeLabel.textColor = .brownText
       
       availableTimeValueLabel.text = "풀펫 참여 가능 시간" // 추후 데이터값을 받고 내부값 수정 필요
       availableTimeValueLabel.font = .systemFont(ofSize: 16)
       availableTimeValueLabel.textColor = .deepCocoa
       availableTimeValueLabel.textAlignment = .right
       
       timeStateLabel.text = "가능한 시간"
       timeStateLabel.font = .systemFont(ofSize: 16)
       timeStateLabel.textColor = .brownText
       
       timeStateValueLabel.text = "풀펫 참여 가능 시간" // 추후 데이터값을 받고 내부값 수정 필요
       timeStateValueLabel.font = .systemFont(ofSize: 16)
       timeStateValueLabel.textColor = .deepCocoa
       timeStateValueLabel.textAlignment = .right
       
       urgencyLabel.text = "시급성"
       urgencyLabel.font = .systemFont(ofSize: 16)
       urgencyLabel.textColor = .brownText
       
       urgencyValueLabel.text = "여유로움"// 추후 데이터값을 받고 내부값 수정 필요
       urgencyValueLabel.font = .systemFont(ofSize: 16)
       urgencyValueLabel.textColor = .deepCocoa
       urgencyValueLabel.textAlignment = .right
       
       techStackLabel.text = "보유 기술 스택"
       techStackLabel.font = .systemFont(ofSize: 18, weight: .medium)
       techStackLabel.textColor = .deepCocoa
       
       projectTypeLabel.text = "프로젝트 목적"
       projectTypeLabel.font = .systemFont(ofSize: 18, weight: .medium)
       projectTypeLabel.textColor = .deepCocoa
       
       descriptionLabel.text = "프로젝트 가치관"
       descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
       descriptionLabel.textColor = .deepCocoa
       
       descriptionTextView.text = "협업을 통해 함께 성장하고 싶습니다. 열정적인 팀원들과 함께 의미있는 프로젝트를 만들어가고 싶습니다. 실제 서비스 런칭 경험을 쌓고 싶으며, 체계적인 프로젝트 진행을 선호합니다." // 추후 데이터값을 받고 내부값 수정 필요
       descriptionTextView.font = .systemFont(ofSize: 16)
       descriptionTextView.textColor = .deepCocoa
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
       
       setupTags()
   }
   
   private func setupTags() {
       ["온라인", "경력 2년", "실무 경험"].forEach { tag in
           statusTagsStackView.addArrangedSubview(createTagView(text: tag))
       } // 추후 데이터값을 받고 내부값 수정 필요
       
       ["React", "Swift", "Node.js"].forEach { tag in
           techStacksStackView.addArrangedSubview(createTagView(text: tag))
       } // 추후 데이터값을 받고 내부값 수정 필요
       
       ["포트폴리오", "사이드 프로젝트"].forEach { tag in
           projectTypeStackView.addArrangedSubview(createTagView(text: tag))
       } // 추후 데이터값을 받고 내부값 수정 필요
   }
   
   private func createTagView(text: String) -> UIView {
       let containerView = UIView()
       containerView.backgroundColor = .white
       containerView.layer.cornerRadius = 15
       containerView.layer.borderWidth = 1
       containerView.layer.borderColor = UIColor.secondary.cgColor
       
       let label = UILabel()
       label.text = text
       label.textColor = .secondary
       label.font = .systemFont(ofSize: 14)
       label.textAlignment = .center
       
       containerView.addSubview(label)
       label.snp.makeConstraints { make in
           make.edges.equalToSuperview().inset(8)
       }
       
       return containerView
   }
   
   private func setupButton() {
       reportButton.setTitle("신고하기", for: .normal)
       reportButton.backgroundColor = .primary
       reportButton.layer.cornerRadius = 20
       reportButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
       reportButton.titleLabel?.font = .systemFont(ofSize: 16)
   }
   
   private func addSubviews() {
       view.addSubview(scrollView)
       scrollView.addSubview(contentView)
       contentView.addSubview(whiteCardView)
       whiteCardView.addSubview(reportButton)
       
       whiteCardView.addSubviews([titleLabel, statusTagsStackView, activityTimeLabel,
                               availableTimeLabel, availableTimeValueLabel,
                               timeStateLabel, timeStateValueLabel,
                               urgencyLabel, urgencyValueLabel,
                               techStackLabel, techStacksStackView,
                               projectTypeLabel, projectTypeStackView,
                               descriptionLabel, descriptionTextView,
                               reportButton])
   }
   
   private func setupConstraints() {
       scrollView.snp.makeConstraints { make in
           make.top.equalTo(view.safeAreaLayoutGuide)
           make.left.right.equalToSuperview()
           make.bottom.equalToSuperview()
       }
       
       contentView.snp.makeConstraints { make in
           make.edges.equalTo(scrollView.contentLayoutGuide)
           make.width.equalTo(scrollView.frameLayoutGuide)
       }
       
       whiteCardView.snp.makeConstraints { make in
           make.edges.equalToSuperview().inset(16)
       }
       
       titleLabel.snp.makeConstraints { make in
           make.top.left.right.equalToSuperview().inset(20)
       }
       
       statusTagsStackView.snp.makeConstraints { make in
           make.top.equalTo(titleLabel.snp.bottom).offset(16)
           make.left.right.equalToSuperview().inset(20)
       }
       
       activityTimeLabel.snp.makeConstraints { make in
           make.top.equalTo(statusTagsStackView.snp.bottom).offset(24)
           make.left.right.equalToSuperview().inset(20)
       }
       
       availableTimeLabel.snp.makeConstraints { make in
           make.top.equalTo(activityTimeLabel.snp.bottom).offset(16)
           make.left.equalToSuperview().inset(20)
       }
       
       availableTimeValueLabel.snp.makeConstraints { make in
           make.centerY.equalTo(availableTimeLabel)
           make.right.equalToSuperview().inset(20)
       }
       
       timeStateLabel.snp.makeConstraints { make in
           make.top.equalTo(availableTimeLabel.snp.bottom).offset(12)
           make.left.equalToSuperview().inset(20)
       }
       
       timeStateValueLabel.snp.makeConstraints { make in
           make.centerY.equalTo(timeStateLabel)
           make.right.equalToSuperview().inset(20)
       }
       
       urgencyLabel.snp.makeConstraints { make in
           make.top.equalTo(timeStateLabel.snp.bottom).offset(12)
           make.left.equalToSuperview().inset(20)
       }
       
       urgencyValueLabel.snp.makeConstraints { make in
           make.centerY.equalTo(urgencyLabel)
           make.right.equalToSuperview().inset(20)
       }
       
       techStackLabel.snp.makeConstraints { make in
           make.top.equalTo(urgencyLabel.snp.bottom).offset(24)
           make.left.right.equalToSuperview().inset(20)
       }
       
       techStacksStackView.snp.makeConstraints { make in
           make.top.equalTo(techStackLabel.snp.bottom).offset(12)
           make.left.right.equalToSuperview().inset(20)
       }
       
       projectTypeLabel.snp.makeConstraints { make in
           make.top.equalTo(techStacksStackView.snp.bottom).offset(24)
           make.left.right.equalToSuperview().inset(20)
       }
       
       projectTypeStackView.snp.makeConstraints { make in
           make.top.equalTo(projectTypeLabel.snp.bottom).offset(12)
           make.left.right.equalToSuperview().inset(20)
       }
       
       descriptionLabel.snp.makeConstraints { make in
           make.top.equalTo(projectTypeStackView.snp.bottom).offset(24)
           make.left.right.equalToSuperview().inset(20)
       }
       
       descriptionTextView.snp.makeConstraints { make in
           make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
           make.left.right.equalToSuperview().inset(20)
           make.height.equalTo(120)
           make.bottom.equalTo(reportButton.snp.top).offset(-16)
       }
       
       reportButton.snp.makeConstraints { make in
           make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
           make.centerX.equalToSuperview()
           make.bottom.equalToSuperview().inset(20)
           make.height.equalTo(40)
       }
   }
}

@available(iOS 17.0, *)
#Preview {
   PostDetailVC()
}
