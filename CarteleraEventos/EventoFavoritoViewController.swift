//
//  EventoFavoritoViewController.swift
//  
//
//  Created by Esteban Arocha Ortuño on 4/6/18.
//

import UIKit
import CoreData

class EventoFavoritoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocoloModificarFavorito {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buscaFavoritos()
        for eve in GlobalVar.arrEventsGlobal
        {
            if (arrIndFav.contains(eve.id))
            {
                eve.favorites = true
            }
        }
        arrEventos = GlobalVar.arrEventsGlobal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modificaFavorito(fav: Bool, ide: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<EventosFavoritos>(entityName: "EvenFavoritos")
        
        let predicado = NSPredicate(format: "(ident = %@)", String(ide))
        fetchRequest.predicate = predicado
        
        var resultados : [EventosFavoritos]!
        
        do {
            resultados = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print ("Error al leer \(error) \(error.userInfo)")
        }
        
        if (resultados.count == 0 && fav)
        {
            //Guardarlo
            let favEv = EventosFavoritos(context: managedContext)
            
            favEv.setValue(ide, forKey: "ident")
            
        }
        else if (resultados.count > 0 && !fav)
        {
            //Quitarlo
            managedContext.delete(resultados[0])
            
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("El fav no fue guardado")
            print("Error \(error) \(error.userInfo)")
        }
    }
    
    var arrIndFav = [Int]()
    func buscaFavoritos()
    {
        arrIndFav.removeAll()
        arrEventosFav.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<EventosFavoritos>(entityName: "EvenFavoritos")
        
        let predicado = NSPredicate(format: "(ident > 0)")
        fetchRequest.predicate = predicado
        
        var resultados : [EventosFavoritos]!
        
        do {
            resultados = try managedContext.fetch(fetchRequest)
            for res in resultados
            {
                arrIndFav.append(Int(res.ident))
            }
        } catch let error as NSError {
            print ("Error al leer \(error) \(error.userInfo)")
        }
        
    }
    
    @IBOutlet weak var eventosTableView: UITableView!
    var arrEventos = [Evento]()
    var indSelected = 0
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    var arrEventosFav = [Evento]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        for fav in arrEventos
        {
            if (arrIndFav.contains(fav.id))
            {
                arrEventosFav.append(fav)
            }
        }
        return arrEventosFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CustomTableViewCell
        
        cell.location.text = arrEventosFav[indexPath.row].location
        cell.name.text = arrEventosFav[indexPath.row].name
        //cell.startDate.text = String(describing: arrEventos[indexPath.row].startDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "es_MX")
        cell.startDate.text = dateFormatter.string(from: arrEventosFav[indexPath.row].startDate)
        //cell.startTime.text = String(describing: arrEventos[indexPath.row].startTime)
        cell.startTime.text = arrEventosFav[indexPath.row].startTime
        cell.foto.image = arrEventosFav[indexPath.row].foto
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mostrar")
        {
            let vistaDetalle = segue.destination as! FavDetalleViewController
            let indexPath = eventosTableView.indexPathForSelectedRow!
            //vistaDetalle.eveTemp.foto = arrEventos[indexPath.row].foto
            vistaDetalle.eveTemp = arrEventosFav[indexPath.row]
            eventosTableView.deselectRow(at: indexPath, animated: true)
            vistaDetalle.delegado = self
            indSelected = indexPath.row
        }
    }
    
    @IBAction func unwindDetalle(for segue: UIStoryboardSegue, sender: Any?){
        buscaFavoritos()
        eventosTableView.reloadData()
        GlobalVar.arrEventsGlobal = arrEventos
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arrEventos = GlobalVar.arrEventsGlobal
        buscaFavoritos()
        eventosTableView.reloadData()
    }
    
}
