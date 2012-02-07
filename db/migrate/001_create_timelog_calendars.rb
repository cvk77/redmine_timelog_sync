class CreateTimelogCalendars < ActiveRecord::Migration
  def self.up
    create_table :timelog_calendars do |t|
      t.column :username, :string
      t.column :password, :string
      t.column :name, :string
      t.references :user
    end
  end

  def self.down
    drop_table :timelog_calendars
  end
end
