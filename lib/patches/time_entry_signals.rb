module TimelogSync

    module Patches

        module TimeEntryPatch

            def self.included(base)
                base.extend(ClassMethods)
                base.send(:include, InstanceMethods)

                base.class_eval do
                    unloadable

                    after_create :create_on_caldav
                    after_update :update_on_caldav
                    after_destroy :delete_from_caldav

                end
            end

            module ClassMethods
            end

            module InstanceMethods
                def create_on_caldav
                    TimelogSync::logger.debug("create_on_caldav")
                    TimelogSync.create(self)
                end

                def update_on_caldav
                    TimelogSync::logger.debug("update_on_caldav")
                    TimelogSync.update(self)
                end

                def delete_from_caldav
                    TimelogSync::logger.debug("delete_from_caldav")
                    TimelogSync.delete(self)
                end
            end

        end

    end

end