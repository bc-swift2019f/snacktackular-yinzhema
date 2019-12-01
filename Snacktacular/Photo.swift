//
//  Photo.swift
//  Snacktacular
//
//  Created by Yinzhe Ma on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String
    var dictionary: [String:Any]{
        return ["":description, "postedBy": postedBy, "date":timeIntervalDate]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String){
        self.image=image
        self.description=description
        self.postedBy=postedBy
        self.date=date
        self.documentUUID=documentUUID
    }
    
    convenience init(){
        let postedBy=(Auth.auto() as AnyObject).currentUser.email ?? "Unknown User"
        self.init(image: UIImage(), description: "", postedBy: "", date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary:[String:Any]){
        let title=dictionary["description"] as! String? ?? ""
        let postedBy=dictionary["postedBy"] as! String? ?? ""
        let date=Date(timeIntervalSince1970: timeIntervalDate)
        self.init(image: UIImage(),description: description, postedBy: postedBy, date:date, documentUUID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping(Bool)->()){
        let db=Firestore.firestore()
        let storage=Storage.storage()
        //convert photo.image to a data type so it can be saved by firebase storage
        guard let photoData=self.image.jpegData(compressionQuality: 0.5) else{
            print("***ERROR: Could not convert image to data format")
            return completed(false)
        }
        documentUUID=UUID().uuidString //generate a unique id to use for the photo image's name
        //create a ref to upload storage to spot.documentID's folder, with the name we created
        let storageRef=storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadtTask=storageRef.putData(photoData)
        uploadTask.observe(.success){(snapshot) in
            //create the dictionary representing the data we want to save
            let dataToSave=self.dictionary
            //if we have a saved record, we will have a documentID
            let ref=db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave){ (error) in
                if let error=error{
                    print("***ERROR: Updated document \(self.documentUUID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                } else{
                    print("Document updated with ref ID\(ref.documentID)")
                    completed(true)
                }
            }
        }
        uploadTask.observe(.failure){(snapshot) in
            if let error=snapshot.error{
                print("***Error: upload task for file \(self.documentUUID) failed, in spot \(spot.documentID)")
            }
            return completed(false)
        }
    }
    
}
