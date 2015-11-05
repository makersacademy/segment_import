require 'csv'
require './segment'

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
    cohort: cohort,
    referring_domain: person["$initial_referring_domain"],
    pipedrive_deal_id: person["Pipedrive Deal ID"],
    course_type: person["Course Type"],
    interview_quality: person["Interview Quality"],
    course_quality: person["Course Quality"],
    current_stage: person["Current Stage"]
  }

  if person["$first_name"] && person["$last_name"]
    segment_trait[:name] = person["$first_name"] + " " + person["$last_name"]
  end

  analytics.identify(
    user_id: person["$email"] || person["$distinct_id"],
    traits: segment_trait)
end

# Find all duplicate emails
#p people.compact.map { |value| value["$email"] }.compact.group_by(&:itself).select { |key, array| array.length >= 2 }.keys

p "finished uploading people to segment"
analytics.flush
