//
//  User.swift
//  Tester3_NC2
//
//  Created by Francesco De Stasio on 10/12/22.
//

import Foundation

enum PlayerName : String, CaseIterable{
    case monkey = "Monkey"
    case coolGuy = "CoolGuy"
    case alien = "Alien"
    case killer = "Killer"
    case noob = "Noob"
}

class User: Codable{
    
    var indexName : String = "indexName"
    var name : String = ""
    var score: Int = 0
    var distance: Int = 0
    
    init(score: Int, distance: Int){
        self.score = score
        self.distance = distance
        self.name = randomUniqName()
    }
    
    func randomUniqName() -> String{
        let index = UserDefaults.standard.integer(forKey: indexName)
        var name: String = PlayerName.allCases.randomElement()!.rawValue
        var newIndex : Int = 0
        if(index == nil){
            UserDefaults.standard.set(0, forKey: indexName)
        }else{
            newIndex = index + 1
            UserDefaults.standard.set(newIndex, forKey: indexName)
        }
        return name + "\(newIndex)"
    }
    
    public func setDistance(distance: Int){
        self.distance = distance
    }
    public func setScore(score: Int){
        self.score = score
    }
}
