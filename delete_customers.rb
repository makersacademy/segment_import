require 'csv'
require 'customerio'

$customerio = Customerio::Client.new("1e33a928c444c64bef71", "61046cda9281a2d1e731")

customers = CSV.foreach('customers.csv').each do |customer|
  p "Deleting #{customer[0]}"
  $customerio.delete(customer[0])
end

