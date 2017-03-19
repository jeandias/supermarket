module API
  module Entities
    class Brand < Grape::Entity
      include API::Entities::Defaults

      expose :products, using: Entities::Base, documentation: { type: Array, desc: 'Products of Brand', is_array: true }
    end
  end
end
