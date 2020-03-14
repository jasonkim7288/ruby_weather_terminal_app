require 'json'

a = '[{"a":1, "b":"hi"}]'
b = JSON.parse(a)
p b
p b[0].key?("a")
