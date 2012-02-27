# Based on http://github.com/edavis10/question_plugin/blob/master/lib/question_query_patch.rb
require_dependency 'query'

module QueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      base.add_available_column(QueryColumn.new(:spent_hours))
    end

  end

  module ClassMethods
    unless Query.respond_to?(:available_columns=)
      # Setter for +available_columns+ that isn't provided by the core.
      def available_columns=(v)
        self.available_columns = (v)
      end
    end

    unless Query.respond_to?(:add_available_column)
      # Method to add a column to the +available_columns+ that isn't provided by the core.
      def add_available_column(column)
        self.available_columns << (column)
      end
    end
  end
end
