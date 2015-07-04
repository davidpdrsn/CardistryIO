module Api
  class Controller < ApplicationController
    protect_from_forgery with: :null_session
  end
end
