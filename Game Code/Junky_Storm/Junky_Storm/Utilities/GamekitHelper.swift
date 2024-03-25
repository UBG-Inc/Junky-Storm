//
//  GamekitHelper.swift
//  Junky_Storm
//
//  Created by Francesco De Stasio on 27/06/23.
//

import Foundation
import GameKit

protocol GameCenterHelperDelegate: AnyObject {
    func didChangeAuthStatus(isAuthenticated: Bool)
    func presentGameCenterAuth(viewController: UIViewController?)
}

final class GamekitHelper: NSObject, GKGameCenterControllerDelegate, GKLocalPlayerListener {
    weak var delegate: GameCenterHelperDelegate?
    
    static var shared : GamekitHelper = GamekitHelper()
    
    var isAuthenticated : Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    var authenticationViewController : UIViewController?
    var lastError: Error?
    var gameCenterEnabled: Bool
    
    private override init(){
        gameCenterEnabled = true
        super.init()
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticatePlayer(){
        GKLocalPlayer.local.authenticateHandler = { (gcAuthVC, error) in
            self.delegate?.didChangeAuthStatus(isAuthenticated: self.isAuthenticated)
            
            guard GKLocalPlayer.local.isAuthenticated else {
                self.delegate?.presentGameCenterAuth(viewController: gcAuthVC)
                return
            }
            GKLocalPlayer.local.register(self)
        }
    }
    
    func showLeader(view: UIViewController){
        if GKLocalPlayer.local.isAuthenticated {
            let localPlayer = GKLocalPlayer.local
            
            if localPlayer.isAuthenticated {
                let vc = view
                let gc = GKGameCenterViewController()
                gc.gameCenterDelegate = self
                vc.present(gc,animated: true, completion: nil)
            }
        }
    }
    
    // HOW TO REPORT ACHIEVEMENTS
    func reportAchievements(achivements: [GKAchievement]){
        
        if !gameCenterEnabled {
            print("DEBUG: Local player is not authenticated")
            return
        }
        GKAchievement.report(achivements) { (error: Error?) -> Void in
            if error != nil {
                print("DEBUG: \(error)")
            }else{
                print("DEBUG: achievements reported")
            }
        }
    }
    
}
