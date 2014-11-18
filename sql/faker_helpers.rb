require 'faker'
require 'dm-core'

def fake_title
  Faker::Lorem.words( Faker::Code.rand_in_range(3,13)).join(' ').capitalize.slice(0..49)
end

def fake_full_name;
  Faker::Name.name
end

def fake_name
  Faker::Name.first_name
end

def fake_isbn
  Faker::Code.isbn
end

def fake_dni
  Faker::Code.rand_in_range(25000000, 40000000).to_s
end

def fake_last_name
  Faker::Name.last_name
end

def fake_birth_date
  Faker::Date.backward(30000)
end

def fake_date
  Faker::Date.backward(10000)
end

def fake_paragraph
  Faker::Lorem.paragraph
end

def fake_association_id(model)
  Faker::Code.rand_in_range(1, (model.constantize.send(:all).size || 0))
end
