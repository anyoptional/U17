//
//  SwiftyHUD.swift
//  Fate
//
//  Created by Archer on 2018/12/8.
//

import SwiftMessages

public struct SwiftyHUD {
    
    public static func show(_ body: String,
                            theme: Theme = .warning,
                            layout: MessageView.Layout = .cardView,
                            dimMode: SwiftMessages.DimMode = .none,
                            duration: SwiftMessages.Duration = .automatic,
                            presentationStyle: SwiftMessages.PresentationStyle = .top,
                            presentationContext: SwiftMessages.PresentationContext = .window(windowLevel: .normal)) {
        let view = MessageView.viewFromNib(layout: layout)
        view.configureTheme(theme, iconStyle: .default)
        view.accessibilityPrefix = "\(theme)"
        view.configureContent(body: body)
        view.titleLabel?.isHidden = true
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.dimMode = dimMode
        config.duration = duration
        config.interactiveHide = false
        config.presentationStyle = presentationStyle
        config.presentationContext = presentationContext
        SwiftMessages.show(config: config, view: view)
    }
    
}
