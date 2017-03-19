module API
  module V1
    class Brands < Grape::API
      include API::V1::Defaults

      format :json
      prefix :v1

      helpers API::Helpers::Authentication

      resource :brands do
        before do
          authenticate!
        end

        desc 'Create a brand' do
          http_codes [
                         {code: 201, message: 'Brand created'},
                         {code: 422, message: 'Validation Errors', model: Entities::ApiError}
                     ]
        end
        params do
          requires :name, type: String, desc: 'Brand name'
        end

        post do
          brand = Brand.create!({name: params[:name]})
          present brand, with: Entities::Brand
        end

        desc 'Get all brands',
             is_array: true,
             http_codes: [
                 {code: 200, message: 'get Brands', model: Entities::Brand},
                 {code: 422, message: 'BrandsOutError', model: Entities::ApiError}
             ]
        get do
          brands = Brand.order(:name).all
          present brands, with: Entities::Brand
        end

        desc 'Returns specific brand' do
          http_codes [
                         {code: 422, message: 'BrandsOutError', model: Entities::ApiError}
                     ]

        end
        params do
          requires :id, type: Integer, desc: 'Identifier of Brand', documentation: {example: '1'}
        end
        get ':id' do
          brand = Brand.find_by(id: params[:id])
          present brand, with: Entities::Brand
        end

        desc 'Update a brand' do
          http_codes [
                         {code: 422, message: 'Validation Errors', model: Entities::ApiError}
                     ]
        end
        params do
          requires :id, type: Integer, desc: 'Identity of Brand', documentation: {example: 1}
          requires :name, type: String, desc: 'Brand name', documentation: {example: 'Milk'}
        end

        put ':id' do
          brand = Brand.find_by(id: params[:id])
          brand.name = params[:name]
          brand.save!

          present brand, with: Entities::Brand
        end

        desc 'Delete a brand'
        params do
          requires :id, type: Integer, desc: 'Identity of Brand to delete', documentation: {example: '1'}
        end
        delete ':id' do
          Brand.destroy(params[:id])
        end
      end
    end
  end
end
