package require tcltest 2.5
namespace import ::tcltest::*
source mydb.tcl

::mydb::init_sales

test mydb-1 {test get_sales with no conditions} {
	set result [::mydb::get_sales "" "" "" 0 ""]
	list [llength $result] [lmap x $result {lindex $x 0}]
} {8 {John John Garry Garry Martha Martha Gwen Gwen}}

test mydb-2 {test get_sales with a person} {
	set result [::mydb::get_sales "John" "" "" 0 ""]
	list [llength $result] $result
} {2 {{John 2025-06-05 70.0} {John 2026-01-30 50.0}}} 

test mydb-3 {test get_sales less than a date} {
	set result [::mydb::get_sales "" "2025-08-01" "lt" 0 ""]
	list [llength $result] [lmap x $result {lindex $x 1}]
} {3 {2025-06-05 2024-07-03 2025-06-06}}

test mydb-4 {test get_sales equal to a date} {
	set result [::mydb::get_sales "" "2025-08-10" "eq" 0 ""]
	list [llength $result] $result
} {1 {{Gwen 2025-08-10 70.0}}}

test mydb-5 {test get_sales greater than a date} {
	set result [::mydb::get_sales "" "2026-01-01" "gt" 0 ""]
	list [llength $result] $result
} {2 {{John 2026-01-30 50.0} {Martha 2026-06-20 60.0}}}

test mydb-6 {test get_sales less than amount} {
	set result [::mydb::get_sales "" "" "" 60 "lt"]
	list [llength $result] [lmap x $result {lindex $x 2}]
} {3 {50.0 25.0 55.0}}

test mydb-7 {test get_sales equal to amount} {
		set result [::mydb::get_sales "" "" "" 60 "eq"]
	list [llength $result] [lmap x $result {lindex $x 0}]
} {2 {Garry Martha}}

test mydb-8 {test get_sales greater than amount} {
		set result [::mydb::get_sales "" "" "" 60 "gt"]
	list [llength $result] [lmap x $result {lindex $x 2}]
} {3 {70.0 70.0 80.0}}

test mydb-9 {test get_sales person and equal to a date} {
	set result [::mydb::get_sales "John" "2026-01-30" "eq" 0 ""]
	list [llength $result] $result
} {1 {{John 2026-01-30 50.0}}}

test mydb-10 {test get_sales person and equal to an amount} {
	set result [::mydb::get_sales "John" "" "" 70 "eq"]
	list [llength $result] $result
} {1 {{John 2025-06-05 70.0}}}

test mydb-11 {test get_sales person and equal to a date and amount} {
	set result [::mydb::get_sales "John" "2025-06-05" "eq" 70 "eq"]
	list [llength $result] $result
} {1 {{John 2025-06-05 70.0}}}

test mydb-12 {test get_sales bad person} {
	set result [::mydb::get_sales "Chuck" "" "" 0 ""]
	list [llength $result] $result
} {0 {}}

test mydb-13 {test get_sales bad date} {
	set result [::mydb::get_sales "" "2025-12-25" "eq" 0 ""]
	list [llength $result] $result
} {0 {}}

test mydb-14 {test get_sales bad amount} {
	set result [::mydb::get_sales "" "" "" 100 "eq"]
	list [llength $result] $result
} {0 {}}

cleanupTests
