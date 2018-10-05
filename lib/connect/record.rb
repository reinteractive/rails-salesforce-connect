# frozen_string_literal: true
require 'active_support/concern'

module Connect
  module Record
    extend ActiveSupport::Concern

    included do
      self.inheritance_column = 'rails_type'

      alias_attribute :created_at, :createddate
      alias_attribute :updated_at, :systemmodstamp

      class_attribute :syncs_to_salesforce
      validates :sfid, presence: true, unless: :syncs_to_salesforce?
    end

    class_methods do
      # Automatically update timestamps on save
      def timestamp_attributes_for_create
        super << "createddate"
      end

      def timestamp_attributes_for_update
        super << "systemmodstamp"
      end

      def syncs_to_salesforce!
        self.syncs_to_salesforce = true
      end

      # Lets you insert to salesforce tables from tests on an opt-in basis
      def seeding_development_data
        old_value = self.syncs_to_salesforce
        self.syncs_to_salesforce = true
        yield
        self.syncs_to_salesforce = old_value
      end
    end

    def readonly?
      return false unless self.class.syncs_to_salesforce?
      super
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
