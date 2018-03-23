//
//  FirstViewController.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/13/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocoloModificarFavorito {
    
    func modificaFavorito(fav: Bool) {
        arrEventos[indSelected].favorites = fav
    }
    
    
    @IBOutlet weak var eventosTableView: UITableView!
    var arrEventos = [Evento]()
    var indSelected = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.getEvents { (arrEventos) in
            self.arrEventos = arrEventos
            self.eventosTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrEventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CustomTableViewCell
        
        cell.location.text = arrEventos[indexPath.row].location
        cell.name.text = arrEventos[indexPath.row].name
        //cell.startDate.text = String(describing: arrEventos[indexPath.row].startDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "es_MX")
        cell.startDate.text = dateFormatter.string(from: arrEventos[indexPath.row].startDate)
        //cell.startTime.text = String(describing: arrEventos[indexPath.row].startTime)
        cell.startTime.text = arrEventos[indexPath.row].startTime
        cell.foto.image = arrEventos[indexPath.row].foto
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mostrar")
        {
            let vistaDetalle = segue.destination as! DetalleViewController
            let indexPath = eventosTableView.indexPathForSelectedRow!
            //vistaDetalle.eveTemp.foto = arrEventos[indexPath.row].foto
            vistaDetalle.eveTemp = arrEventos[indexPath.row]
            eventosTableView.deselectRow(at: indexPath, animated: true)
            vistaDetalle.delegado = self
            indSelected = indexPath.row
        }
    }
    
    @IBAction func unwindDetalle(for segue: UIStoryboardSegue, sender: Any?){
        
    }
    
}












