module API
  module Entities
    class Product < Grape::Entity
      include API::Entities::Defaults

      expose :brand, using: Entities::Base, documentation: { type: Integer, desc: 'Identity of associated Product' }
    end
  end
end
