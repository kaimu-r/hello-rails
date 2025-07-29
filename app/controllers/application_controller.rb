class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render "errors/not_found", layout: "error", status: :not_found
  end
end
