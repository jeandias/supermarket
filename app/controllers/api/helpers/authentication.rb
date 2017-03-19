module API
  module Helpers
    module Authentication
      def current_user
        @current_user ||= AuthorizeApiRequest.call(request.headers).result
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end
  end
end
