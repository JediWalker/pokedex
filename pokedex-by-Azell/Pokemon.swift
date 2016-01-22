//
//  Pokemon.swift
//  pokedex-by-Azell
//
//  Created by Marcel Canhisares on 21/01/16.
//  Copyright © 2016 Azell. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    var name: String {
        get{
            if _name == nil {
                _name =  ""
            }
            return _name
        }
    }
    var pokedexID:Int {
        get{
            if _pokedexID == nil {
                _pokedexID = 0
            }
            return _pokedexID
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    var type: String? {
        get{
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    var defense: String{
        get{
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    var height: String{
        get{
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }
    
    var weight: String {
        get{
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    var attack: String {
        get{
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    var nextEvolutionID: String {
        get{
            if _nextEvolutionID == nil {
                _nextEvolutionID = ""
            }
            return _nextEvolutionID
        }
    }
    var nextEvolutionLvl: String {
        get{
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    var nextEvolutionTxt: String{
        get{
            if _nextEvolutionTxt == nil {
                _nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
    }
    var pokemonURL: String{
        get{
            return _pokemonURL
        }
    }
    
    
    init(name: String, pokedexID: Int){
        self._name = name
        self._pokedexID = pokedexID
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(_pokedexID)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                    }
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = " "
                }
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, descURL).responseJSON{ response in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                                
                            }
                            completed()
                        }
                        
                    }
                } else {
                    self._description = ""
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String{
                        //Mega is not found, app does not suport mega evolutions
                        //Api still has mega data
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "").stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = newStr
                                self._nextEvolutionTxt = to
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionID)
                                print(self._nextEvolutionTxt)
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
}