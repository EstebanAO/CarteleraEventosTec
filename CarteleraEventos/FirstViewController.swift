//
//  FirstViewController.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/13/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit

struct evenStruct : Decodable{
    var id : Int
    var photo : String?
    var name : String?
    var startDate : String
    var startTime : String
    var location : String?
    init(json: [String: Any]){
        id = json["\"id\""] as? Int ?? -1
        photo = json["\"photo\""] as? String ?? ""
        name = json["\"name\""] as? String ?? ""
        startDate = json["\"startDate\""] as? String ?? ""
        startTime = json["\"startTime\""] as? String ?? ""
        location = json["\"location\""] as? String ?? ""
    }
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocoloModificarFavorito {
    
    func modificaFavorito(fav: Bool) {
        arrEventos[indSelected].favorites = fav
    }
    
    
    @IBOutlet weak var eventosTableView: UITableView!
    var arrEveStr = [evenStruct]()
    var arrEventos = [Evento]()
    var indSelected = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "https://cartelera-api.herokuapp.com/events/"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString as Any)
            do{
                let jsonTodosEventos = try JSONDecoder().decode([evenStruct].self, from: data)
                self.arrEveStr = jsonTodosEventos
                for eve in self.arrEveStr
                {
                    let eventoTemp = Evento(ide: String(describing: eve.id), fotoURL: eve.photo, name: eve.name!, startDate: eve.startDate, startTime: eve.startTime, location: eve.location)
                    self.arrEventos.append(eventoTemp)
                }
                self.eventosTableView.reloadData()
            } catch let jsonErr{
                print("Error serializando json:", jsonErr)
            }
            }.resume()
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












