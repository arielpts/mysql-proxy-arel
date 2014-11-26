require 'arel'
require_relative 'fake_record'
require_relative 'syntax_sugar'

ruby = syntax_sugar_replaces ARGV[0]

ruby_array = ruby.split("\n")
ruby_array[-1] = "query = #{ruby_array[-1]}" unless ruby_array[-1] =~ /query/
ruby = ruby_array.join("\n")

begin
  eval(ruby + '; puts query.to_sql')
rescue Exception => se
  puts "Ruby Error:\n" + se.to_s.gsub(/\(eval\):[0-9]*:/, '')
end