# I am going to try to implement syntax for elixir like pattern matching across functions in Ruby
# Some ideas for implementation:
# __DATA__ & __END__ w/ eval?
# eval(str.gsub("\n", "; ")) will transform multi line string method into valid method

module Pattern
  def match(&block)
    @@hash = {}      # => {}

    block.call.map do |method|  # => [["def fib(0)", 0, "end"], ["def fib(1)", 1, "end"], ["def fib(:x)", "puts fib(x-2) + fib(x-1)", "end"]]
      var = method.first        # => "def fib(0)", "def fib(1)", "def fib(:x)"
      .match(/\(.*\)/).to_s     # => "(0)", "(1)", "(:x)"
      .delete("(").delete(")")  # => "0", "1", ":x"

      @@hash[method] = var  # => "0", "1", ":x"

      eval(var) if var.instance_of? String  # => 0, 1, :x
    end                                     # => [0, 1, :x]

    define_method block.call.first.first.split("(").first.split(" ").last do |*args|
      @@hash                                                                                 # => {["def fib(0)", 0, "end"]=>"0", ["def fib(1)", 1, "end"]=>"1", ["def fib(:x)", "puts fib(x-2) + fib(x-1)", "end"]=>":x"}
      strict_method = @@hash.find { |method, arg| method if arg.include?(args.first.to_s) }  # => nil
      if strict_method                                                                       # => nil
        matched_method = strict_method.first[1..-2]
      else
        @@hash.keys.last[1..-2]                                                        # ~> TypeError: no implicit conversion of Array into String
      end
    end                                                                                      # => :fib
  end
end

class User
  extend Pattern  # => User

  match do
    [["def fib(0)",  # => "def fib(0)", "def fib(0)"
      0,             # => 0, 0
    "end"],          # => ["def fib(0)", 0, "end"], ["def fib(0)", 0, "end"]

     ["def fib(1)",  # => "def fib(1)", "def fib(1)"
       1,            # => 1, 1
     "end"],         # => ["def fib(1)", 1, "end"], ["def fib(1)", 1, "end"]

     ["def fib(:x)",                # => "def fib(:x)", "def fib(:x)"
       "puts fib(x-2) + fib(x-1)",  # => "puts fib(x-2) + fib(x-1)", "puts fib(x-2) + fib(x-1)"
     "end"]]                        # => [["def fib(0)", 0, "end"], ["def fib(1)", 1, "end"], ["def fib(:x)", "puts fib(x-2) + fib(x-1)", "end"]], [["def fib(0)", 0, "end"], ["def fib(1)", 1, "end"], ["def fib(:x)", "puts fib(x-2) + fib(x-1)", "end"]]
  end                               # => :fib
end

User.new.fib(10)

# ~> TypeError
# ~> no implicit conversion of Array into String
# ~>
# ~> /Users/levkravinsky/Desktop/function_matching/pattern_experiments.rb:26:in `eval'
# ~> /Users/levkravinsky/Desktop/function_matching/pattern_experiments.rb:26:in `block in match'
# ~> /Users/levkravinsky/Desktop/function_matching/pattern_experiments.rb:50:in `<main>'
