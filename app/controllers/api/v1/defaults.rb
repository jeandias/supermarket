module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        # global handler for simple not found case
        rescue_from ActiveRecord::RecordNotFound do |e|
          error!({message: e.message, with: Entities::ApiError}, 404)
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          error!({message: "Internal server error: #{e}", with: Entities::ApiError}, 500)
        end
      end
    end
  end
end
