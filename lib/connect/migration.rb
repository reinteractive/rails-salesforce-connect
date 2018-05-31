require 'active_support/concern'

module Connect
  module Migration
    extend ActiveSupport::Concern

    # Skip running in production environments, since
    # heroku connect manages those
    def exec_migration(conn, direction)
      super unless Rails.env.production?
    end

  end
end
