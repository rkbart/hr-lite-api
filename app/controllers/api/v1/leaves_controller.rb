class Api::V1::LeavesController < ApplicationController
  def index
    render json: Leave.all
  end
end
