import SQLite3
import UIKit

//class for nominee, same attributes with the table,
// (Not absolute correct, please use it as general guidance) this class should not be passed to DB, for SQLite will manage Id by auto-increment, there will be conflict when u try to assign Id value to an object & pass it to DB.

class CRUD {
    
    let queryStatementString = "SELECT * FROM nominee;"
    var db:OpaquePointer?
    var nomls=[Nominee]()
    
    init(){}
    
    func initTables(){
        createNomineeTable()
    }
    
    //this is where table created
    private func createNomineeTable(){
        
        let fileUrl=try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("nominee.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
        
        let createTableQuery="CREATE TABLE IF NOT EXISTS nominee(id INTEGER PRIMARY KEY AUTOINCREMENT, name Text, phoneNo Text)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("DB created")
    }
        
    func addNominee(nom:Nominee) {
        
        let name=nom.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNo=String(nom.phoneNo).trimmingCharacters(in: .whitespacesAndNewlines)
        
        var stmt:OpaquePointer?
        
        let insertQuery="INSERT INTO nominee(name,phoneNo) VALUES(?,?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("error binding query")
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            print("error binding name")
        }
        
        if sqlite3_bind_int(stmt, 2, (phoneNo as NSString).intValue) != SQLITE_OK{
            print("error binding phoneNo")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Nominee saved successfully")
        }
    }
    
    //select all entries from the table
    
    
    
    //display all entries on terminal
    
    //    @IBAction func listNominees(_ sender: Any) {
    //
    //        var queryStatement: OpaquePointer? = nil
    //        // 1
    //        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
    //            // 2
    //            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
    //                // 3
    //                let id = sqlite3_column_int(queryStatement, 0)
    //                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
    //                let name = String(cString: queryResultCol1!)
    //                let phoneNo = sqlite3_column_int(queryStatement, 2)
    //
    //                print("\(id) | \(name) | \(phoneNo)")
    //
    //            }
    //        } else {
    //            print("SELECT statement could not be prepared")
    //        }
    //
    //        // 6
    //        sqlite3_finalize(queryStatement)
    //
    //    }
    //
    
    
    
    //read all entry from the table, return type is a list of nominee objects
    
    func readNominees() -> [Nominee]{
        
        nomls.removeAll()
        
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                let tellNo = sqlite3_column_text(queryStatement, 2)
                
               // nomls.append(Nominee(id: Int(id), name: String(describing: name), phoneNo: tellNo))
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return nomls
        //        self.tableViewNominees.reloadData()
    }
    
    //update
    
    //    @IBAction func upd1(_ sender: Any) {
    //        let nomId = String(1)
    //        let nomName="'"+"xigouzei"+"'"
    //        //        let nomName1="'"+nomName!+"'"
    //        let nomPhone="'"+String(2837510)+"'"
    //
    //        let ussName="UPDATE nominee SET name ="+nomName
    //
    //        let ussPhoneNo="UPDATE nominee SET phoneNo ="+nomPhone
    //
    //        let whereId=" WHERE Id = "+nomId+";"
    //
    //        let updateStatementString = ussName+whereId
    //        let updateStatementString1 = ussPhoneNo+whereId
    //
    //        var updateStatement: OpaquePointer? = nil
    //        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
    //            if sqlite3_step(updateStatement) == SQLITE_DONE {
    //                print("Successfully updated name.")
    //            } else {
    //                print("Could not update name.")
    //            }
    //        } else {
    //            print("UPDATE name statement could not be prepared")
    //        }
    //
    //        if sqlite3_prepare_v2(db, updateStatementString1, -1, &updateStatement, nil) == SQLITE_OK {
    //            if sqlite3_step(updateStatement) == SQLITE_DONE {
    //                print("Successfully updated phoneNo.")
    //            } else {
    //                print("Could not update phoneNo.")
    //            }
    //        } else {
    //            print("UPDATE phoneNo statement could not be prepared")
    //        }
    //
    //        sqlite3_finalize(updateStatement)
    //    }
    //
    
 /*   func updateNominee(nom: Nominee) {
        
        let nomId = String(nom.id)
        let nomName="'"+nom.name+"'"
        let nomPhone="'"+nom.phoneNo+"'"
        let ussName="UPDATE nominee SET name ="+nomName
        let ussPhoneNo="UPDATE nominee SET phoneNo ="+nomPhone
        let whereId=" WHERE Id = "+nomId+";"
        let updateStatementString = ussName+whereId
        let updateStatementString1 = ussPhoneNo+whereId
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated name.")
            } else {
                print("Could not update name.")
            }
        } else {
            print("UPDATE name statement could not be prepared")
        }
        
        if sqlite3_prepare_v2(db, updateStatementString1, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated phoneNo.")
            } else {
                print("Could not update phoneNo.")
            }
        } else {
            print("UPDATE phoneNo statement could not be prepared")
        }
        
        sqlite3_finalize(updateStatement)
    }
    */
    
    //delete entry
    
    /*func deleteNominee(nom: Nominee) {
        
        let nomId = nom.id
        
        let delStmt="DELETE FROM nominee WHERE Id = "
        let nomNo=String(nomId)+";"
        let deleteStatementStirng=delStmt+nomNo
        
        print(deleteStatementStirng)
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
        
    }*/
    
    //this is for testing delete func
    
    //    @IBAction func del3(_ sender: Any) {
    //
    //        let nomId = 5
    //
    //        let delStmt="DELETE FROM nominee WHERE Id = "
    //        let nomNo=String(nomId)+";"
    //        let deleteStatementStirng=delStmt+nomNo
    //
    //        print(deleteStatementStirng)
    //
    //        var deleteStatement: OpaquePointer? = nil
    //        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
    //            if sqlite3_step(deleteStatement) == SQLITE_DONE {
    //                print("Successfully deleted row.")
    //            } else {
    //                print("Could not delete row.")
    //            }
    //        } else {
    //            print("DELETE statement could not be prepared")
    //        }
    //
    //        sqlite3_finalize(deleteStatement)
    //    }
    
    //next 2 functions are for showing all entries of the table to the sceern
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        //this method is giving the row count of table view which is
    //        //total number of noms in the list
    //        return nomls.count
    //    }
    //
    //
    //
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
    //        let nom: nominee
    //        nom = nomls[indexPath.row]
    //        let nomName=nom.name
    //        let nomNo=String(nom.phoneNo)
    //
    //        let nomDetail=nomName!+", "+nomNo
    //
    //        cell.textLabel?.text = nomDetail
    //        //        cell.textLabel?.text = String(nom.name + nom.phoneNo)
    //        return cell
    //    }
    //
    
    //end of experimenting features
    
}

