import Foundation
import SQLite3

class ScheduleCRUD{
    var db:OpaquePointer?
    let tableName="schedule"
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
        let createTableQuery="CREATE TABLE IF NOT EXISTS schedule (id INTEGER PRIMARY KEY, time Text, dosage Text, name Text)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("DB created")
        sqlite3_close(db)
    }
    
    func addSchedule(schedule: Schedule, id: Int){
        openDbConnection()
        let dosage = schedule.dosage.joined(separator: ":")
        let medicine = schedule.medicineName.joined(separator: ":")
        let time = schedule.timing
        
        let values = "VALUES(\(id),\'\(time)\',\'\(dosage)\',\'\(medicine)\');"
        print(values)
        let insertStatement = "INSERT INTO schedule (id, time, dosage, name)" + values
        if sqlite3_exec(db, insertStatement , nil, nil, nil) != SQLITE_OK{
            print("Error Inserting into \(tableName)")
            return
        }
        print("Insert Successfull")
        sqlite3_close(db)
    }
    
    func getSchedules() -> [Schedule] {
        openDbConnection()
        var rows: [Schedule] = []
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, "SELECT * FROM schedule;", -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let time = String(cString:sqlite3_column_text(queryStatement, 1))
                let dosage = String(cString:sqlite3_column_text(queryStatement, 2)).components(separatedBy: ":")
                let names = String(cString:sqlite3_column_text(queryStatement, 3)).components(separatedBy: ":")
                
                rows.append(Schedule(timing: time, dosage: dosage, medicineName: names))
            }
        }
        sqlite3_close(db)
        return rows
    }
    func getRows() -> Int {
        openDbConnection()
        var queryStatement: OpaquePointer? = nil
        var entries = 0
        if sqlite3_prepare_v2(db, "SELECT COUNT(*) from schedule", -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                entries = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        sqlite3_close(db)
        return entries
    }
    func deleteDrugSchedule(id: Int) {
        openDbConnection()
        if sqlite3_exec(db,"DELETE FROM schedule WHERE id=\(id)" , nil, nil, nil) != SQLITE_OK{
            print("Error deleting from \(tableName)")
            return
        }
        print("delete Successful")
        sqlite3_close(db)
    }
}