//
//  ViewController.swift
//  FirebaseDataBase
//
//  Created by Maria Lacayo on 12/03/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var usuario: [User] = []
    
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traerUsuariosRT() //RealTime
        // Do any additional setup after loading the view.
    }

    @IBAction func agregarUsuario(_ sender: UIButton) {
        muestraFormularioEnDialogo()
    }
    
    
    //FIMCOPM CONECTADO CON FIREBASE PERO NO ES EN TIEMPO REAL
    func traerUsuarios(){
        db.collection("users").getDocuments{(snapshot,error) in
            if let error=error{
                print("Error al obtener la lista: \(error.localizedDescription)")
            }else{
                for document in snapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    let id = document.documentID as? String ?? ""
                    let diccionario = document.data()
                    let nombre = diccionario["nombre"] as? String ?? "Sin Nombre"
                    let edad = diccionario["edad"] as? Int ?? 0
                    
                    let userTemp = User(id: id, nombre: nombre, edad: edad)
                    self.usuario.append(userTemp)
                }
                self.tabla.reloadData()
            }
            
        }
    }
    
    //FUNCION EN TIEMPO REAL CON FIREBASE
    func traerUsuariosRT(){
        db.collection("users").order(by:"nombre").addSnapshotListener{(snapshot,error) in
            if let error=error{
                print("Error al obtener la lista: \(error.localizedDescription)")
            }else{
                self.usuario.removeAll()
                for document in snapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    let id = document.documentID as? String ?? ""
                    let diccionario = document.data()
                    let nombre = diccionario["nombre"] as? String ?? "Sin Nombre"
                    let edad = diccionario["edad"] as? Int ?? 0
                    
                    let userTemp = User(id: id, nombre: nombre, edad: edad)
                    self.usuario.append(userTemp)
                }
                self.tabla.reloadData()
            }
            
        }
    }
    
    func muestraFormularioEnDialogo(){
        
        var name: UITextField!
        var age: UITextField!
        
        let alertController = UIAlertController(title: "Datos del usuario", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Agregar", style: .default) { (action) in
            
            let nombre = name.text ?? ""
            let edad = Int(age.text!) ?? 0
            
            self.ref = self.db.collection("users").addDocument(data: [
                "nombre" : nombre,
                "edad" : edad
            ]){ error in
                if let error = error{
                    print("Error: \(error.localizedDescription)")
                }else{
                    print("Usuario agregado:")
                }
            }
            //self.tabla.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField: UITextField!) in
            textField.placeholder = "Nombre"
            name = textField
            
        }
        
        alertController.addTextField { (textField: UITextField!) in
            textField.placeholder = "Edad"
            age = textField
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuario.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaUsuario",for: indexPath) as! UsuarioTableViewCell
        celda.nombre.text = usuario[indexPath.row].nombre
        celda.edad.text = "\(usuario[indexPath.row].edad)"
        celda.id.text = usuario[indexPath.row].id
        return celda
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let id = usuario[indexPath.row].id
            db.collection("users").document(id).delete{(error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    print("Usuario borrado")
                }
                
            }
        }
    }
    
}
