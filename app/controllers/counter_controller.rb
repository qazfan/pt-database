class CounterController < ApplicationController
  def index
    @petname = if valid_petname?(params[:petname])
      params[:petname]
    else
      raise ActionController::RoutingError.new('Not Found')
    end

    @counter = Counter.find_or_create_by(name: @petname)
    @counter.increment!

    render('counter/index', formats: [:svg])
  end

  def valid_petname?(petname)
    petname.length <=20 &&
      petname.length >= 3 &&
      petname =~ /^[a-zA-Z0-9_]+$/
  end
end
