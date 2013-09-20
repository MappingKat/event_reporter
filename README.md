event_reporter
==============

practice, practice, practice


##Business Logic
*Loadinfg files CSV
*building attendees
* filtering (find)


##Understand Input (Communication)
*queue
*queue count

Action, target, message
(find_by), (attribute-- first_name), (value Alice)

##Event Reporter
*run loop, gets, chomp


##Classes:
*Attendee
*Database, db.find by first name (repository of all of them, holds the csv in array)

*command
*event_reporter



- dont make class named queue
- let tests drive code


ignore user interface

go straight to process:

load file, default = csv
 
 def load (file = 'attendee_list.csv')
  file verwrite 
  then load

make attendee class, attributes and criteria (wraps data nicely)
  last_name => 
  attendee.first_name
  object.instance
  responds with criteria
  TEST first_name called allison
  attendee object

search by first_name <attribute> <criteria>
  find
  results number
  filter.   
  TEST

rake automates tests--> 

user communication
  understanding commands --> what does each mean
  command class... command.new 
  help queue count
  
  help
  help with options
  queue count
