=begin

1. Add a class method to your MyCar class that calculates the gas mileage of any car.

2. Override the to_s method to create a user friendly print out of your object.

=end

class MyCar
  attr_accessor :color, :speed
  attr_reader :year

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def to_s
    "This car is a #{@model}, #{year} with a #{color} color."
  end

  def initialize(color, model, year)
    @color = color
    @model = model
    @year = year

    @speed = 0
  end

  def speed_up
    self.speed += 10
  end

  def brake
    self.speed -= 10
  end

  def shut_down
    self.speed = 0
  end

  def spray_paint(color)
    self.color = color
  end
end

car = MyCar.new("grey", "tesla", "2020")

p car.to_s

=begin
  When running the following code...

  class Person
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

bob = Person.new("Steve")
bob.name = "Bob"

We get the following error...

test.rb:9:in `<main>': undefined method `name=' for
  #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

Why do we get this error and how do we fix it?
=end

# We get this error because we did not specify a setter method for the name attribute on Person.
# Right now, we only have a getter method (by virtue of attr_reader) for name, so we can read it but
# not write it.

# The solution would be to add a setter method by converting attr_reader to attr_accessor.
