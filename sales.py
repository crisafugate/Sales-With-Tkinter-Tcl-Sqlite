import os
import tkinter as tk

# add mydb and sqlite to auto_path
root = tk.Tk()
file_path = os.getcwd()
package_dir = os.path.abspath(os.path.join(file_path, "mydb"))
package_dir_tcl = package_dir.replace("\\", "/")
root.tk.eval(f"lappend auto_path {{{package_dir_tcl}}}")
root.tk.eval("lappend auto_path C:/ActiveTcl/lib/sqlite3.36.0")

# import mydb
root.tk.eval("package require mydb 1.0")

# init sales database (if needed)
root.tk.call("::mydb::init_sales")

# check name entry
def check_name(event):
    text = name_entry.get()
    if not text:
        name_entry.config(bg="white")
        return
    result = all(char.isalpha() or char.isspace() for char in text)
    if result:
        name_entry.config(bg="white")
    else:
        name_entry.config(bg="#FFCCCC")

# check date entry
def check_date(event):
    text = date_entry.get()
    if not text:
        date_entry.config(bg="white")
        return
    if len(text) == 10 and text[:4].isnumeric() and \
        text[5:7].isnumeric() and text[9:].isnumeric() and \
        text[4] == text[7] == "-":
        date_entry.config(bg="white")
    else:
        date_entry.config(bg="#FFCCCC")

# check amount entry
def check_amount(event):
    text = amount_entry.get()
    if not text:
        amount_entry.config(bg="white")
        return
    if all(char.isnumeric() or char == "." for char in text):
        amount_entry.config(bg="white")
    else:
        amount_entry.config(bg="#FFCCCC")

# collect params, call get_sales, insert results into results_buf
def exec_query():
    person = name_entry.get()
    if check_var.get() != True:
        person = ""
    mydate = date_entry.get()
    daterel = date_var.get()
    if mydate == "":
        daterel = ""
    amount = amount_entry.get()
    amtrel = amt_var.get()
    if amount == "":
        amtrel = ""
    amount_num = float(amount) if amount else 0.0
    results = root.tk.call("::mydb::get_sales", person, mydate, daterel, amount_num, amtrel)
    results_buf.delete('1.0', 'end')
    for row in range(results):
        results_buf.insert(tk.END, f"{row}\n")

# close db connection, destroy window, exit
def exit_program():
    root.tk.eval("::mydb::dbcon close")
    root.destroy()
    exit

# top horizontal frame
hframe = tk.Frame(root)
hframe.pack()

# name label and entry
name_label = tk.Label(hframe, text="Name:").pack(side=tk.LEFT)
name_entry = tk.Entry(hframe)
name_entry.pack(side=tk.LEFT)
name_entry.bind("<KeyRelease>", check_name)

# name checkbox
check_var = tk.BooleanVar(value=True)
name_chkbtn = tk.Checkbutton(hframe, variable=check_var)
name_chkbtn.pack(side=tk.LEFT)

# date label and entry
date_label = tk.Label(hframe, text="Date:").pack(side=tk.LEFT)
date_entry = tk.Entry(hframe)
date_entry.pack(side=tk.LEFT)
date_entry.bind("<KeyRelease>", check_date)

# date relation
date_var = tk.StringVar(value='eq')
tk.Radiobutton(hframe, text='lt', variable=date_var, value='lt').pack(side=tk.LEFT)
tk.Radiobutton(hframe, text='eq', variable=date_var, value='eq').pack(side=tk.LEFT)
tk.Radiobutton(hframe, text='gt', variable=date_var, value='gt').pack(side=tk.LEFT)

# amount label and entry
amount_label = tk.Label(hframe, text="Amount:").pack(side=tk.LEFT)
amount_entry = tk.Entry(hframe)
amount_entry.pack(side=tk.LEFT)
amount_entry.bind("<KeyRelease>", check_amount)

# amount relation
amt_var = tk.StringVar(value='eq')
tk.Radiobutton(hframe, text='lt', variable=amt_var, value='lt').pack(side=tk.LEFT)
tk.Radiobutton(hframe, text='eq', variable=amt_var, value='eq').pack(side=tk.LEFT)
tk.Radiobutton(hframe, text='gt', variable=amt_var, value='gt').pack(side=tk.LEFT)

# query execute button
exec_btn = tk.Button(hframe, text="Execute", command=exec_query)
exec_btn.pack(side=tk.LEFT)

# results buffer
results_buf =tk.Text(root)
results_buf.pack(fill=tk.BOTH, expand=True)

# exit button
exit_btn = tk.Button(root, text="Exit", command=exit_program)
exit_btn.pack()

root.mainloop()
