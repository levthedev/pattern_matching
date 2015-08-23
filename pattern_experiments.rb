# I am going to try to implement syntax for elixir like pattern matching across functions in Ruby
# Some ideas for implementation:
# __DATA__ & __END__ w/ eval?
# eval(str.gsub("\n", "; ")) will transform multi line string method into valid method

module Pattern
  def match(&block)
    block.call.map do |method|                       # => [["def fib(0)", 0, "end"], ["def fib(1)", 1, "end"], ["def fib(:x)", "fib(x-2) + fib(x-1)", "end"]]
      var = method.first                             # => "def fib(0)", "def fib(1)", "def fib(:x)"
      .match(/\(.*\)/).to_s.delete("(").delete(")")  # => "0", "1", ":x"
      eval(var) if var.instance_of? String           # => 0, 1, :x
    end                                              # => [0, 1, :x]
  end
end

class User
  extend Pattern  # => User

  match do
    [["def fib(0)",  # => "def fib(0)"
      0,             # => 0
    "end"],          # => ["def fib(0)", 0, "end"]

     ["def fib(1)",  # => "def fib(1)"
       1,            # => 1
     "end"],         # => ["def fib(1)", 1, "end"]

     ["def fib(:x)",           # => "def fib(:x)"
       "fib(x-2) + fib(x-1)",  # => "fib(x-2) + fib(x-1)"
     "end"]]                   # => [["def fib(0)", 0, "end"], ["def fib(1)", 1, "end"], ["def fib(:x)", "fib(x-2) + fib(x-1)", "end"]]
  end                          # => [0, 1, :x]
end

User.new  # => #<User:0x007ff1f30e8908>
