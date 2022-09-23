tree = {
  "value" => 1,
  "left" => {
    "value" => 2,
    "left" => {
      "value" => 4,
      "left" => {
        "value" => 4,
      },
    },
    "right" => { "value" => 5 },
  },
  "right" => {
    "value" => 3,
    "left" => { "value" => 6 },
    "right" => { "value" => 7 },
  }
}

def transpose(hash)
  hash.each do |key, value|
    if value.is_a?(Hash)
      transpose(value)
      value['left'], value['right'] = value['right'], value['left']
    end
  end
end

transpose(tree)
tree['left'], tree['right'] = tree['right'], tree['left']

tree = tree.reject {
  |key, value| 
puts "#{key}: #{value} "
}