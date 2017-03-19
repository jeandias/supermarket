module API
  module V1
    class Authentication < Grape::API
      include API::V1::Defaults

      format :json
      prefix :v1

      resource :authenticate do
        desc 'Authentication'
        params do
          requires :email, type: String, desc: 'E-mail'
          requires :password, type: String, desc: 'Password'
        end
        post do
          command = AuthenticateUser.call(params[:email], params[:password])
          if command.success?
            {auth_token: command.result}
          else
            error!({message: command.errors}, 401)
          end
        end
      end
    end
  end
end
