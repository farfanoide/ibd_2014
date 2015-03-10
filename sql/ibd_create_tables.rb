#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'data_mapper'
require 'faker'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root:root@localhost/ibd_psql_e1')

class Socio
  include DataMapper::Resource

  property :id               , Serial
  property :dni              , String
  property :apellido         , String
  property :nombre           , String
  property :fecha_nacimiento , Date
  property :fecha_ingreso    , Date

end

class Libro
  include DataMapper::Resource

  property :id          , Serial
  property :isbn        , String
  property :titulo      , String
  property :descripcion , Text

  belongs_to :genero
  has n, :copias

  def self.crear_titulo
    Faker::Lorem.words(
      Faker::Code.rand_in_range(3,13))
      .join(' ')
      .capitalize
      .slice(1..50)
  end
end

class Copia
  include DataMapper::Resource

  property :id     , Serial
  property :isbn   , String
  property :estado , Boolean

  belongs_to :libro
end

class Editorial
  include DataMapper::Resource

  property :id           , Serial
  property :denominacion , String
  property :telefono     , String
  property :calle        , String
  property :numero       , String
  property :piso         , String
  property :dpto         , String
end

class LibrosEditorial
  include DataMapper::Resource

  property :id           , Serial
  property :anio_edicion , String

  belongs_to :editorial
  belongs_to :libro
end

class Genero
  include DataMapper::Resource

  property :id     , Serial
  property :nombre , String

  has n, :libros
end

class Prestamo
  include DataMapper::Resource

  property :id               , Serial
  property :isbn             , String
  property :fecha_prestamo   , Date
  property :fecha_devolucion , Date

  belongs_to :socio
  belongs_to :copia
end

DataMapper.finalize
DataMapper.auto_migrate!


socios_amount    = 10
libros_amount    = 200
generos_amount   = 10
copias_amount    = 5
editorial_amount = 10

generos_amount.times do
  Genero.create(nombre: Faker::Lorem.words(3).join(' ').capitalize)
end

socios_amount.times do
  Socio.create(
    dni: chamullo_dni,
    apellido: Faker::Name.last_name,
    nombre: Faker::Name.first_name,
    fecha_nacimiento: Faker::Date.backward(20000),
    fecha_ingreso: Faker::Date.backward(6000)
  )
end

libros_amount.times do
  Libro.create(
    isbn: Faker::Code.isbn,
    titulo: Libro.crear_titulo,
    descripcion: Faker::Lorem.paragraph,
    genero_id: Faker::Code.rand_in_range(1, generos_amount)
  )
end


editorial_amount.times do
  Editorial.create(
    denominacion: Faker::Company.name,
    telefono: Faker::PhoneNumber.cell_phone,
    calle: Faker::Lorem.words(3).join(' ').capitalize,
    numero: Faker::Number.number(4),
    piso: Faker::Number.number(4),
    dpto: Faker::Number.number(4)
  )
end

Libro.all.each do |libro|
  Random.rand(copias_amount).times do
    Copia.create(
      estado: [true, false].sample,
      isbn: libro.isbn,
      libro_id: libro.id
    )
  end
  LibrosEditorial.create(
    libro_id: Faker::Code.rand_in_range(1,libros_amount),
    editorial_id: Faker::Code.rand_in_range(1,editorial_amount),
    anio_edicion: Faker::Date.backward(Random.rand(50000)).year
  )
end
