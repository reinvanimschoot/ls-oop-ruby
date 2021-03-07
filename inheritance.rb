=begin

1. Create a superclass called Vehicle for your MyCar class to inherit from and move the behavior that isn't specific
to the MyCar class to the superclass. Create a constant in your MyCar class that stores information about
the vehicle that makes it different from other types of Vehicles.

Then create a new class called MyTruck that inherits from your superclass that
also has a constant defined that separates it from the MyCar class in some way.

2. Add a class variable to your superclass that can keep track of the number of objects created that inherit from the superclass.
Create a method to print out the value of this class variable as well.

3. Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to that subclass.

4. Print to the screen your method lookup for the classes that you have created.

5. Move all of the methods from the MyCar class that also pertain to the MyTruck class into the Vehicle class.
Make sure that all of your previous method calls are working when you are finished.

6. Write a method called age that calls a private method to calculate the age of the vehicle.
Make sure the private method is not available from outside of the class.
You'll need to use Ruby's built-in Time class to help.

=end

class Vehicle
  attr_accessor :color
  attr_reader :model, :year

  @@number_of_vehicles = 0

  def initialize(color, model, year)
    @year = year
    @model = model
    @color = color
    @current_speed = 0

    @@number_of_vehicles += 1
  end

  def age
    age = calculate_age

    puts "This vehicle is #{age} years old."
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

  def self.total_number_of_vehicles
    @@number_of_vehicles
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  private

  def calculate_age
    Time.now.year - self.year
  end
end

module Loadable
  def load_cargo
    "Loading cargo..."
  end
end

class MyCar < Vehicle
  DOORS = 4
end

class MyTruck < Vehicle
  include Loadable
  DOORS = 2
end

# car = MyCar.new("Gray", "Tesla", 2015)

# car.age

=begin

7. Create a class 'Student' with attributes name and grade.
Do NOT make the grade getter public, so joe.grade will raise an error.
Create a better_grade_than? method, that you can call like so...

=end

class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    self.grade > other_student.grade
  end

  protected

  attr_reader :grade
end

robbie = Student.new("Robbie", 78)
billy = Student.new("Billy", 64)

p robbie.grade
p robbie.better_grade_than?(billy)

=begin

8. Given the following code...

bob = Person.new
bob.hi

And the corresponding error message...

NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
from (irb):8
from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'

What is the problem and how would you go about fixing it?

=end

# We are trying to call a private method named 'hi' on an instance of the Person class.
# We could fix this by setting this method as a public method.
