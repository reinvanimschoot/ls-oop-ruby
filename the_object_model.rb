# 1. How do we create an object in Ruby? Give an example of the creation of an object.

# Answer:

# We call the .new method on the class to instantiate a new object of that class.

class GoodDog
end

sparky = GoodDog.new

# 2. What is a module? What is its purpose? How do we use them with our classes?
#    Create a module for the class you created in exercise 1 and include it properly.

=begin

A module is a collection of attributes and behaviours that you can add to existing classes
to enrich their set of behaviours and attributes without having to resort to using inheritance.

We use them in classes by adding them using the 'include' keyword.

=end

module Speak
  def speak
    puts "Woof!"
  end
end

class GoodDog
  include Speak
end

sparky = GoodDog.new
sparky.speak
