require_relative 'vending_machine.rb'

vending_machine = VendingMachine.new

while vending_machine.items_present? do
  begin
    vending_machine.perform
  rescue StandardError => e
    puts e.message
  end
  sleep 3
end
  puts 'All Items are over, Bye!'
