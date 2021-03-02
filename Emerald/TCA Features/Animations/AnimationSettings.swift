//
//  Animations.swift
//  Emerald
//
//  Created by Kody Deda on 2/18/21.
//

// Disable OSX Animations: https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x

import SwiftUI
import ComposableArchitecture

struct AnimationSettings {
    struct State: Equatable, Codable {
        var allEnabled: Bool = true
        
    }
    enum Action: Equatable {
        case keyPath(BindingAction<AnimationSettings.State>)
    }
}

extension AnimationSettings {
    static let reducer = Reducer<State, Action, Void> {
        state, action, _ in
        switch action {
        case .keyPath:
            return .none
        }
    }
    .binding(action: /Action.keyPath)
}

extension AnimationSettings {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: ()
    )
}

extension AnimationSettings.State {
    var asConfig: String {
        let divStr = "#==================================================================================="
        
        var header: [String] {
            [
                "#!/bin/bash",
                "#",
                "#  █████╗ ███╗   ██╗██╗███╗   ███╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗",
                "# ██╔══██╗████╗  ██║██║████╗ ████║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝",
                "# ███████║██╔██╗ ██║██║██╔████╔██║███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗",
                "# ██╔══██║██║╚██╗██║██║██║╚██╔╝██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║",
                "# ██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║",
                "# ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝",
                "#",
                "",
            ]
        }
        
        var body: [String] {
            if allEnabled {
                return [
                    divStr,
                    "# Enabled Animations",
                    divStr,
                    "defaults delete -g NSAutomaticWindowAnimationsEnabled",
                    "defaults delete -g NSScrollAnimationEnabled",
                    "defaults delete -g NSWindowResizeTime",
                    "defaults delete -g QLPanelAnimationDuration",
                    "defaults delete -g NSScrollViewRubberbanding",
                    "defaults delete -g NSDocumentRevisionsWindowTransformAnimation",
                    "defaults delete -g NSToolbarFullScreenAnimationDuration",
                    "defaults delete -g NSBrowserColumnAnimationSpeedMultiplier",
                    "defaults delete com.apple.dock autohide-time-modifier",
                    "defaults delete com.apple.dock autohide-delay",
                    "defaults delete com.apple.dock expose-animation-duration",
                    "defaults delete com.apple.dock springboard-show-duration",
                    "defaults delete com.apple.dock springboard-hide-duration",
                    "defaults delete com.apple.dock springboard-page-duration",
                    "defaults delete com.apple.finder DisableAllAnimations",
                    "defaults delete com.apple.Mail DisableSendAnimations",
                    "defaults delete com.apple.Mail DisableReplyAnimations",
                    "killall Dock",
                ]
            } else {
                return [
                    divStr,
                    "# Disabled Animations",
                    divStr,
                    "defaults write -g NSAutomaticWindowAnimationsEnabled -bool false",
                    "defaults write -g NSScrollAnimationEnabled -bool false",
                    "defaults write -g NSWindowResizeTime -float 0.001",
                    "defaults write -g QLPanelAnimationDuration -float 0",
                    "defaults write -g NSScrollViewRubberbanding -bool false",
                    "defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false",
                    "defaults write -g NSToolbarFullScreenAnimationDuration -float 0",
                    "defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0",
                    "defaults write com.apple.dock autohide-time-modifier -float 0",
                    "defaults write com.apple.dock autohide-delay -float 0",
                    "defaults write com.apple.dock expose-animation-duration -float 0",
                    "defaults write com.apple.dock springboard-show-duration -float 0",
                    "defaults write com.apple.dock springboard-hide-duration -float 0",
                    "defaults write com.apple.dock springboard-page-duration -float 0",
                    "defaults write com.apple.finder DisableAllAnimations -bool true",
                    "defaults write com.apple.Mail DisableSendAnimations -bool true",
                    "defaults write com.apple.Mail DisableReplyAnimations -bool true",
                    "killall Dock",
                ]
            }
        }
        return Array(header + body).joined(separator: "\n")
    }
}
