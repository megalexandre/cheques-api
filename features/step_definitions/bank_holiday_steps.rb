

Dado('que {string} é um feriado bancário') do |date|
  FactoryBot.create(:bank_holiday, date: Date.parse(date))
end
