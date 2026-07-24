# Sales-With-Tkinter-Tcl-Sqlite
Exploring connection between Tkinter, Tcl, and Sqlite

Although I have had a long career with both Python and Tcl, there are four things I have never done.
1. Use a database with Tcl. For this I used Sqlite which was originally a Tcl extension. As a result,
   it works somewhat different than it does with Python.
2. Create a Tcl package. This is the purpose of mydb. It imports Sqlite, although the path to the Sqlite
   needs to be added to the auto_path in Tkinter.
3. Write some unit tests for Tcl. I used Tcltest to test get_sales.
4. Do something with the Tcl interpreter in Tkinter. So, I wrote a GUI interface to integrate with
   the mydb package.

The practicality of this is demonstrated by Tkinter itself. It integrates Tcl with Python, adding
the potential power of Python libraries. By working with the Tcl interpreter you can leverage
Tcl's lower level system scripting capabilities.
