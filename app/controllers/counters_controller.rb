class CountersController < ApplicationController
  def index
    @top_counters = Counter.order(visits: :desc).limit(10)
  end

  def image
    unless ['neopets.com', 'localhost'].include?(URI.parse(request.referer)&.host)
      head :forbidden and return
    end
    @petname = if valid_petname?(params[:petname])
      params[:petname]
    else
      raise ActionController::RoutingError.new('Not Found')
    end

    @counter = Counter.find_or_create_by(name: @petname)
    @counter.increment!

    render('counters/image', formats: [:svg])
  end

  def valid_petname?(petname)
    petname.length <=20 &&
      petname.length >= 3 &&
      petname =~ /^[a-zA-Z0-9_]+$/
  end
end
