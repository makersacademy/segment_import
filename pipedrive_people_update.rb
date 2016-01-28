require 'csv'
require './segment'

people = CSV.read("pipedrive_export.csv")

headers = people.shift

p "uploading people"
people.map! do |person|
  person = Hash[headers.zip(person)]
end

people.each do |person|

  cohort = person["Person - Cohort"]
  email = person["Person - Email"]
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
