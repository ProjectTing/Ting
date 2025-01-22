//
//  TestPostUploadVC.swift
//  Ting
//
//  Created by 유태호 on 1/22/25.
//

import UIKit
import SnapKit

class TestPostUploadVC: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.93, alpha: 1.0)
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView = UIView()
    private var lastSectionView: UIView?
    
    // MARK: - Properties for Data
    private var selectedPositionType: String?
    private var selectedJob: String?
    private var selectedUrgency: String?
    private var selectedIdeaStatus: String?
    private var selectedRecruits: String?
    private var selectedSituation: String?
    private var selectedExperience: String?
    private let techStackTextField = UITextField() // 기술 스택용
    private let recruitsTextField = UITextField()  // 모집 인원용
    
    // TextField properties
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "내용을 입력해주세요"
        field.borderStyle = .roundedRect
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        field.layer.cornerRadius = 8
        return field
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시글 작성", for: .normal)
        button.backgroundColor = UIColor(red: 0.76, green: 0.18, blue: 0.07, alpha: 1.0)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    // 텍스트뷰 속성 추가
    private let experienceTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        textView.layer.cornerRadius = 8
        textView.text = "경험에 대해 자세히 설명해주세요"
        textView.textColor = .lightGray
        return textView
    }()
    
    private let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        textView.layer.cornerRadius = 8
        textView.text = "( 원하는 점 등 )"
        textView.textColor = .lightGray
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()     // 추가
        setupTextViewDelegates() // 추가
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.93, alpha: 1.0)
        
        setupScrollView()
        setupSections()
        setupSubmitButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-70)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    private func setupSections() {
        // 1. 게시글 구분 헤더
        let headerLabel = createLabel(text: "게시글 구분", size: 20, weight: .bold)
        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        lastSectionView = headerLabel
        
        // 2. 구인/구직 선택
        addSection(title: "구인/구직 선택", tags: ["구인", "구직"])
        
        // 3. 직무
        addSection(title: "직무", tags: ["개발", "기획", "디자인", "마케터", "데이터"])
        
        // 5. 기술 스택
        addSection(title: "기술 스택", isTextField: true, placeholder: "내용을 입력해주세요")
        
        // 6. 시급성
        addSection(title: "시급성", tags: ["급함", "보통", "여유로움"])
        
        // 7. 아이디어 상황
        addSection(title: "아이디어 상황", tags: ["구체적임", "모호함", "없음"])
        
        // 8. 모집 인원
        addSection(title: "모집 인원", isTextField: true, placeholder: "모집인원을 입력해주세요")
        
        // 9. 상황
        addSection(title: "상황", tags: ["온라인", "오프라인", "무관"])
        
        // 10. 경험
        addSection(title: "경험", tags: ["처음 입문", "재직중", "휴직중", "취준중"])
        
        // 11. 경험 설명 텍스트뷰
        contentView.addSubview(experienceTextView)
        experienceTextView.snp.makeConstraints { make in
            make.top.equalTo(lastSectionView!.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        lastSectionView = experienceTextView
        
        // 12. 제목
        addSection(title: "제목", isTextField: true, placeholder: "내용을 입력해주세요")
        
        // 13. 상세 내용
        contentView.addSubview(detailTextView)
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(lastSectionView!.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    private func addSection(title: String, tags: [String] = [], isTextField: Bool = false, placeholder: String = "") {
        let section = UIView()
        contentView.addSubview(section)
        
        let titleLabel = createLabel(text: title, size: 16, weight: .medium)
        section.addSubview(titleLabel)
        
        section.snp.makeConstraints { make in
            make.top.equalTo(lastSectionView!.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        if isTextField {
            let textField: UITextField
            // 섹션에 따라 적절한 텍스트필드 사용
            switch title {
            case "기술 스택":
                textField = techStackTextField
            case "모집 인원":
                textField = recruitsTextField
            case "제목":
                textField = titleTextField
            default:
                textField = createTextField(placeholder: placeholder)
            }
            
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
            textField.layer.cornerRadius = 8
            
            section.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(44)
            }
        } else {
            let stackView = createTagStackView(tags: tags, section: title)
            section.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        lastSectionView = section
    }
    
    // Helper methods for creating UI components...
    private func createLabel(text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = UIColor(red: 0.49, green: 0.18, blue: 0.07, alpha: 1.0)
        return label
    }
    
    private func createTagStackView(tags: [String], section: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        tags.forEach { tag in
            let button = createTagButton(title: tag, section: section)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    private func createTagButton(title: String, section: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.accessibilityIdentifier = section
        button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
        return button
    }
    
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        textField.layer.cornerRadius = 8
        return textField
    }
    
    private func createTextView(placeholder: String) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        textView.layer.cornerRadius = 8
        textView.text = placeholder
        textView.textColor = .lightGray
        return textView
    }
}

// MARK: - UITextView Delegate
extension TestPostUploadVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == experienceTextView {
                textView.text = "경험에 대해 자세히 설명해주세요"
            } else {
                textView.text = "( 원하는 점 등 )"
            }
            textView.textColor = .lightGray
        }
    }
}

// MARK: - Button Actions
extension TestPostUploadVC {
    @objc private func tagButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let section = sender.accessibilityIdentifier,
           let title = sender.title(for: .normal) {
            
            switch section {
            case "구인/구직 선택":
                selectedPositionType = sender.isSelected ? title : nil
                // 같은 섹션의 다른 버튼들 선택 해제
                if let stackView = sender.superview as? UIStackView {
                    for case let otherButton as UIButton in stackView.arrangedSubviews {
                        if otherButton != sender {
                            otherButton.isSelected = false
                            otherButton.backgroundColor = .white
                            otherButton.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
                        }
                    }
                }
                
            case "직무":
                selectedJob = sender.isSelected ? title : nil
                if let stackView = sender.superview as? UIStackView {
                    for case let otherButton as UIButton in stackView.arrangedSubviews {
                        if otherButton != sender {
                            otherButton.isSelected = false
                            otherButton.backgroundColor = .white
                            otherButton.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
                        }
                    }
                }

            case "시급성":
                selectedUrgency = sender.isSelected ? title : nil
                if let stackView = sender.superview as? UIStackView {
                    for case let otherButton as UIButton in stackView.arrangedSubviews {
                        if otherButton != sender {
                            otherButton.isSelected = false
                            otherButton.backgroundColor = .white
                            otherButton.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
                        }
                    }
                }

            case "아이디어 상황":
                selectedIdeaStatus = sender.isSelected ? title : nil
                if let stackView = sender.superview as? UIStackView {
                    for case let otherButton as UIButton in stackView.arrangedSubviews {
                        if otherButton != sender {
                            otherButton.isSelected = false
                            otherButton.backgroundColor = .white
                            otherButton.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
                        }
                    }
                }

            case "상황":
                selectedSituation = sender.isSelected ? title : nil
                if let stackView = sender.superview as? UIStackView {
                    for case let otherButton as UIButton in stackView.arrangedSubviews {
                        if otherButton != sender {
                            otherButton.isSelected = false
                            otherButton.backgroundColor = .white
                            otherButton.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
                        }
                    }
                }

            case "경험":
                selectedExperience = sender.isSelected ? title : nil
                if let stackView = sender.superview as? UIStackView {
                    for case let otherButton as UIButton in stackView.arrangedSubviews {
                        if otherButton != sender {
                            otherButton.isSelected = false
                            otherButton.backgroundColor = .white
                            otherButton.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
                        }
                    }
                }

            default:
                break
            }
            
            // 버튼 상태에 따른 UI 업데이트
            if sender.isSelected {
                sender.backgroundColor = UIColor(red: 0.76, green: 0.18, blue: 0.07, alpha: 1.0)
                sender.setTitleColor(.white, for: .normal)
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0), for: .normal)
            }
            
            // 선택된 태그 출력
            print("Selected tag in section \(section): \(title)")
        }
    }
    
    // submitButtonTapped 함수 수정
    @objc private func submitButtonTapped() {
        print("=== 입력된 내용 ===")
        print("구인/구직: \(selectedPositionType ?? "미선택")")
        print("직무: \(selectedJob ?? "미선택")")
        print("기술 스택: \(techStackTextField.text ?? "미입력")")
        print("시급성: \(selectedUrgency ?? "미선택")")
        print("아이디어 상황: \(selectedIdeaStatus ?? "미선택")")
        print("모집 인원: \(recruitsTextField.text ?? "미입력")")
        print("상황: \(selectedSituation ?? "미선택")")
        print("경험: \(selectedExperience ?? "미선택")")
        print("경험 설명: \(experienceTextView.text ?? "")")
        print("제목: \(titleTextField.text ?? "")")
        print("상세 내용: \(detailTextView.text ?? "")")
        print("==================")
    }
}

// MARK: - Private Methods
private extension TestPostUploadVC {
    func setupButtonActions() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    func setupTextViewDelegates() {
        experienceTextView.delegate = self
        detailTextView.delegate = self
    }
}


@available(iOS 17.0, *)
#Preview {
    TestPostUploadVC()
}
