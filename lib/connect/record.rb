require 'active_support/concern'

module Connect
  module Record
    extend ActiveSupport::Concern

    included do
      self.inheritance_column = 'rails_type'
      self.primary_key = :sfid

      alias_attribute :created_at, :createddate
      alias_attribute :updated_at, :systemmodstamp
    end

    class_methods do
      # Automatically update timestamps on save
      def timestamp_attributes_for_create
        super << "createddate"
      end

      def timestamp_attributes_for_update
        super << "systemmodstamp"
      end
    end

    def synced?
      _hc_err.blank? && sfid.present?
    end

    def sync_failed?
      _hc_err.present?
    end

    # Waits until salesforce allocates an SFID and syncs it back to heroku connect.
    # Persistent failures can occur E.G. if there are duplication rules on the
    # salesforce side.
    def await_sync(timeout: 25, poll: 5, allocate_sfid_locally: !Rails.env.production?)
      return true if synced?

      if allocate_sfid_locally
        update sfid: SecureRandom.base58(18)
      else
        begin
          Timeout::timeout(timeout) do
            loop do
              sleep poll

              if reload.synced?
                break
              end

              return false if sync_failed? # Bail immediately if sync fails
            end
          end
        rescue Timeout::Error
          return false
        end
      end
      true
    end

  end
end
