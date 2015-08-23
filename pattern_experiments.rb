# I am going to try to implement syntax for elixir like pattern matching across functions in Ruby
# Some ideas for implementation:
# __DATA__ & __END__ w/ eval?
# eval(str.gsub("\n", "; ")) will transform multi line string method into valid method

module Pattern
  def match(&block)

  end
end

class User
  extend Pattern

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
  end
end

User.new
