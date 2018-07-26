class ApiResponder < ActionController::Responder
  def respond
    raise MissingRenderer.new(format) unless has_renderer?

    if delete?
      head :no_content
    elsif post?
      display resource, status: :created
    else
      display resource
    end
  end
end
