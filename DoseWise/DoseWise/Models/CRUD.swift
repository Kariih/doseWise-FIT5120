import SQLite3
import UIKit

//class for nominee, same attributes with the table,
// (Not absolute correct, please use it as general guidance) this class should not be passed to DB, for SQLite will manage Id by auto-increment, there will be conflict when u try to assign Id value to an object & pass it to DB.

class CRUD {
    var db:OpaquePointer?
    var nomineeList=[Nominee]()
    
    init(){}
    
    func initTables(){
        createNomineeTable()
        
    }
    
    private func openDbConnection(){
        let fileUrl=try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("nominee.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
    }
    
    //this is where table created
    private func createNomineeTable(){
        
        openDbConnection()
        
        let createTableQuery="CREATE TABLE IF NOT EXISTS nominee(id INTEGER PRIMARY KEY AUTOINCREMENT, name Text, phoneNo Text)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("DB created")
        sqlite3_close(db)
    }
        
    func addNominee(nom:Nominee) {
        
        let name=nom.name.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let phoneNo=String(nom.phoneNo).trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        
        print(“NAME: \(name)“)
        
        openDbConnection()
        var stmt:OpaquePointer?
        
        let insertQuery=“INSERT INTO nominee(name,phoneNo) VALUES(?,?)”
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print(“error binding query”)
        }
        
        if sqlite3_bind_text(stmt, 1, name.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(“failure binding name: \(errmsg)“)
        }
        
        if sqlite3_bind_text(stmt, 2, phoneNo.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(“failure binding phone: \(errmsg)“)
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print(“Nominee saved successfully”)
        }
    }
    
    //select all entries from the table
    
    //read all entry from the table, return type is a list of nominee objects
    
    func readNominees() -> [Nominee]{
        let queryStatementString = "SELECT * FROM nominee;"
        nomineeList.removeAll()
        openDbConnection()
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let tellNo = String(cString: queryResultCol2!)
                
                nomineeList.append(Nominee(id: Int(id), name: name, phoneNo: tellNo))
                
            }
        } else {
            print("Could not featch objects from db")
        }
        sqlite3_finalize(queryStatement)
        return nomineeList
    }
    
    func updateNominee(nom: Nominee) {
        
        openDbConnection()
        
        let nomId = String(nom.id!)
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
    
    //delete entry
    
    func deleteNominee(nom: Nominee) {
        
        let nomId = nom.id
        
        print("DELETE ID \(nomId!)")
        
        openDbConnection()
        
        let delStmt="DELETE FROM nominee WHERE Id = "
        let nomNo="\(nomId!);"
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
        
    }
}

