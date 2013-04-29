# include this module
# to enable hstore atomic update for activerecord
module ActiveRecord
  module Hstore
    # with single quotes (double quotes are for field names)
    # double quotes generated by ActiveRecord::ConnectionAdapters::PostgresSQLColumn.hstore_to_string will generate error
    def Hstore.escape value
      if value.nil?
        'NULL'
      elsif value == ""
        "''"
      else
        "'%s'" % value.to_s.gsub(/(["\\])/, '\\\\\1')
      end
    end

    # NOTE be care that the record in memory is not changed
    def hstore_update! field, hash
      table = self.class.table_name
      unless hash.empty?
        value = hash.map { |k, v|
          "#{Hstore.escape k}=>#{Hstore.escape v}"
        }.join ','
        ActiveRecord::Base.connection.update_sql \
          %<update #{table} set "#{field}" = "#{field}" || (#{value}) where id=#{id}>
      end
    end

    def hstore_delete! field, key
      table = self.class.table_name
      ActiveRecord::Base.connection.update_sql \
        %<update #{table} set "#{field}" = delete("#{field}", '#{key}')>
    end
  end
end
