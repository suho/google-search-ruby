# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization

  before_action :authenticate_user!
end
