module MomentumCms
  class Tableless < ActiveRecord::Base

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    def self.columns
      @columns ||= []
    end

    def self.columns_hash
      h = {}
      self.columns.each do |c|
        h[c.name] = c
      end
      h
    end

    def self.column_defaults
      Hash[self.columns.map { |col| [col.name, col.default] }]
    end

    def self.descends_from_active_record?
      true
    end

    def persisted?
      false
    end

    # override the save method to prevent exceptions
    def save(validate = true)
      validate ? valid? : true
    end
  end
end

