require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)

    Customer.where(first: "Candice")
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    pattern = "@"
    Customer.where('email LIKE ?', "%#{pattern}%")
  end
  def self.with_dot_org_email
    pattern = ".org"
    Customer.where('email LIKE ?', "%#{pattern}")
  end
  def self.with_invalid_email
    pattern = "@"
    Customer.where.not('email LIKE ? OR email IS NULL', "%#{pattern}%")
  end
  def self.with_blank_email
    Customer.where(email: nil)
  end
  def self.born_before_1980
    Customer.where.not(birthdate: Time.new(1980)..Time.now)
  end
  def self.with_valid_email_and_born_before_1980
    self.with_valid_email.where.not(birthdate: Time.new(1980)..Time.now)
  end
  def self.last_names_starting_with_b
    pattern = "B"
    Customer.where('last LIKE ?', "#{pattern}%").order(:birthdate)
  end
  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end
  def self.update_gussie_murray_birthdate
    Customer.find_by(first: "Gussie", last: "Murray").update(birthdate: Time.parse("2004-2-8"))
  end
  def self.change_all_invalid_emails_to_blank
    self.with_invalid_email.update_all(email: nil)
  end
  def self.delete_meggie_herman
    Customer.find_by(first: "Meggie", last: "Herman").delete
  end
  def self.delete_everyone_born_before_1978
    Customer.where.not(birthdate: Time.new(1978)..Time.now).delete_all
  end
  # etc. - see README.md for more details
end
