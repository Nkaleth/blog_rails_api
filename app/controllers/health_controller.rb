class HealthController < ApplicationController
  def health
    render json: {
      api: 'Ok'
    },
    status: :ok
  end
end