//
//  Pokemon.swift
//  pokedex
//
//  Created by John on 17/09/16.
//  Copyright © 2016 Jelly Studio. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name = ""
    private var _pokedexId: Int!
    private var _description = ""
    private var _type = ""
    private var _defence = ""
    private var _height = ""
    private var _weight = ""
    private var _attack = ""
    private var _nextEvolutionText = ""
    private var _nextEvolutionId = ""
    private var _nextEvolutionLvl = ""
    private var _pokemonUrl = ""
    
    var description: String {
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var defence: String {
        return _defence
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var attack: String {
        return _attack
    }
    
    var nextEvolutionText: String {
        return _nextEvolutionText
    }
    
    var nextEvolutionId: String {
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        return _nextEvolutionLvl
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (response: Response<AnyObject, NSError>) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defence = dict["defence"] as? Int {
                    self._defence = "\(defence)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = "\(name)"
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let secondName = types[x]["name"] {
                                self._type = "\(self._type)/\(secondName)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                            if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descriptionDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        // cant support mega pokemon
                        // api still has mega
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon", withString: "")
                                let num  = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(level)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}