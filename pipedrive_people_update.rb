require 'csv'
require './segment'
require 'pipedrive-ruby'

Pipedrive.authenticate(ENV["8ceba34832cf455201c53ff48cb91452c93c2e08"])
#people = CSV.read("pipedrive_export.csv")

people = Pipedrive::Person.all
p people
return
headers = people.shift

p "uploading people"
people.map! do |person|
  person = Hash[headers.zip(person)]
end

people.each do |person|

  cohort = person["Person - Cohort"]
  email = person["Person - Email"]
  p email
  p person
  stage = person["Deal - Stage"]
  course_type = person["Person - Course Type"]
  name = person["Person - Name"].match(/([a-z\-]+) ?(.+)?/i)

  next if cohort.empty? || cohort == "Hidden"

  if stage == "Application"
    stage = (course_type == "Online") ? "Online Application Submitted" : "Application Submitted"
  end



  segment_trait = {
    firstName: name[1],
    lastName: name[2],
    email: email,
    Cohort: cohort,
    :"Course Type" => course_type,
    :'Current Stage' => stage
  }

  p "Uploading person #{segment_trait}"

  analytics.identify(
    user_id: email,
    traits: segment_trait,
    integrations: { all: false, :'Customer.io' => true }
  )
end

analytics.flush
p "finished uploading people to segment"
