require 'csv'
require './attendee'
require 'pry'

class EventReporter
  attr_accessor :queue, :attendees

  def initialize
    @queue = []
    @attendees = []
  end

  def run
    puts "Hey bro!  Welcome to EventReporter!!"

    command = ""
    while command != "quit"
      printf "Kindly enter your command:"
      user_input = gets.chomp
      command = user_input.split(" ")[0]
      response = process_input(user_input)
      puts response unless response.class == Array
    end
  end

  def process_input(user_input)
    @user_input = user_input.downcase
    command = @user_input.split(" ")[0]
    directive = @user_input.split(" ")[1..-1]
    help_input = @user_input.split(" ")[1]
    case command
      when "quit" then "You are the weakest link. Goodbye!"
      when "help" then help_output(help_input)
      when "load" then load_csv_data
      when "queue" then queue_parser(directive)
      when "find" then find_parser(directive)
      when "brownchickenbrowncow"
        puts "Get on it! Get on it!"
      else "Sorry, bro. Available commands are: load, queue_clear, queue_count, queue_save_to, find..., help, and quit."
    end
  end

  def help_output(help_input)
    case help_input
    when "load" then puts "Erases loaded data and parses the specified file; If no filename is given default to /'event_attendees.csv'."
    when "queue_count"
       puts "Gives a number of how many records are in the current queue." 
    when "queue_clear" 
       puts "Empties the queue." 
    when "queue_print"
       puts "Prints out a tab-delimited data table (we never said it would be pretty...)" 
    when "queue_print_by"
       puts "Prints a data table that is sorted by the specified <attribute> like zipcode."
    when "queue_save_to"
       puts "Exports the current queue to the specified filename as a CSV." 
    when "find"
       puts "Find will match <attribute> and <criteria>."
    else 
       puts "Help: Provides a listing of the available individual commands (queue_count, queue_clear, queue_print, queue_print_by, queue_save_to and find)."
    end
  end

  def find_parser(directive)
    # add code to trap if "load" has not yet been run
    attribute = directive[0]
    criteria = directive[1..-1].join(" ")
    find_and_add_to_queue(attribute,criteria)
  end

  def find_and_add_to_queue(attribute,criteria)
    results = find_it(attribute,criteria)
    send_results_to_queue(results)
  end

  def find_it(attribute,criteria)
    puts "SeArChIng...FiNdInG...FoUnD"   
    criteria = criteria.chomp(" ")
    @attendees.find_all {|attendee| attendee.send(attribute) == criteria}
  end

  def send_results_to_queue(results)
    clear_queue
    @queue = results.collect {|result| result}
    return @queue
  end

  def queue_parser(directive)
    # commands: count, clear, print, print by, print to
    queue_command = directive[0]
    case queue_command
      when "clear" then clear_queue
      when "count" then count_queue
      when "print" then queue_print_parser(directive)
      when "save"  then queue_save(directive)
    end
  end

  def queue_print_parser(directive)
    queue_print_by = directive[1]
    attribute = directive[2..-1]
    case queue_print_by
      when nil then print_queue
      else sort_and_print_queue(attribute)
    end
  end

  def queue_save(directive)
    save_filename = directive[1..-1].join("")
    save_file = File.open(save_filename, "w")
    attendee_array = @queue.collect do |attendee|
       [attendee.email, attendee.first_name, attendee.last_name, attendee.phone_number, attendee.zip_code, attendee.city, attendee.state, attendee.address]
    puts "Get it...........Got It.......Goooood"
    end

    attendee_array.each_with_index do |a_csv, i|
      queue_csv = CSV.generate do |csv|
        csv << a_csv
      end
      if i == 0
        save_file.write('email,first_name,last_name,phone_number,zip_code,city,state,address\t')
      end
      save_file.write(queue_csv)
    end
    save_file.close
    return save_file
  end

  def sort_and_print_queue(attribute)
    attribute = attribute.join
    sort_queue(attribute)
    print_queue
  end

  def sort_queue(attribute)
    @queue = @queue.sort_by {|attendee| attendee.send(attribute)}
  end

  def print_queue
    puts "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\tPHONE"
    @queue.each do |attendee|
      puts "#{attendee.last_name}\t\t#{attendee.first_name}\t\t#{attendee.email}\t\t#{attendee.zip_code}\t\t#{attendee.city}\t\t#{attendee.state}\t\t#{attendee.address}\t\t#{attendee.phone_number}"
    end
  end

  def clear_queue
    @queue = []
  end  

  def count_queue
    puts "Flip it... smack it... rub it down"
    @queue.count
  end

  def load_csv_data(filename = "event_attendees.csv")
    data = import_csv(filename)
    create_attendees(data)
  end

  def import_csv(filename)
    CSV.open filename, headers: true, header_converters: :symbol
  end

  def create_attendees(data)
    @attendees = data.collect do |row|
      Attendee.new(:id => row[0], :first_name => row[:first_name], :last_name => row[:last_name], :zip_code => row[:zipcode], :email => row[:email_address], :phone_number => row[:homephone], :address => row[:street], :city => row[:city], :state => row[:state])
    end
    # return attendees
  end
end

if __FILE__ == $0
  er = EventReporter.new
  er.run
end
