//
//  Review.swift
//  Snacktacular
//
//  Created by Yinzhe Ma on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: Date
    var documentID: String
    
    var dictionary:[String:Any]{
        return ["title":title, "text":text, "rating": rating, "reviewerUserID":reviewerUserID, "date":date, "documentID": documentID]
    }
    
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String){
        self.title=title
        self.text=text
        self.rating=rating
        self.reviewerUserID=reviewerUserID
        self.date=date
        self.documentID=documentID
    }
    
    convenience init(){
        let currentUserID=Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: Date(), documentID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping(Bool)->()){
        let db=Firestore.firestore()
        //create the dictionary representing the data we want to save
        let dataToSave=self.dictionary
        //if we have a saved record, we will have a documentID
        if self.documentID != ""{
            let ref=db.collection("spots").document(spot.documentID).collection("reviews").document("self.documentID")
            ref.setData(dataToSave){ (error) in
                if let error=error{
                    print("***ERROR: Updated document \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                } else{
                    print("Document updated with ref ID\(ref.documentID)")
                    completed(true)
                }
            }
        } else{
            var ref: DocumentReference? = nil //let firestore create the new documentID
            ref=db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) {error in
                if let error=error{
                    print("***ERROR: Creating new document in spot \(spot.documentID) for new review documentID \(error.localizedDescription)")
                    completed(false)
                } else{
                    print("^^^ new document created with ref ID\(ref?.documentID ?? "unknown")")
                    completed(true)
                }
            }
        }
    }
}
