//
//  PockemonDetailVC.swift
//  pokedex
//
//  Created by John on 19/09/16.
//  Copyright © 2016 Jelly Studio. All rights reserved.
//

import UIKit

class PockemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    // MARK: - Outlets

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var hightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var currentEvo: UIImageView!
    @IBOutlet weak var nextEvo: UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        nameLbl.text = pokemon.name
        typeLbl.text = pokemon.type
        defenceLbl.text = pokemon.defence
        hightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.attack
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        if pokemon.nextEvolutionId == "" {
            nextEvoLbl.text = ""
            nextEvo.hidden = true
        } else {
            nextEvo.hidden = false
            nextEvo.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
        
    }

    @IBAction func backButonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
