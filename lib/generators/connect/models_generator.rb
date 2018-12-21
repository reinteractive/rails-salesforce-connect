# frozen_string_literal: true
module Connect
  class ModelsGenerator < Rails::Generators::Base

    desc "Generates commonly used models for heroku connect"

    class_option :module, type: :string, default: 'Salesforce'

    def create_account
      create_file "#{directory}/account.rb", <<-FILE
module #{modname}
  class Account < ApplicationRecord
    require 'connect/record'
    include Connect::Record
    self.table_name = "salesforce.account"

    has_many :salesforce_contacts, class_name: "#{modname}::Contact",
      foreign_key: :accountid, primary_key: :sfid, dependent: :nullify

    has_one :salesforce_contract, class_name: "#{modname}::Contract",
      foreign_key: :accountid, primary_key: :sfid, dependent: :nullify
  end
end
      FILE
    end

    def create_contact
      create_file "#{directory}/contact.rb", <<-FILE
module #{modname}
  class Contact < ApplicationRecord
    require 'connect/record'
    include Connect::Record
    self.table_name = "salesforce.contact"

    validates :email, presence: true, uniqueness: true

    belongs_to :salesforce_account, class_name: "Salesforce::Account",
      primary_key: :sfid, foreign_key: :accountid, optional: true

    scope :by_email, -> (email) {
      where('LOWER(TRIM(email)) = LOWER(TRIM(?))', email)
    }

    def email=(value)
      self[:email] = value.to_s.strip.downcase
    end
  end
end
      FILE
    end

    def create_contract
      create_file "#{directory}/contract.rb", <<-FILE
module #{modname}
  class Contract < ApplicationRecord
    require 'connect/record'
    include Connect::Record
    self.table_name = "salesforce.contract"

    belongs_to :salesforce_account, class_name: "Salesforce::Account",
      primary_key: :sfid, foreign_key: :accountid
  end
end
      FILE
    end

    def modname
      options['module']
    end

    def directory
      "app/models/#{modname.underscore}"
    end
  end
end