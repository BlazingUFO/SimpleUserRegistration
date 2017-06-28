//
//  SecondViewController.swift
//  SimpleUserRegistration
//
//  Created by Peter Zeman on 28.6.17.
//  Copyright © 2017 Procus s.r.o. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var udidLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [UserData] = []

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        udidLabel.adjustsFontSizeToFitWidth = true
        nameLabel.adjustsFontSizeToFitWidth = true
        timeLabel.adjustsFontSizeToFitWidth = true
        birthdayLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
        showUser(index: 0)
    }
    
    func showUser(index: Int){
        if users.count > 0 {
            if let name = users[index].name{
                if let surname = users[index].surname{
                    nameLabel.text =  name + " " + surname
                }
            }
            if let time = users[index].time{
                timeLabel.text = time
            }
            if let imageData = users[index].photo{
                if let image =  UIImage(data: imageData as Data){
                    imageView.image = image
                }else{
                    imageView.image = UIImage(named: "no-image")
                }
            }else{
                imageView.image = UIImage(named: "no-image")
            }
            if let udid = users[index].id{
                udidLabel.text = udid
            }
            if let latitude = users[index].lattitude{
                if let longitude = users[index].longitude{
                    mapKit.removeAnnotations(mapKit.annotations)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                    mapKit.addAnnotation(annotation)
                    let span = MKCoordinateSpanMake(0.005, 0.005)
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), span: span)
                    mapKit.setRegion(region, animated: true)
                }
            }
            if let birthday = users[index].birthday{
                birthdayLabel.text = birthday
            }else{
                birthdayLabel.text = "-"
            }
        }else{
            birthdayLabel.text = ""
            udidLabel.text = ""
            birthdayLabel.text = ""
            nameLabel.text = ""
            timeLabel.text = ""
            mapKit.removeAnnotations(mapKit.annotations)
            imageView.image = UIImage(named: "no-image")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showUser(index: indexPath.row)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        
        if let myName = user.name {
            cell.textLabel?.text = myName
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            context.delete(user)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                users = try context.fetch(UserData.fetchRequest())
                showUser(index: 0)
                tableView.deleteRows(at: [indexPath], with: .automatic)     
            } catch {
                print("Fetching Failed")
            }
        }
    }
    
    func getData() {
        do {
            users = try context.fetch(UserData.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
}

