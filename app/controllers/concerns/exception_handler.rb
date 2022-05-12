module ExceptionHandler
  extend ActiveSupport::Concern

  included do
   rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
   rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
   rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
 end


  private
    def render_not_found(exception)
      respond_with_error("not_found")
    end

    def render_record_invalid(exception)
      respond_with_error("invalid_resource", exception.record.errors.to_hash)
    end

    def render_parameter_missing(exception)
      respond_with_error("missing_param")
    end

    def respond_with_error(error, errors = nil)
      error = API_ERRORS[error]
      error["details"] = errors if errors
      render json: error, status: error["status"]
    end
end
