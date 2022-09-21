def isaClosedParanthesis? input_string
  return false if input_string.length.odd? || input_string =~ /[^\[\]\(\)\{\}]/ 
  bracket_pairs = { '{' => '}', '[' => ']', '(' => ')' }

  leftbracket_stack = []
  
  input_string.chars do |bracket|
    if expectation = bracket_pairs[bracket]
      leftbracket_stack.push(expectation)   # leftbracket_stack ====> ) } ]
    else
      return false unless leftbracket_stack.pop == bracket
    end
  end
  return true
end




def Main()
  p isaClosedParanthesis?("(){}[]")   
  p isaClosedParanthesis?("([{}])") 
  p isaClosedParanthesis?("(}")     #FALSE
    p isaClosedParanthesis?("[(])")     #FALSE
    p isaClosedParanthesis?("[({})](]")  #FALSE
    p isaClosedParanthesis?("[)]")  #FALSE
    p isaClosedParanthesis?("(({{[[]]}}[])[{]})")
end

Main()
