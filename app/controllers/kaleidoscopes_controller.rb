class KaleidoscopesController < ApplicationController
  # GET to /pets/:id
  def show
    render('kaleidoscopes/kaleidoscope', formats: [:svg])
  end
end
