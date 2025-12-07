Dado('que a data atual é {string}') do |date_string|
  travel_to Time.zone.parse(date_string)
end


After do |_scenario|
  travel_back
end
