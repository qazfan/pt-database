class Pet < ActiveRecord::Base
  attr_accessor :data # Not defined until you `fetch_data`
  validates_presence_of :name, :species, :color
  validates :description, length: { maximum: 500,
    too_long: "%{count} characters is the maximum allowed for descriptions." }, 
    obscenity: true
  validates :agreement, acceptance: true
  validates :name, uniqueness: {message: "Opps, this pet is already in the database!"}, length: { maximum: 20,
    too_long: "%{count} characters is the maximum allowed for names." }, format: { with: /\A[a-zA-Z0-9\_]+\z/, message: "can only have numbers, letters and underscores." }, 
    obscenity: true
  
  belongs_to :user

  def fetch_data
    return @data if defined? @data
    url = "http://www.neopets.com/amfphp/json.php/CustomPetService.getViewerData/" + name
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @data = JSON.parse(response)
  end
  
  def self.namesearch(namesearch)
    where("name LIKE ?", "%#{namesearch}%") 
  end
  
  def self.rangebdsearch(minbdsearch, maxbdsearch)
   where("hsd >= ?", minbdsearch).where("hsd <= ?", maxbdsearch)
  end
  
  def self.minbdsearch(minbdsearch)
   where("hsd >= ?", minbdsearch)
  end
  
  def self.maxbdsearch(maxbdsearch)
   where("hsd <= ?", maxbdsearch)
  end
  
  def self.colorsearch(colorsearch)
    where("color LIKE ?", "%#{colorsearch}%")
  end
  
  def self.speciessearch(speciessearch)
    where("species LIKE ?", "%#{speciessearch}%")
  end
  
  def self.ucsearch(ucsearch)
    where(:uc => ucsearch != "false")
  end
  
  def self.rnrwsearch(rwsearch, rnsearch)
    where("rw = ? OR rn = ?", true, true)
  end
  
  def self.rwsearch(rwsearch)
    where(:rw => rwsearch != "false")
  end
  
  def self.rnsearch(rnsearch)
    where(:rn => rnsearch != "false")
  end
  
  def self.uftsearch(uftsearch)
    where(:uft => uftsearch != "false")
  end
  
  def self.ufasearch(ufasearch)
    where(:ufa => ufasearch != "false")
  end
  
  def self.namelengthsearch(namelengthsearch)
    length = namelengthsearch.to_i
    where("LENGTH(name) = ?", length)
  end
  
  self.per_page = 20
  
end