//
//  U17SearchBar.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Fate
import RxSwift
import RxCocoa

class U17SearchBar: U17TextField {
    
    fileprivate lazy var clearButton: UIButton = {
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
        textColor = U17def.gray_BABABA
        cursorColor = U17def.green_30DC91
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = U17def.gray_F2F2F2
        placeholderColor = U17def.gray_BABABA
        placeholderFont = UIFont.systemFont(ofSize: 13)
        textAreaInset = U17PositionInsetMake(height / 2, height / 2)
        
        // config right view
        rightViewMode = .always
        rightView = clearButton
        rightViewInset = U17RectInsetMake(height / 2 - 2, (height - 14.5) / 2, 14.5)
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
            clearButton.isHidden = replacedString.isBlank
        }
        return true
    }
}

extension Reactive where Base: U17SearchBar {
    var clear: Observable<Void> {
        return base.clearButton.rx.tap
            .do(onNext: { [weak base] in
                base?.text = nil
                base?.clearButton.isHidden = true
            })
    }
    
    var placeholderText: Binder<String> {
        return Binder(base) { (searchBar, placeholderText) in
            searchBar.placeholderText = placeholderText
        }
    }
}
