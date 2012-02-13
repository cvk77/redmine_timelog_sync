class TimelogCalendar < ActiveRecord::Base
    unloadable

    named_scope :by_user, lambda {|user| {:conditions => {:user_id => user.id}}}

    validate :password_correct

    def password_correct
        c = CalDAV::Connection.new("/#{self.username}/#{self.name}", self.username, self.password)
        code = c.check_login.code
        if code == "401":
            errors.add(:password, "mismatch")
        end
    end


end