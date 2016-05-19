require 'csv'
require './segment'

people = CSV.read("hp_upload.csv")

headers = people.shift

p "uploading people"
people.map! do |person|
  person = Hash[headers.zip(person)]
end

people.each do |person|

  company = person["Company"]
  email = person["Email"]
  p email
  p person
  name = person["firstName"]

  segment_trait = {
    firstName: name,
    email: email,
    Company: company,
    :"Hiring Partner" => true
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
