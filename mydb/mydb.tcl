package provide mydb 1.0
package require sqlite3

# export procs and initialize dbcon
namespace eval ::mydb {
    namespace export init_sales get_sales
    sqlite3 ::mydb::dbcon "my_database.db"
    namespace path [namespace current]
}

# create sales table (if needed) and load data
proc ::mydb::init_sales {} {
    set exists [dbcon onecolumn {
        SELECT EXISTS(
            SELECT 1 FROM sqlite_master
            WHERE type='table' AND name='sales'
        )
    }]
	puts "exists $exists"
    if {!$exists} {
        dbcon eval {CREATE TABLE sales (
            id INTEGER PRIMARY KEY,
            name TEXT,
            date TEXT,
            sales REAL
        )}
        dbcon copy ignore sales C:/Users/cfuga/mydb/data.csv ","
    }
}

# execute query and collect result
proc ::mydb::get_sales {person mydate daterel amount amountrel} {
	set result []
    dbcon eval {SELECT * FROM sales
		        WHERE (:person='' OR :person=name) AND
                (:daterel='' OR (:daterel='lt' AND date < :mydate) OR
                 (:daterel='eq' AND date=:mydate) OR
                 (:daterel='gt' AND date > :mydate)) AND
                (:amountrel='' OR (:amountrel='lt' AND sales < :amount) OR
                 (:amountrel='eq' AND sales=:amount) OR
                 (:amountrel='gt' AND sales>:amount))} row {
					 lappend result [list $row(name) $row(date) $row(sales)]
				 }
    return $result
}
