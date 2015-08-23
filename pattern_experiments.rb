# I am going to try to implement syntax for elixir like pattern matching across functions in Ruby
# Some ideas for implementation:
# __DATA__ & __END__ w/ eval?
# eval(str.gsub("\n", "; ")) will transform multi line string method into valid method

module Pattern
  def match(&block)
    block.call.map do |method|  # => ["def fib(0)\n      0\n    end", "def fib(1)\n      1\n    end", "def fib(x)\n      fib(x-2) + fib(x-1)\n    end"]
      method.gsub("\n", "; ")    # => "def fib(0);       0;     end", "def fib(1);       1;     end", "def fib(x);       fib(x-2) + fib(x-1);     end"
    end                          # => ["def fib(0)\n      0\n    end", "def fib(1)\n      1\n    end", "def fib(x)\n      fib(x-2) + fib(x-1)\n    end"]
  end
end

class User
  extend Pattern  # => User

  match do
    [%q(def fib(0)
      0
    end),   # => "def fib(0)\n      0\n    end"

    %q(def fib(1)
      1
    end),  # => "def fib(1)\n      1\n    end"

    %q(def fib(x)
      fib(x-2) + fib(x-1)
    end)]  # => ["def fib(0)\n      0\n    end", "def fib(1)\n      1\n    end", "def fib(x)\n      fib(x-2) + fib(x-1)\n    end"]
  end      # => ["def fib(0)\n      0\n    end", "def fib(1)\n      1\n    end", "def fib(x)\n      fib(x-2) + fib(x-1)\n    end"]
end

User.new  # => #<User:0x007ff8038a7458>
