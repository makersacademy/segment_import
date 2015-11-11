# Don't forget to update the CSV
require "csv"
require './segment'

people = CSV.read("mailchimp_export.csv")

p "Uploading newsletter subscribers"

people.map! { |person| person[0] }.uniq.each do |email|
  analytics.identify(
    user_id: email,
    traits: {
      email: email,
      newsletter: true,
      integrations: { all: false, :'Customer.io' => true }
    })
end

analytics.flush
