import UIKit
import SnapKit

class RadioButton: UIView {
    private let outerCircle = UIView()
    private let innerCircle = UIView()
    
    var onSelect: (() -> Void)?
    var isChecked: Bool = false {
        didSet { updateSelection() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        outerCircle.backgroundColor = .clear
        outerCircle.layer.borderWidth = 2
        outerCircle.layer.borderColor = UIColor.systemBlue.cgColor
        outerCircle.layer.cornerRadius = 10
        
        innerCircle.backgroundColor = .systemBlue
        innerCircle.layer.cornerRadius = 7
        innerCircle.alpha = 0
        
        addSubview(outerCircle)
        addSubview(innerCircle)
        
        outerCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        innerCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(14)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("Radio button touched!")
        isChecked.toggle()
        onSelect?()
    }
    
    private func updateSelection() {
        UIView.animate(withDuration: 0.2) {
            self.innerCircle.alpha = self.isChecked ? 1 : 0
        }
    }
}

class RadioButtonGroup {
    private var radioButtons: [RadioButton] = []
    var selectedIndex: Int? {
        didSet {
            radioButtons.enumerated().forEach { index, button in
                button.isChecked = index == selectedIndex
            }
        }
    }
    
    func addButton(_ button: RadioButton) {
        button.onSelect = { [weak self] in
            guard let index = self?.radioButtons.firstIndex(of: button) else { return }
            self?.selectedIndex = index
        }
        radioButtons.append(button)
    }
}

@available(iOS 17.0, *)
#Preview {
    let container = UIView()
    container.backgroundColor = .white
    
    let radioGroup = RadioButtonGroup()
    let options = ["Option 1", "Option 2", "Option 3"]
    var previousButton: UIView?
    
    let centerContainer = UIView()
    container.addSubview(centerContainer)
    
    centerContainer.snp.makeConstraints { make in
        make.center.equalToSuperview()
    }
    
    for title in options {
        let buttonContainer = UIView()
        centerContainer.addSubview(buttonContainer)
        
        let radioButton = RadioButton()
        let label = UILabel()
        label.text = title
        
        buttonContainer.addSubview(radioButton)
        buttonContainer.addSubview(label)
        
        buttonContainer.snp.makeConstraints { make in
            if let previousButton = previousButton {
                make.top.equalTo(previousButton.snp.bottom).offset(16)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        radioButton.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(radioButton.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        radioGroup.addButton(radioButton)
        previousButton = buttonContainer
    }
    
    return container
}
