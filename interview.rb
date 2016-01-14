require "customerio"

$customerio = Customerio::Client.new("1e33a928c444c64bef71", "61046cda9281a2d1e731")
file = File.read("mess.txt").split("\n")
file = ["deetee81@gmail.com"]
file.each do |email|
  $customerio.identify(
    id: email,
    email: email,
    :'Current Stage' => 'Interview Offered'
  )
  p email
end
