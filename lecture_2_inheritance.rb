=begin

1. Given this class:

class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

One problem is that we need to keep track of different breeds of dogs,
since they have slightly different behaviors.
For example, bulldogs can't swim, but all other dogs can.

Create a sub-class from Dog called Bulldog overriding the swim method to return "can't swim!"

=end

class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim :("
  end
end

=begin

2. Let's create a few more methods for our Dog class.

class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def fetch
    'fetching!'
  end
end

Create a new class called Cat, which can do everything a dog can, except swim or fetch. Assume the methods do the exact same thing.
Hint: don't just copy and paste all methods in Dog into Cat; try to come up with some class hierarchy.

=end

class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Cat < Animal
  def speak
    'meow!'
  end
end

class Dog < Animal
  def speak
    'bark!'
  end

  def fetch
    'fetching!'
  end

  def swim
    'swimming!'
  end
end

=begin

What is the method lookup path and how is it important?

=end

=begin

The method lookup path defines where and in what order Ruby searches for the method to invoke when its called.
By definition it will first search the class of the instantiated object itself, then its modules (starting from the last added first)
and then doing the same thing for all its ancestor classes until it reaches Object and BasicObject.

It's important because you want to have a good idea of where your methods come from. You don't want to override them by accident
and you also don't want Ruby to look for a method in a place you didn't expect it to look.

=end