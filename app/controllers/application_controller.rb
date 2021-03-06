class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    helper_method :user_signed_in?, :current_user,
        :authenticate_user!, :latest

    private

    # Emulate some devise helpers...
    def current_user
        user_signed_in? ? User.find(session[:user_id]) : nil
    end

    def user_signed_in?
        if session[:user_id]
            # If session is set, ensure user exists
            # and clear session if not
            if not User.where(id: session[:user_id]).any?
                session[:user_id] = nil
            end

            session[:user_id]
        else
            nil
        end
    end

    def authenticate_user!
        if not user_signed_in?
            redirect_to '/auth/github'
        end
    end

    # Get x most recent entries from a query
    def latest(query, limit=25)
        query.order(created_at: :desc)
            .limit(limit)
    end
end
