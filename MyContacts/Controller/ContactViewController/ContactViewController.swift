//
//  ContactViewController.swift
//  MyContacts
//
//  Created by Mangi on 8/15/19.
//  Copyright © 2019 BajajAllianz. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var contacts : [Person] = []
    var filteredTableData = [String]()
    var NameArr = [String]()
    var ContactNameStr:String?
    var searchActive : Bool = false
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.navigationItem.title = "Contacts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
        //reload
        tableView.reloadData()
    }
    
    @objc func addContact() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddContactController") as? AddContactController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredTableData.count
        }
        else{
            return contacts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableViewCell
        NameArr.removeAll()
        if(searchActive) {
            cell.contactLbl.text = filteredTableData[indexPath.row]
            if let image = contacts[indexPath.row].profileImage{
                cell.Img.image = UIImage(data: image as Data)
                cell.Img.clipsToBounds = true;
                cell.Img.layer.cornerRadius = cell.Img.frame.width/2;
            }
            print("here ",NameArr)
        }
        else{
            let contact = contacts[indexPath.row]
            cell.contactLbl.text = contact.name!
            if let image = contacts[indexPath.row].profileImage{
                cell.Img.image = UIImage(data: image as Data)
                cell.Img.clipsToBounds = true;
                cell.Img.layer.cornerRadius = cell.Img.frame.width/2;
            }
            for i in 0..<self.contacts.count{
                let contact1 = contacts[i]
                self.ContactNameStr = contact1.name!
                self.NameArr.append(self.ContactNameStr!)
            }
            print("here ",NameArr)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete
        {
            let contact = contacts[indexPath.row]
            context.delete(contact)
            (UIApplication.shared.delegate as!AppDelegate).saveContext()
            do
            {
                contacts = try context.fetch(Person.fetchRequest())
                print(" records found")
            }
            catch
            {
                print("No records found")
            }
            tableView.reloadData()
        }
    }
    func getData(){
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            contacts = try context.fetch(Person.fetchRequest())
            print(" records found")
        }
        catch{
            print("No records found")
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchText)
        let array = (NameArr as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        if(filteredTableData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
