module API
  module V1
    class Products < Grape::API
      include API::V1::Defaults

      format :json
      prefix :v1

      helpers API::Helpers::Authentication

      resource :products do
        before do
          authenticate!
        end

        desc 'Create a product' do
          http_codes [
                         {code: 201, message: 'Product created'},
                         {code: 422, message: 'Validation Errors', model: Entities::ApiError}
                     ]
        end
        params do
          requires :name, type: String, desc: 'Name of Product to create'
          requires :brand_id, type: Integer, desc: 'Associated Brand to create', documentation: {example: 1}
        end

        post do
          product = Product.new(name: params[:name])
          product.brand_id = params[:brand_id]
          product.save!

          present product, with: Entities::Product
        end

        desc 'Get all products',
             is_array: true,
             http_codes: [
                 {code: 200, message: 'get Products', model: Entities::Product},
                 {code: 422, message: 'ProductsOutError', model: Entities::ApiError}
             ]
        get do
          products = Product.order(:name).all
          present products, with: Entities::Product
        end

        desc 'Returns specific product' do
          http_codes [
                         {code: 422, message: 'ProductsOutError', model: Entities::ApiError}
                     ]

        end
        params do
          requires :id, type: Integer, desc: 'Identifier of Product', documentation: {example: '1'}
        end
        get ':id' do
          product = Product.find_by(id: params[:id])
          present product, with: Entities::Product
        end

        desc 'Update a product' do
          http_codes [
                         {code: 422, message: 'Validation Errors', model: Entities::ApiError}
                     ]
        end
        params do
          requires :id, type: Integer, desc: 'Identity of Product', documentation: {example: 1}
          requires :name, type: String, desc: 'Name of Product', documentation: {example: 'Milk'}
          requires :brand_id, type: Integer, desc: 'Associated Brand of Product', documentation: {example: 1}
        end

        put ':id' do
          product = Product.find_by(id: params[:id])
          product.name = params[:name]
          product.brand_id = params[:brand_id]
          product.save!

          present product, with: Entities::Product
        end

        desc 'Delete a product'
        params do
          requires :id, type: Integer, desc: 'Identity of Product to delete', documentation: {example: '1'}
        end
        delete ':id' do
          Product.destroy(params[:id])
        end
      end
    end
  end
end
