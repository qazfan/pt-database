namespace :periodic do
  task check_owners: :environment do
    byebug
    pets_to_destroy = Pet.all.select do |pet|
      new_owner = pet.fetch_data['custom_pet']['owner']
      new_owner && new_owner != pet.owner
    end
    pets_to_destroy.destroy_all
  end
end
