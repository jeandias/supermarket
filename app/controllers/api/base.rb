module API
  class Base < Grape::API
    format :json

    mount API::V1::Authentication
    mount API::V1::Brands
    mount API::V1::Products

    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    add_swagger_documentation format: :json,
                              hide_documentation_path: true,
                              api_version: 'v1',
                              info: {
                                  title: "Brands and Products",
                                  description: "Demo app for portifolio"
                              },
                              base_path: '/'
  end
end
