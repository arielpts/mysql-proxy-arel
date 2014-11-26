def method_missing(meth, *args, &block)
  if !['to_ary', 'to_hash', 'to_io', 'to_str', 'to_int'].include? meth.to_s
    Arel::Table.new meth.to_sym
  else
    super
  end
end

module Arel
  class Table
    def select *things
      project *things
    end
  end
end

def all
  Arel.sql('*')
end

def syntax_sugar_replaces ruby
  ruby.gsub(/\(\*\)/, '(all)')
end