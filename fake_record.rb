module FakeRecord
  class Column < Struct.new(:name, :type)
  end

  class Connection
    attr_reader :tables
    attr_accessor :visitor

    def initialize(visitor = nil)
      @visitor = visitor
    end

    def columns_hash table_name
      {}
    end

    # def primary_key name
    #   @primary_keys[name.to_s]
    # end

    def table_exists? name
      true
    end

    # def columns name, message = nil
    #   @columns[name.to_s]
    # end

    def quote_table_name name
      "\`#{name.to_s}\`"
    end

    def quote_column_name name
      "\`#{name.to_s}\`"
    end

    def schema_cache
      self
    end

    def quote thing, column = nil
      if column && !thing.nil?
        case column.type
        when :integer
          thing = thing.to_i
        when :string
          thing = thing.to_s
        end
      end

      case thing
      when DateTime
        "'#{thing.strftime("%Y-%m-%d %H:%M:%S")}'"
      when Date
        "'#{thing.strftime("%Y-%m-%d")}'"
      when true
        "'t'"
      when false
        "'f'"
      when nil
        'NULL'
      when Numeric
        thing
      else
        "'#{thing.to_s.gsub("'", "\\\\'")}'"
      end
    end
  end

  class ConnectionPool
    class Spec < Struct.new(:config)
    end

    attr_reader :spec, :connection

    def initialize
      @spec = Spec.new(:adapter => 'america')
      @connection = Connection.new
      @connection.visitor = Arel::Visitors::MySQL.new(connection)
    end

    def with_connection
      yield connection
    end

    def table_exists? name
      true
    end

    def columns_hash
      connection.columns_hash
    end

    def schema_cache
      connection
    end

    def quote thing, column = nil
      connection.quote thing, column
    end
  end

  class Base
    attr_accessor :connection_pool

    def initialize
      @connection_pool = ConnectionPool.new
    end

    def connection
      connection_pool.connection
    end
  end
end

Arel::Table.engine = FakeRecord::Base.new
