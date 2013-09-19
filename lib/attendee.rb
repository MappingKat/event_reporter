require './phone_number'
require './zip_code'

class Attendee
  attr_accessor :first_name, :last_name, :phone_number, :zip_code, :email, :city, :state, :address

  def initialize(input = {})
    @first_name = (input[:first_name]).downcase unless (input[:first_name]).nil?
    @last_name = (input[:last_name]).downcase unless (input[:first_name]).nil?
    @phone_number = PhoneNumber.new(input[:phone_number]).number
    @zip_code = ZipCode.new(input[:zip_code]).zip_code
    @email = (input[:email]).downcase unless (input[:email]).nil?
    @city = (input[:city]).downcase unless (input[:city]).nil?
    @state = (input[:state]).downcase unless (input[:state]).nil?
    @address = (input[:address]).downcase unless (input[:address]).nil?
  end

end
