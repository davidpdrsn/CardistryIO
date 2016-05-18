#
# Calculate how much it costs to keep the site running
#
# Usage:
#   $ ruby expense_report.rb
#

module Dollar
  def self.new(amount)
    Cent.new(amount * 100)
  end
end

class Cent
  def initialize(amount)
    @amount = amount
  end

  def cents
    @amount % 100
  end

  def dollars
    @amount / 100
  end

  def to_s
    "$#{dollars}.#{cents}"
  end

  def +(other)
    Cent.new(@amount + other.amount)
  end

  def *(scalar)
    Cent.new(@amount * scalar)
  end

  def /(scalar)
    Cent.new(@amount / scalar)
  end

  protected

  attr_reader :amount
end

class Expense
  def initialize(name, cost, notice: nil)
    @name = name
    @cost = cost
    @notice = notice
  end

  attr_reader :name
  attr_reader :notice

  class Daily < Expense
    def daily_cost
      @cost
    end

    def monthly_cost
      @cost * 12
    end

    def yearly_cost
      @cost * 365
    end

    def interval
      "day"
    end
  end

  class Monthly < Expense
    def daily_cost
      @cost / 12
    end

    def monthly_cost
      @cost
    end

    def yearly_cost
      @cost * 12
    end

    def interval
      "month"
    end
  end

  class Yearly < Expense
    def daily_cost
      @cost / 365
    end

    def monthly_cost
      @cost / 12
    end

    def yearly_cost
      @cost
    end

    def interval
      "year"
    end
  end
end

expenses = [
  Expense::Monthly.new("Rollbar", Dollar.new(0)),
  Expense::Monthly.new("Digital Ocean", Dollar.new(10)),
  Expense::Monthly.new("Digital Ocean Weekly Backups", Dollar.new(2)),
  Expense::Monthly.new("Skylight", Dollar.new(0)),
  Expense::Monthly.new("Pingdom", Dollar.new(18)),
]

expenses.sort_by(&:name).each do |expense|
  print "#{expense.name}: #{expense.monthly_cost} per #{expense.interval}"

  if expense.notice
    puts ", #{expense.notice}"
  else
    puts ""
  end
end

puts ""

daily_cost = expenses.map(&:daily_cost).reduce(Dollar.new(0), :+)
puts "Daily cost: #{daily_cost}"

monthly_cost = expenses.map(&:monthly_cost).reduce(Dollar.new(0), :+)
puts "Monthly cost: #{monthly_cost}"

yearly_cost = expenses.map(&:yearly_cost).reduce(Dollar.new(0), :+)
puts "Yearly cost: #{yearly_cost}"
