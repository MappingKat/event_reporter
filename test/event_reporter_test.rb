require 'minitest'
require 'minitest/autorun'
require './lib/event_reporter'

class EventReporterTest < MiniTest::Test

  def test_it_exists
    er = EventReporter.new
    assert_kind_of EventReporter, er
  end

  def test_it_says_goodbye_when_command_is_quit
    er = EventReporter.new
    response = er.process_input("quit yeah")
    assert_equal "Goodbye!", response
  end

  def test_it_provides_a_list_of_commands_when_command_is_help
    er = EventReporter.new
    instructions = er.help_output("help queue_save_to")
    assert_equal "Exports the current queue to the specified filename as a CSV.", instructions
  end

  def test_it_loads_a_file_when_command_is_load
    skip
    er = EventReporter.new
    er.process_input("load")
    assert_send([er, :load_csv_data])
  end

  def test_it_loads_data_properly_from_file
    skip
    er = EventReporter.new
    parsed_data = er.process_input("load")
    assert_kind_of Array, parsed_data
    assert_equal 5175, parsed_data.count
    assert_equal "allison", parsed_data[0].first_name
    assert_equal "nguyen", parsed_data[0].last_name
    assert_equal "arannon@jumpstartlab.com", parsed_data[0].email
    assert_equal "6154385000", parsed_data[0].phone_number
    assert_equal "3155 19th st nw", parsed_data[0].address
    assert_equal "washington", parsed_data[0].city
    assert_equal "dc", parsed_data[0].state
    assert_equal "20010", parsed_data[0].zip_code
  end

  def test_queue_is_empty_upon_startup
    skip
    er = EventReporter.new
    assert_nil @queue
  end

  def test_attendees_is_empty_upon_startup
    skip
    er = EventReporter.new
    assert_nil @attendees
  end

  def test_it_calls_find_method_when_command_is_find
    skip
    er = EventReporter.new
    input = "find last_name SAUNDERS"
    er.process_input(input)
    assert_send([er, :find_parser, ["last_name", "SAUNDERS"]])
  end

  def test_it_gets_data_from_attendees_given_zip_code
    skip
    er = EventReporter.new
    er.process_input("load")
    results = er.find_it("zip_code","20010")
    assert_equal 5, results.count
  end

  def test_it_gets_data_from_attendees_given_first_name
    skip
    er = EventReporter.new
    er.process_input("load")
    results = er.find_it("first_name","sarah")
    assert_equal 78, results.count
  end

  def test_queue_has_correct_count_after_find 
    skip
    er = EventReporter.new
    er.process_input("load")
    results = er.find_it("first_name","sarah")
    queue = er.send_results_to_queue(results)
    assert_equal(78, queue.count)
  end


  # below test should error because queue is being pushed to without being cleaned
  # to test, comment out empty_queue in send_results_to_queue
  def test_queue_has_correct_count_after_two_finds
    skip
    er = EventReporter.new
    er.process_input("load")
    results = er.find_it("first_name","Sarah")
    @queue = er.send_results_to_queue(results)
    results = er.find_it("zip_code","20010")
    @queue = er.send_results_to_queue(results)
    assert_equal(2, @queue.count)
    # maybe er.queue ???
  end

  def test_it_runs_queue_parser_when_queue_is_called
    skip
    er = EventReporter.new
    parsed_data = er.process_input("queue count")
    assert_send([er, :queue_parser, ["count"]])
  end

  def test_it_clears_queue_when_clear_queue_is_passed_to_queue_parser
    skip
    er = EventReporter.new
    results = er.queue_parser(["clear"])
    assert_equal true, results.empty?
  end

  def test_it_returns_count_when_count_is_passed_to_queue_parser
    skip
    er = EventReporter.new
    er.queue_parser("load")
    er.find_it("zip_code","20010")
    results = er.queue_parser(["clear"])
    assert_equal true, results.empty?
  end

  def test_it_runs_queue_print_parser_when_queue_print_is_called
    skip
    er = EventReporter.new
    parsed_data = er.process_input("queue print")
    assert_send([er, :queue_print_parser, ["print"]])
  end

  def test_it_runs_sort_queue_when_queue_print_by_is_called
    skip
    er = EventReporter.new
    parsed_data = er.process_input("queue print by first_name")
    sort_command = er.queue_print_parser(["print", "by", "first_name"])
    sort_queue_result = er.sort_queue("first_name")
    assert_equal sort_command, sort_queue_result
  end

  def test_it_should_print_by_first_name_when_by_attribute_is_zip_code
    skip
    sarah = EventReporter.new
    sarah.process_input("load")
    sarah.process_input("find first_name Sarah")
    sorted_list = sarah.process_input("queue print by zip_code")
    assert_equal "00000", sorted_list[0].zip_code
  end

  def test_it_creates_a_file_type_when_command_to_queue_print_parser_is_save
    er = EventReporter.new
    save = er.queue_parser(["save","filename.csv"])
    # assert_send([er, :queue_save, ["save","filename.csv"]])
    assert_kind_of File, save
  end

  def test_it_creates_a_file_when_command_to_queue_print_parser_is_save
    er = EventReporter.new
    er.process_input("load")
    er.process_input("find first_name Sarah")
    save = er.queue_parser(["save","to","filename.csv"])
    exists = false
    if FileTest.exists?("filename.csv")
      exists = true
    end
    assert exists
  end
end
