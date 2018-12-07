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
        
        // 搜狗键盘在点击删除按钮删除完的时候
        // 不会走下面的delegate回调
        // 在这里也绑定一下
        rx.text.orEmpty
            .subscribeNext(weak: self) { (self) in
                return { (text) in
                    self.clearButton.isHidden = text.isBlank
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
            clearButton.isHidden = replacedString.isBlank
        }
        return true
    }
}

/// 元素类型定义为fileprivate可以很好的保护封装性
/// 采用给Reactive加扩展的方式，完美替代delegate模式
extension Reactive where Base: U17SearchBar {
    
    /// clear button的点击事件
    var clear: Observable<Void> {
        return base.clearButton.rx.tap
            .do(onNext: { [weak base] in
                base?.text = nil
                base?.clearButton.isHidden = true
            })
    }
    
    /// 包装searchBar的placeholderText属性
    var placeholderText: Binder<String> {
        return Binder(base) { (searchBar, placeholderText) in
            searchBar.placeholderText = placeholderText
        }
    }
}
