class CreateCustomField < ActiveRecord::Migration

    def self.up
        ProjectCustomField.create(
            :name => "Client",
            :field_format => "string",
            :is_required => true
        ).save()
    end

    def self.down
        
    end

end