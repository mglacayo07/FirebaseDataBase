//
//  UsuarioTableViewCell.swift
//  FirebaseDataBase
//
//  Created by Maria Lacayo on 12/03/21.
//

import UIKit

class UsuarioTableViewCell: UITableViewCell {

    @IBOutlet var nombre: UILabel!
    @IBOutlet var edad: UILabel!
    @IBOutlet var id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
