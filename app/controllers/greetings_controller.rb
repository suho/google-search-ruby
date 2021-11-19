# frozen_string_literal: true

class GreetingsController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end
end
