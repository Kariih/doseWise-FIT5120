import Foundation
import SQLite3

class ScheduleCRUD{
    var db:OpaquePointer?
//    let tableName="schedule"
    var scheduleList=[Schedule]()
    
    init(){}
    
    func initTables(){
        createdrugScheduleTable()
    }
    
    private func openDbConnection(){
        let fileUrl=try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("schedule.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
    }

    private func createdrugScheduleTable(){
        
        openDbConnection()
        
        let createTableQuery="CREATE TABLE IF NOT EXISTS schedule (id INTEGER PRIMARY KEY AUTOINCREMENT, time Text, dosage Text, medicine Text)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("DB created")
        sqlite3_close(db)
    }
    
    func addSchedule(schedule: Schedule){
        
        let time = schedule.timing.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let dosage = schedule.dosage.joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let medicine = schedule.medicineName.joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        
        openDbConnection()
        var stmt:OpaquePointer?
        
        let insertQuery="INSERT INTO schedule(time,dosage,medicine) VALUES(?,?,?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("error binding query")
        }
        
        if sqlite3_bind_text(stmt, 1, time.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding time: \(errmsg)")
        }
        
        if sqlite3_bind_text(stmt, 2, dosage.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding dosage: \(errmsg)")
        }
        
        if sqlite3_bind_text(stmt, 3, medicine.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding medicine: \(errmsg)")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Nominee saved successfully")
        }
    }

    func getSchedules() -> [Schedule]{
        let queryStatementString = "SELECT * FROM schedule;"
        scheduleList.removeAll()
        openDbConnection()
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let time = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let dosage = String(cString: queryResultCol2!).components(separatedBy: ":")
                
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let medicine = String(cString: queryResultCol3!).components(separatedBy: ":")
                
                scheduleList.append(Schedule(id: Int(id), timing:time, dosage: dosage, medicineName: medicine))
            }
        } else {
            print("Could not featch objects from db")
        }
        sqlite3_finalize(queryStatement)
        return scheduleList
    }
    
    func updateSchedule(sche: Schedule) {
        openDbConnection()
        let scheId = String(sche.id!)

        var time = sche.timing.trimmingCharacters(in: .whitespacesAndNewlines)
        time = "'"+time+"'"
        
        var dosage = sche.dosage.joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
        dosage = "'"+dosage+"'"
        
        var medicine = sche.medicineName.joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
        medicine = "'"+medicine+"'"
        
        let updateStmtForTime="UPDATE schedule SET time = \(time) WHERE id = \(scheId);"
        let updateStmtForDosage="UPDATE schedule SET dosage = \(dosage) WHERE id = \(scheId);"
        let updateStmtForMedicine="UPDATE schedule SET medicine = \(medicine) WHERE id = \(scheId);"
        
        print("update time stmt\(updateStmtForTime)")
        print("update Dosage stmt\(updateStmtForDosage)")
        print("update Medicine stmt\(updateStmtForMedicine)")
        
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStmtForTime, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated time.")
            } else {
                print("Could not update time.")
            }
        } else {
            print("UPDATE time statement could not be prepared")
        }
        
        if sqlite3_prepare_v2(db, updateStmtForDosage, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated dosage.")
            } else {
                print("Could not update dosage.")
            }
        } else {
            print("UPDATE dosage statement could not be prepared")
        }
        
        if sqlite3_prepare_v2(db, updateStmtForMedicine, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated medicine.")
            } else {
                print("Could not update medicine.")
            }
        } else {
            print("UPDATE medicine statement could not be prepared")
        }
        
        sqlite3_finalize(updateStatement)
    }

    func deleteDrugSchedule(sche: Schedule) {
        let scheId = sche.id
        print("DELETE ID \(scheId!)")
        openDbConnection()
        let deleteStatementStirng="DELETE FROM schedule WHERE id = \(scheId!);"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted Schedule.")
            } else {
                print("Could not delete Schedule.")
            }
        } else {
            print("DELETE Schedule statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
