# I am going to try to implement syntax for elixir like pattern matching across functions in Ruby
# Some ideas for implementation:
# __DATA__ & __END__ w/ eval?

module Pattern
  def match(&block)
    p "hi"           # => "hi"
  end
end

class User
  extend Pattern  # => User

  def initialize
  end

  match do
    [%q(def fib(0)
      0
    end)]

    [%q(def fib(1)
      1
    end)]

    [%q(def fib(x)
      fib(x-2) + fib(x-1)
    end)]
  end      # => "hi"
end

User.new  # => #<User:0x007ffa4991a550>

# >> "hi"
