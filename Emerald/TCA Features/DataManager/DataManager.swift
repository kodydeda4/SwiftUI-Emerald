//
//  DataManager.swift
//  Emerald
//
//  Created by Kody Deda on 2/17/21.
//

import ComposableArchitecture

struct DataManager {
    struct State: Equatable {
        var yabaiSettings = YabaiSettings.State()
        var skhdSettings = SKHDSettings.State()
        var animationSettings = AnimationSettings.State()
        var error: Error = .none
        
        enum Error {
            case saveYabaiSettings
            case loadYabaiSettings
            case exportYabaiConfig
            
            case saveSKHDSettings
            case loadSKHDSettings
            case exportSKHDConfig
            
            case saveAnimationSettings
            case loadAnimationSettings
            case exportAnimationConfig

            case none
        }
    }
    
    enum Action: Equatable {
        case yabaiSettings(YabaiSettings.Action)
        case saveYabaiSettings
        case loadYabaiSettings
        case exportYabaiConfig
        
        case skhdSettings(SKHDSettings.Action)
        case saveSKHDSettings
        case loadSKHDSettings
        case exportSKHDConfig
        
        case animationSettings(AnimationSettings.Action)
        case saveAnimationSettings
        case loadAnimationSettings
        case exportAnimationConfig
    }
    
    struct Environment {
        //MARK:- YABAI
        
        let yabaiStateURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("YabaiState.json")
        
        let yabaiURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent(".yabairc")
        
        func encodeYabaiSettings(_ state: YabaiSettings.State) -> Result<Bool, Error> {
            do {
                try JSONEncoder()
                    .encode(state)
                    .write(to: yabaiStateURL)
                return .success(true)
            } catch {
                return .failure(error)
            }
        }
        func decodeYabaiSettings(_ state: YabaiSettings.State) -> Result<(YabaiSettings.State), Error> {
            do {
                let decoded = try JSONDecoder()
                    .decode(YabaiSettings.State.self, from: Data(contentsOf: yabaiStateURL))
                return .success(decoded)
            }
            catch {
                return .failure(error)
            }
        }
        func exportYabaiConfig(_ yabaiSettingsState: YabaiSettings.State) -> Result<Bool, Error> {
            do {
                let data: String = yabaiSettingsState.asConfig
                try data.write(to: yabaiURL, atomically: true, encoding: .utf8)
                
                return .success(true)
            }
            catch {
                return .failure(error)
            }
        }
        
        //MARK:- SKHD
        
        let skhdStateURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("SKHDState.json")

        
        let skhdURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent(".skhdrc")
        
        func encodeSKHDSettings(_ state: SKHDSettings.State) -> Result<Bool, Error> {
            do {
                try JSONEncoder()
                    .encode(state)
                    .write(to: skhdStateURL)
                return .success(true)
            } catch {
                return .failure(error)
            }
        }
        func decodeSKHDSettings(_ state: SKHDSettings.State) -> Result<(SKHDSettings.State), Error> {
            do {
                let decoded = try JSONDecoder()
                    .decode(SKHDSettings.State.self, from: Data(contentsOf: skhdStateURL))
                return .success(decoded)
            }
            catch {
                return .failure(error)
            }
        }
        func exportSKHDConfig(_ skhdSettingsState: SKHDSettings.State) -> Result<Bool, Error> {
            do {
                let data: String = skhdSettingsState.asConfig
                try data.write(to: skhdURL, atomically: true, encoding: .utf8)
                
                return .success(true)
            }
            catch {
                return .failure(error)
            }
        }
        
        //MARK:- ANIMATIONS
            
        let animationStateURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("AnimationState.json")
        
        let animationURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent(".animationSettingsRC.sh")
        
