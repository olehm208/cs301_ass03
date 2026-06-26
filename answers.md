# What is the difference between a function and a procedure in PostgreSQL?
The difference between the two is gigantic, even if it looks like one and another do the same thing. Function computes and returns some data or values, when procedures execute actions.
Functions are called from SELECT, procedures are called, however, from CALL.
# Can a trigger be executed manually? Why or why not?
Triggers by design are made so they are tied to an action, not a call. By design,
Trigger is a listener, waiting for DMLs and then act.
# What are the advantages and disadvantages of storing business logic inside the database?
While using a database, the massive network calculations are simplified in the database and returned as 
a simple value, and batching is much faster. Also security is much better, because you can assign roles, permissions
and users. However, upgrading a database is much more expensive, you're locked to one DB provider (Maria, Postgre)
and migrating to other will be a pain.