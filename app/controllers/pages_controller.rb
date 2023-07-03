class PagesController < ApplicationController
    def home
      @pets = Pet.all
      @pet = Pet.new
    end
    
    def about
    end
    
    def rules
    end
end