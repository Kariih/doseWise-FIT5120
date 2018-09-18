import SQLite3
import UIKit

class CRUDDrugSchedule {
    var db:OpaquePointer?
    let tableName="drugSchedule"
    init(){}
    
    func initTables(){
        createdrugScheduleTable()
        
    }
    
    private func openDbConnection(){
        let fileUrl=try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("drugSchedule.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
    }
    
    //drugSchedule table creation
    private func createdrugScheduleTable(){
        
        openDbConnection()
        
        let createTableQuery="CREATE TABLE IF NOT EXISTS drugSchedule(id INTEGER PRIMARY KEY AUTOINCREMENT, name Text, no_of_days Integer, no_of_times_per_day Integer, no_of_pills_per_dose Integer, timings Text, type_of_pill String )"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("DB created")
        sqlite3_close(db)
    }
    
    
    let intCounter = intakeCounter()
    
    
    func addDrugSchedule(DrugSchedule:DrugSchedule) {
        
        openDbConnection()
        let insertQuery=DrugSchedule.getInsertQuery(TableName: tableName)
        if sqlite3_exec(db,insertQuery , nil, nil, nil) != SQLITE_OK{
            print("Error Inserting into \(tableName)")
            return
        }
        print("Insert Successfull")
        sqlite3_close(db)
        
        
        intCounter.resetRegister(noOfIntake: DrugSchedule.no_of_times_per_day)
        
        
    }
    
    func getDrugSchdules()->[DrugSchedule]{
        var DrugSchList=[DrugSchedule]()
        let queryStatementString = DrugSchedule().getSelectQuery(TableName:tableName)
        DrugSchList.removeAll()
        openDbConnection()
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let strTimings = String(cString: sqlite3_column_text(queryStatement, 5))
                let Timings:[String] =  strTimings.components(separatedBy: ";")
                
                DrugSchList.append(DrugSchedule(id:Int(sqlite3_column_int(queryStatement, 0)), name: String(cString:sqlite3_column_text(queryStatement, 1)), no_of_days: Int(sqlite3_column_int(queryStatement, 2)), no_of_times_per_day: Int(sqlite3_column_int(queryStatement, 3)), no_of_pills_per_dose: Int(sqlite3_column_int(queryStatement, 4)), timings: Timings, type_of_pill: String(cString:sqlite3_column_text(queryStatement, 6))))
                
            }
        } else {
            print("Could not fetch objects from db")
        }
        sqlite3_finalize(queryStatement)
        return DrugSchList
        
    }
    
    func updateDrugSchedule(DrugSchedule:DrugSchedule) {
        openDbConnection()
        let updateQuery=DrugSchedule.getUpdateQuery()
        if sqlite3_exec(db,updateQuery , nil, nil, nil) != SQLITE_OK{
            print("Error updating into \(tableName)")
            return
        }
        print("update Successful")
        sqlite3_close(db)
        
        
        intCounter.resetRegister(noOfIntake: DrugSchedule.no_of_times_per_day)
        
    }
    
    func deleteDrugSchedule(DrugSchedule:DrugSchedule) {
        openDbConnection()
        let deleteQuery=DrugSchedule.getDeleteQuery()
        if sqlite3_exec(db,deleteQuery , nil, nil, nil) != SQLITE_OK{
            print("Error deleting from \(tableName)")
            return
        }
        print("delete Successful")
        sqlite3_close(db)
    }
    
    func deleteAllDrugSchedule() {
        openDbConnection()
        let deleteAllQuery=DrugSchedule().getDeleteAllQuery()
        if sqlite3_exec(db,deleteAllQuery , nil, nil, nil) != SQLITE_OK{
            print("Error deleting ALL from \(tableName)")
            return
        }
        print("Delete All Successfull")
        sqlite3_close(db)
    }
}