        func encodeAnimationSettings(_ state: AnimationSettings.State) -> Result<Bool, Error> {
            do {
                try JSONEncoder()
                    .encode(state)
                    .write(to: animationStateURL)
                return .success(true)
            } catch {
                return .failure(error)
            }
        }
        func decodeAnimationSettings(_ state: AnimationSettings.State) -> Result<(AnimationSettings.State), Error> {
            do {
                let decoded = try JSONDecoder()
                    .decode(AnimationSettings.State.self, from: Data(contentsOf: animationStateURL))
                return .success(decoded)
            }
            catch {
                return .failure(error)
            }
        }
        func exportAnimationConfig(_ animationSettingsState: AnimationSettings.State) -> Result<Bool, Error> {
            do {
                let data: String = animationSettingsState.asConfig
                try data.write(to: animationURL, atomically: true, encoding: .utf8)
                
                return .success(true)
            }
            catch {
                return .failure(error)
            }
        }
    }
}

extension DataManager {
    static let reducer = Reducer<State, Action, Environment>.combine(
        YabaiSettings.reducer.pullback(
            state: \.yabaiSettings,
            action: /DataManager.Action.yabaiSettings,
            environment: { _ in () }
        ),
        SKHDSettings.reducer.pullback(
            state: \.skhdSettings,
            action: /DataManager.Action.skhdSettings,
            environment: { _ in () }
        ),
        AnimationSettings.reducer.pullback(
            state: \.animationSettings,
            action: /DataManager.Action.animationSettings,
            environment: { _ in () }
        ),
        Reducer { state, action, environment in
            switch action {
            
            // MARK:- YABAI
            case let .yabaiSettings(subAction):
                return Effect(value: .saveYabaiSettings)
                    
            case .saveYabaiSettings:
                switch environment.encodeYabaiSettings(state.yabaiSettings) {
                case .success:
                    state.error = .none
                case let .failure(error):
                    state.error = .saveYabaiSettings
                }
                return .none
                
            case .loadYabaiSettings:
                switch environment.decodeYabaiSettings(state.yabaiSettings) {
                case let .success(decoded):
                    state.yabaiSettings = decoded
                case let .failure(error):
                    state.error = .loadYabaiSettings
                }
                return .none
                
            case .exportYabaiConfig:
                switch environment.exportYabaiConfig(state.yabaiSettings) {
                case .success:
                    state.error = .none
                case let .failure(error):
                    state.error = .exportYabaiConfig
                }
                return .none
                
            // MARK:- SKHD
            
            case let .skhdSettings(subAction):
                return Effect(value: .saveSKHDSettings)
                    
            case .saveSKHDSettings:
                switch environment.encodeSKHDSettings(state.skhdSettings) {
                case .success:
                    state.error = .none
                case let .failure(error):
                    state.error = .saveSKHDSettings
                }
                return .none
                
            case .loadSKHDSettings:
                switch environment.decodeSKHDSettings(state.skhdSettings) {
                case let .success(decoded):
                    state.skhdSettings = decoded
                case let .failure(error):
                    state.error = .loadSKHDSettings
                }
                return .none
                
            case .exportSKHDConfig:
                switch environment.exportSKHDConfig(state.skhdSettings) {
                case .success:
                    state.error = .none
                case let .failure(error):
                    state.error = .exportSKHDConfig
                }
                return .none
            
            // MARK:- ANIMATIONS
            case let .animationSettings(subAction):
                return Effect(value: .saveAnimationSettings)
                    
            case .saveAnimationSettings:
                switch environment.encodeAnimationSettings(state.animationSettings) {
                case .success:
                    state.error = .none
                case let .failure(error):
                    state.error = .saveAnimationSettings
                }
                return .none
                
            case .loadAnimationSettings:
                switch environment.decodeAnimationSettings(state.animationSettings) {
                case let .success(decoded):
                    state.animationSettings = decoded
                case let .failure(error):
                    state.error = .loadAnimationSettings
                }
                return .none
                
            case .exportAnimationConfig:
                switch environment.exportAnimationConfig(state.animationSettings) {
                case .success:
                    state.error = .none
                case let .failure(error):
                    state.error = .exportAnimationConfig
                }
                return .none
            }
        }
    )
}

extension DataManager {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}
