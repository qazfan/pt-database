require 'net/http'
require 'json'

class PetsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  SPECIES_BY_ID = {
    1 => 'Acara', 2 => 'Aisha', 3 => 'Blumaroo', 4 => 'Bori', 5 => 'Bruce', 6 => 'Buzz',
    7 => 'Chia', 8 => 'Chomby', 9 => 'Cybunny', 10 => 'Draik', 11 => 'Elephante',
    12 => 'Eyrie', 13 => 'Flotsam', 14 => 'Gelert', 15 => 'Gnorbu', 16 => 'Grarrl',
    17 => 'Grundo', 18 => 'Hissi', 19 => 'Ixi', 20 => 'Jetsam', 21 => 'Jubjub',
    22 => 'Kacheek', 23 => 'Kau', 24 => 'Kiko', 25 => 'Koi', 26 => 'Korbat',
    27 => 'Kougra', 28 => 'Krawk', 29 => 'Kyrii', 30 => 'Lenny', 31 => 'Lupe',
    32 => 'Lutari', 33 => 'Meerca', 34 => 'Moehog', 35 => 'Mynci', 36 => 'Nimmo',
    37 => 'Ogrin', 38 => 'Peophin', 39 => 'Poogle', 40 => 'Pteri', 41 => 'Quiggle',
    42 => 'Ruki', 43 => 'Scorchio', 44 => 'Shoyru', 45 => 'Skeith', 46 => 'Techo',
    47 => 'Tonu', 48 => 'Tuskaninny', 49 => 'Uni', 50 => 'Usul', 55 => 'Vandagyre',
    51 => 'Wocky', 52 => 'Xweetok', 53 => 'Yurble', 54 => 'Zafara', 55 => 'New Species'
  }

  COLORS_BY_ID = {
    92 => '8-Bit', 101 => 'Agueena', 1 => 'Alien', 2 => 'Apple',
    3 => 'Asparagus', 4 => 'Aubergine', 5 => 'Avocado', 6 => 'Baby', 7 => 'Biscuit',
    8 => 'Blue', 9 => 'Blueberry', 10 => 'Brown', 11 => 'Camouflage', 12 => 'Carrot',
    13 => 'Checkered', 14 => 'Chocolate', 15 => 'Chokato', 16 => 'Christmas',
    17 => 'Clay', 18 => 'Cloud', 19 => 'Coconut', 20 => 'Custard', 21 => 'Darigan',
    22 => 'Desert', 100 => 'Dimensional', 23 => 'Disco', 24 => 'Durian',
    97 => 'Elderlyboy', 98 => 'Elderlygirl', 25 => 'Electric', 96 => 'Eventide',
    26 => 'Faerie', 27 => 'Fire', 28 => 'Garlic', 29 => 'Ghost', 30 => 'Glowing',
    31 => 'Gold', 32 => 'Gooseberry', 33 => 'Grape', 34 => 'Green', 35 => 'Grey',
    36 => 'Halloween', 37 => 'Ice', 38 => 'Invisible', 39 => 'Island', 40 => 'Jelly',
    41 => 'Lemon', 42 => 'Lime', 87 => 'Magma', 43 => 'Mallow', 91 => 'Maractite',
    44 => 'Maraquan', 45 => 'Msp', 46 => 'Mutant', 86 => 'Onion', 47 => 'Orange',
    102 => 'Pastel', 48 => 'Pea', 49 => 'Peach', 50 => 'Pear', 51 => 'Pepper',
    52 => 'Pineapple', 53 => 'Pink', 54 => 'Pirate', 55 => 'Plum', 56 => 'Plushie',
    104 => 'PolkaDot', 57 => 'Purple', 58 => 'Quigukiboy', 59 => 'Quigukigirl',
    60 => 'Rainbow', 61 => 'Red', 88 => 'Relic', 62 => 'Robot', 63 => 'Royalboy',
    64 => 'Royalgirl', 65 => 'Shadow', 66 => 'Silver', 67 => 'Sketch', 68 => 'Skunk',
    69 => 'Snot', 70 => 'Snow', 71 => 'Speckled', 72 => 'Split', 73 => 'Sponge',
    74 => 'Spotted', 75 => 'Starry', 99 => 'Stealthy', 76 => 'Strawberry',
    77 => 'Striped', 93 => 'SwampGas', 78 => 'Thornberry', 79 => 'Tomato',
    90 => 'Transparent', 80 => 'Tyrannian', 103 => 'Ummagine', 81 => 'UsukiBoy',
    82 => 'UsukiGirl', 94 => 'Water', 83 => 'White', 89 => 'Woodland', 95 => 'Wraith',
    84 => 'Yellow', 85 => 'Zombie', 105 => 'Candy', 106 => 'Marble',
    107 => 'Steampunk', 108 => 'Toy', 109 => 'Origami', 110 => 'Oil Paint',
    111 => "New Color"
  };

  def new
    @pet = Pet.new
  end

  # GET to /pets/:id
  def show
    @pet = Pet.find( params[:id] )
  end

  # This search function is super ugly, find a way to make it nicer
  # GET to /pets
  def index
    @users = User.includes(:pet)

    if params[:namesearch].present?
      @pets = Pet.namesearch(params[:namesearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:colorsearch].present? && params[:speciessearch].present?
      @pets = Pet.colorsearch(params[:colorsearch]).order("created_at DESC")
      @pets = @pets.speciessearch(params[:speciessearch]).paginate(:page => params[:page]).order("id DESC")
      if params[:ucsearch].present? && params[:uftsearch].present? && params[:ufasearch].present?
        @pets = @pets.ucsearch(params[:colorsearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:ucsearch].present? && params[:uftsearch].present?
        @pets = @pets.ucsearch(params[:colorsearch]).order("created_at DESC")
        @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:ucsearch].present? && params[:ufasearch].present?
        @pets = @pets.ucsearch(params[:colorsearch]).order("created_at DESC")
        @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:ucsearch].present?
        @pets = @pets.ucsearch(params[:colorsearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:uftsearch].present?
        @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:ufasearch].present?
        @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")
      end

    elsif params[:colorsearch].present? && params[:ucsearch].present?
      @pets = Pet.colorsearch(params[:colorsearch]).order("id DESC")
      @pets = @pets.ucsearch(params[:ucsearch]).paginate(:page => params[:page]).order("id DESC")
      if params[:uftsearch].present? && params[:ufasearch].present?
        @pets = (@pets).paginate(:page => params[:page]).order("id DESC")
      elsif params[:uftsearch].present?
        @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:ufasearch].present?
        @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")
      end

    elsif params[:colorsearch].present? && params[:uftsearch].present? && params[:ufasearch].present?
      @pets = Pet.colorsearch(params[:colorsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:colorsearch].present? && params[:uftsearch].present?
      @pets = Pet.colorsearch(params[:colorsearch]).order("id DESC")
      @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:colorsearch].present? && params[:ufasearch].present?
      @pets = Pet.colorsearch(params[:colorsearch]).order("id DESC")
      @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:colorsearch].present?
      @pets = Pet.colorsearch(params[:colorsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:speciessearch].present? && params[:ucsearch].present?
      @pets = Pet.speciessearch(params[:speciessearch]).order("id DESC")
      @pets = @pets.ucsearch(params[:ucsearch]).paginate(:page => params[:page]).order("id DESC")
      if params[:uftsearch].present? && params[:ufasearch].present?
        @pets = (@pets).paginate(:page => params[:page], :per_page => 20).order("id DESC")
      elsif params[:uftsearch].present?
        @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")
      elsif params[:ufasearch].present?
        @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")
      end

    elsif params[:speciessearch].present? && params[:uftsearch].present? && params[:ufasearch].present?
      @pets = Pet.speciessearch(params[:speciessearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:speciessearch].present? && params[:uftsearch].present?
      @pets = Pet.speciessearch(params[:speciessearch]).order("id DESC")
      @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:speciessearch].present? && params[:ufasearch].present?
      @pets = Pet.speciessearch(params[:speciessearch]).order("id DESC")
      @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:speciessearch].present?
      @pets = Pet.speciessearch(params[:speciessearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:ucsearch].present? && params[:uftsearch].present? && params[:ufasearch].present?
      @pets = Pet.ucsearch(params[:ucsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:ucsearch].present? && params[:uftsearch].present?
      @pets = Pet.ucsearch(params[:ucsearch]).order("id DESC")
      @pets = @pets.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:ucsearch].present? && params[:ufasearch].present?
      @pets = Pet.ucsearch(params[:ucsearch]).order("id DESC")
      @pets = @pets.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:ucsearch].present?
      @pets = Pet.ucsearch(params[:ucsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:uftsearch].present? && params[:ufasearch].present?
      @pets = Pet.includes(:user).paginate(:page => params[:page]).order("id DESC")

    elsif params[:uftsearch].present?
      @pets = Pet.uftsearch(params[:uftsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:ufasearch].present?
      @pets = Pet.ufasearch(params[:ufasearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:rwsearch].present? && params[:rnsearch].present?
      @pets = Pet.rnrwsearch(params[:rwsearch], params[:rnsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:rwsearch].present?
      @pets = Pet.rwsearch(params[:rwsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:rnsearch].present?
      @pets = Pet.rnsearch(params[:rnsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:minbdsearch].present? && params[:maxbdsearch].present?
      @pets = Pet.rangebdsearch(params[:minbdsearch], params[:maxbdsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:minbdsearch].present?
      @pets = Pet.minbdsearch(params[:minbdsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:maxbdsearch].present?
      @pets = Pet.maxbdsearch(params[:maxbdsearch]).paginate(:page => params[:page]).order("id DESC")

    elsif params[:namelengthsearch].present?
      @pets = Pet.namelengthsearch(params[:namelengthsearch]).paginate(:page => params[:page]).order("id DESC")

    else
      @pets = Pet.includes(:user).paginate(:page => params[:page]).order("id DESC")
    end
  end

  def create
    @pet = current_user.pets.build( pet_params )
    data = @pet.fetch_data

    if data["error"]
      flash[:danger] = "Pet not found. Is the name spelled correctly?"
      render action: :new
      return
    end

    set_pet_data(@pet, data)

    if @pet.save
      flash[:success] = "Pet submitted!"
      redirect_to user_path( current_user.id )
    else
      flash[:danger] = @pet.errors.full_messages.join(", ")
      render action: :new
    end
  end

  def edit
    @pet = Pet.find_by_id( params[:id] )
  end

  def update
    @pet = Pet.find_by(id: params[:pet][:id])
    data = @pet.fetch_data
    return unless @pet.user_id == current_user.id || current_user&.admin?

    if data["error"]
      flash[:danger] = "That pet does not exist!"
      render action: :new
      return
    end

    set_pet_data(@pet, data)

    if @pet.update(pet_params)
      flash[:success] = "Pet updated"
      #Redirect user to pet profile page
      redirect_to controller: "pets", action: "show", id: @pet.id
    else
      render action: :edit
      Rails.logger.info(@pet.errors.messages.inspect)
    end
  end

  def destroy
    Pet.find_by(id: params[:id], user_id: current_user.id).destroy
    flash[:success] = "Pet deleted"
    redirect_to user_path(current_user.id)
  end

  private
  
  def pet_params
    params.require(:pet).permit(
      :name, :color, :species, :level, :hp, :strength, :defence, :movement,
      :hsd, :uc, :rw, :rn, :verified, :description, :uft, :ufa, :id, :agreement
    )
  end

  def set_pet_data(pet, data)
    pet.owner = data.dig("custom_pet", "owner")
    pet.uc = !!data.dig("custom_pet", "biology_by_zone", "46")
    pet.verified = !!data.dig("object_info_registry").to_h.dig("28531")
    pet.species = SPECIES_BY_ID[data["custom_pet"]["species_id"]]
    pet.color = COLORS_BY_ID[data["custom_pet"]["color_id"]]
    pet.hp ||= 0
    pet.strength ||= 0
    pet.defence ||= 0
    pet.movement ||= 0
    pet.hsd = pet.hp + [pet.defence, 750].min + [pet.strength, 750].min
  end
end
