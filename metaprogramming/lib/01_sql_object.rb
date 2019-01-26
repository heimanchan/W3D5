require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @column_names ||= DBConnection.execute2("SELECT * FROM #{self.table_name}")[0].map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do 
        self.attributes[col]
      end
      # debugger
      define_method("#{col}=") do |val|
        self.attributes[col] = val
      end 
    end
  end

  def self.table_name=(table_name)
     @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    self.parse_all(DBConnection.execute("SELECT * FROM #{self.table_name}"))
  end

  def self.parse_all(results)
    # self.new()
    objects = []
    results.each do |result|
      objects << self.new(result)
    end
    objects
  end

  def self.find(id)
    self.all.find { |obj| obj.id == id }
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      raise "unknown attribute \'#{attr_name}\'" if !self.class.columns.include?("#{attr_name}".to_sym)
      self.send("#{attr_name}=", val)
    end
    
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.columns
  end

  def insert
    col_names = self.columns.join(', ')
    question_marks = ["?"] * col_names.length
    DBConnection.execute(<<-SQL)
      
    SQL
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
