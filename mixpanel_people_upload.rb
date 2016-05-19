require 'csv'
require './segment'

analytics.track(user_id: "nikesh@makersacademy.com", event: "Application Submitted")
analytics.flush
raise "stop here"

people = CSV.read("people_export.csv")

headers = people.shift

p "uploading people"
people.map! do |person|
  person = Hash[headers.zip(person)]
end

people.each do |person|

  cohort = person["Cohort"]

  unless cohort.nil? || cohort.start_with?("Ronin")
    cohort = Date.parse(cohort).strftime("%b %Y")
  end

  segment_trait = {
    email: person["$email"],
    firstName: person["$first_name"],
    lastName: person["$last_name"],
    lastSeen: person["$last_seen"],
    username: person["$username"],
    phone: person["Phone Number"],
    #Make sure is a string like Jan 2015
    Cohort: cohort,
    :'Referring Domain' => person["$initial_referring_domain"],
    :'Pipedrive Deal ID' => person["Pipedrive Deal ID"],
    :'Course Type' => person["Course Type"],
    :'Interview Quality' => person["Interview Quality"],
    :'Course Quality' => person["Course Quality"],
    :'Current Stage' => person["Current Stage"]
  }

  if person["Current Stage"] == "Signed up for newsletter"
    segment_trait[:Newsletter] = true
  end

  if person["$first_name"] && person["$last_name"]
    segment_trait[:name] = person["$first_name"] + " " + person["$last_name"]
  end

  analytics.identify(
    user_id: person["$email"] || person["$distinct_id"],
    traits: segment_trait,
    integrations: { all: false, :'Customer.io' => true }
  )
end

# Find all duplicate emails
#p people.compact.map { |value| value["$email"] }.compact.group_by(&:itself).select { |key, array| array.length >= 2 }.keys

p "finished uploading people to segment"
analytics.flush
