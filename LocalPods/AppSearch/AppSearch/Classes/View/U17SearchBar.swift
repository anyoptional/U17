//
//  U17SearchBar.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Fate

class U17SearchBar: U17TextField {
    
    private lazy var deleteButton: UIButton = {
        let v = UIButton()
        v.isHidden = true
        let image = UIImage(nameInBundle: "search_cancel")
        v.setBackgroundImage(image, for: .normal)
        return v
    }()
    
    init(size: CGSize) {
        super.init(.custom)
        self.size = size
        delegate = self
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        textColor = U17def.gray_C5C5C5
        cursorColor = U17def.green_30DC91
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = U17def.gray_EEEEEE
        placeholderColor = U17def.gray_C5C5C5
        placeholderFont = UIFont.systemFont(ofSize: 13)
        textAreaInset = U17PositionInsetMake(height / 2, height / 2)
        
        // config right view
        rightViewMode = .always
        rightView = deleteButton
        rightViewInset = U17RectInsetMake(height / 2 - 2, (height - 14.5) / 2, 14.5)
        
        deleteButton.rx.tap
            .subscribeNext(weak: self) { (self) in
                return { _ in
                    self.text = nil
                    self.deleteButton.isHidden = true
                }
            }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension U17SearchBar: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            let replacingString = textField.text ?? ""
            let replacedString = castOrFatal(replacingString, NSString.self).replacingCharacters(in: range, with: string)
            deleteButton.isHidden = replacedString.isBlank
        }
        return true
    }
}
