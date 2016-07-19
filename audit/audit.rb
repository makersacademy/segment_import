require 'csv'

PIPEDRIVE_EMAIL = "Person - Email"

class Student

  def initialize(pipedrive_data, customerio_data)
    @pipedrive = pipedrive_data
    @customerio = customerio_data
  end

  def matching_email?
    pipedrive_email == customerio_email
  end

  def matching?
    matching_email? && matching_stage?
  end

  def matching_stage?
    return true if @pipedrive["Deal - Stage"] == "1st Contact"
    @pipedrive["Deal - Stage"] == @customerio["Current Stage"]
  end

  def pipedrive_email
    @pipedrive[PIPEDRIVE_EMAIL]
  end

  def customerio_email
    return unless @customerio
    @customerio["email"]
  end

  def to_s
    "Pipedrive:
    #{@pipedrive}
    CustomerIO:
    #{@customerio}\n\n"
  end

  def self.audit_all
    customer_io_customers = CustomerIOStudents.load(CSVDump.read("./audit/customer-io.csv"))

    found = CSVDump.read("./audit/pipedrive.csv").map do |pipedrive_student|
      customer_io_customer = customer_io_customers.find_by_email(pipedrive_student[PIPEDRIVE_EMAIL])
      new(pipedrive_student, customer_io_customer)
    end
      .reject(&:matching?)
      .map(&:to_s)
      .each { |student| puts student }

    puts "#{found.length} found"
  end
end

class CustomerIOStudents

  attr_reader :students

  def initialize(students)
    @students = students
  end

  def find_by_email(email)
    students.find do |student|
      student["email"] == email
    end
  end

  def self.load(students)
    new(students)
  end
end

class CSVDump
  def self.read(file)
    data = CSV.read(file)
    headers = data.shift

    data.map do |row|
      Hash[headers.zip(row)]
    end
  end
end

Student.audit_all

