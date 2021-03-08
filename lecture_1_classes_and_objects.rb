
=begin 

1. Given the below usage of the Person class, code the class definition.

bob = Person.new('bob')
bob.name                  # => 'bob'
bob.name = 'Robert'
bob.name  

=end

class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

=begin

2. Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'

=end

class Person
  attr_accessor :first_name, :last_name

  def initialize(first_name, last_name="")
    @first_name = first_name
    @last_name = last_name
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end

=begin

3. Now create a smart name= method that can take just a first name or a full name, and knows how to set the first_name and last_name appropriately.

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
bob.first_name            # => 'John'
bob.last_name             # => 'Adams'

=end

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  private

  def parse_full_name(full_name)
    first_name, last_name = name.split

    self.first_name = first_name
    self.last_name = last_name || ""
  end
end

=begin

4. Using the class definition from step #3, let's create a few more people -- that is, Person objects.

If we're trying to determine whether the two objects contain the same name, how can we compare the two objects?

=end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

bob.name == rob.name

=begin

5. Continuing with our Person class definition, what does the below print out?

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"

=end

# It calls to_s on the object, giving you something along the lines of <Person#1712798321 .... >, which represents the object's place in memory.

=begin

class Person
  # ... rest of class omitted for brevity

  def to_s
    name
  end
end

Now, what does the below output?

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"

=end

# => "The person's name is Robert Smith"