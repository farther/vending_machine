class VendingMachine
  attr_accessor :machine_money, :machine_balance, :items, :item_prices, :user_money, :user_balance, :chosen_item

  def initialize
    @machine_money = rnd_cash_generator
    @machine_balance = count_balance(machine_money)
    @items = rnd_item_generator
    @item_prices = item_prices_list
    @user_money = money_zero
  end

  def perform
    invite_message
    choose_item
    take_money
    check_change
    replenish_balance
    give_item
    give_change
  end

  def items_present?
    number_of_items = 0
    items.keys.each do |key|
      number_of_items += items[key]
    end
    number_of_items > 0
  end

  private

  def invite_message
    # puts machine_money
    puts '', 'You can bye next items from list:'
    items.keys.each { |key| puts "#{key} - #{items[key]} pieces  with prise #{item_prices[key]}}" }
  end

  def choose_item
    item_name = ''
    while items[item_name.to_sym].nil? do
      puts 'Input the Items name:'
      item_name = input
    end
    @chosen_item = item_name.to_sym
    raise StandardError, "Sorry #{chosen_item} is over" if items[chosen_item] == 0
  end

  def take_money
    balance = 0
    loop do
      puts "Input the cash number from list #{machine_money.keys} or 'x' to stop: Your Balance #{balance}"
      inputed = input
      break if inputed == 'x'
      unless machine_money[inputed.to_s.to_sym].nil?
        balance = balance + inputed.to_i
        user_money[inputed.to_s.to_sym] += 1
      end
    end
    @user_balance = balance
    raise StandardError, "Not enough for #{chosen_item} take yor money back" if balance < item_prices[chosen_item]
  end

  def give_item
    items[chosen_item] -= 1
    puts "Take your #{chosen_item.capitalize}"
  end

  def give_change
    change_amount = user_balance - item_prices[chosen_item]
    return puts "Thank you!" if change_amount == 0

    change_money = money_zero
    while change_amount > 0 do
      machine_money.keys.each do |key|
        while machine_money[key] > 0 && change_amount >= key.to_s.to_i
          change_amount -= key.to_s.to_i
          change_money[key] += 1
          machine_money[key] -= 1
        end
      end
    end
    # puts "rest cash #{machine_money}"
    puts "Take your change #{change_money}"
  end

  def check_change
    next_step_var = change_amount = user_balance - item_prices[chosen_item]
    error_message = 'Sorry I did not have change for you, take your money back'

    raise StandardError, error_message if machine_balance < change_amount

    virtual_machine_money = create_virtual_money

    while change_amount > 0 do
      virtual_machine_money.keys.each do |key|
        while virtual_machine_money[key] > 0 && change_amount >= key.to_s.to_i
          change_amount -= key.to_s.to_i
          virtual_machine_money[key] -= 1
        end
      end
      raise StandardError, error_message if next_step_var == change_amount
      next_step_var = change_amount
    end
  end

  def input
    gets.chomp
  end

  def count_balance(obj)
    balance = 0
    obj.keys.each do |key|
      balance = balance + key.to_s.to_i * obj[key]
    end
    balance
  end

  def replenish_balance
    machine_money.keys.each do |key|
      machine_money[key] = machine_money[key] + user_money[key]
    end
  end

  def create_virtual_money
    virtual_machine_money = {}
    machine_money.keys.each do |key|
      virtual_machine_money[key] = machine_money[key]
    end
    virtual_machine_money
  end

  def rnd_cash_generator
    {
      '500': rand(0..5),
      '200': rand(0..5),
      '100': rand(0..5),
      '50': rand(0..5),
      '25': rand(0..5),
    }
  end

  def money_zero
    {
      '500': 0,
      '200': 0,
      '100': 0,
      '50': 0,
      '25': 0,
    }
  end

  def rnd_item_generator
    {
      water: rand(1..3),
      soda: rand(1..3),
      beer: rand(1..3),
    }
  end

  def item_prices_list
    {
      water: 75,
      soda: 150,
      beer: 350,
    }
  end
end
