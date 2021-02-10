//
//  Yabai.swift
//  YabaiUI
//
//  Created by Kody Deda on 2/10/21.
//

import SwiftUI
import ComposableArchitecture

//MARK:- Yabai
//https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc#612-global-settings

struct Yabai {
    struct State: Equatable, Codable {
        var yabaiString: String = ""
    }
    
    enum Action: Equatable {
        case updateYabaiString(String)
    }
    
    struct Environment {
        // environment
    }
}

extension Yabai {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case let .updateYabaiString(string):
                state.yabaiString = string
                return .none
            }
        }
    )
}

extension Yabai {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}

// MARK:- YabaiView

struct YabaiView: View {
    let store: Store<Yabai.State, Yabai.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Text("YabaiString")
                    .foregroundColor(.gray)
                
                TextField("Untitled", text: viewStore.binding(
                    get: \.yabaiString,
                    send: Yabai.Action.updateYabaiString
                ))
            }
        }
    }
}

struct YabaiView_Previews: PreviewProvider {
    static var previews: some View {
        YabaiView(store: Yabai.defaultStore)
    }
}