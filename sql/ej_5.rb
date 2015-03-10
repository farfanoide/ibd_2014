#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'faker'

`mysql -uroot -proot -e 'CREATE DATABASE IF NOT EXISTS ej_5;'`
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root:root@localhost/ej_5')

class Material
  include DataMapper::Resource

  property :id, Serial
  property :cod_material, String
  property :tipo, String
  property :genero, String
  property :titulo, String
  property :descripcion, String
  property :duracion, String
  property :cantidad_capitulos, String

end


class Capitulo
  include DataMapper::Resource

  property :id, Serial
  property :cod_material, String
  property :nro_capitulo, String
  property :descripcion, String

end


class Canal
  include DataMapper::Resource

  property :id, Serial
  property :cod_canal, String
  property :nombre, String
  property :numero, String
  property :categoria, String

end


class Programacion
  include DataMapper::Resource

  property :id, Serial
  property :cod_canal, String
  property :cod_material, String
  property :fecha, Date
  property :hora, Time
  property :nro_capitulo, String

end

DataMapper.finalize
DataMapper.auto_migrate!

cant_materiales = 3
cant_capitulos  = 5
cant_canales    = 3


def fake_categoria
  %w(serie drama comedia).sample
end

def fake_name(amount)
  Faker::Lorem.words(amount).join(' ').capitalize
end

def fake_paragraph(amount=1)
  Faker::Lorem.paragraph(amount)
end

cant_materiales.times do |index|
  Material.create(
    cod_material: index + 1,
    tipo: fake_name(2),
    genero: fake_categoria,
    titulo: fake_name(2),
    descripcion: "xxxx #{index}",
    duracion: Random.rand(120),
    cantidad_capitulos: cant_capitulos
  )
end

materials = Material.all

materials.each do |m|
  5.times do |index|
    Capitulo.create(
      cod_material: m.id,
      nro_capitulo: index + 1,
      descripcion: "alta descripcion #{index + 1}"
    )
  end
end

cant_canales.times do |index|
  Canal.create(
    cod_canal: index + 1,
    nombre: fake_name(2),
    numero: Random.rand(50),
    categoria: fake_categoria
  )
end


Capitulo.all.each do |capitulo|
  Programacion.create(
    cod_canal: Canal.find(Faker::Code.rand_in_range(1, cant_canales)).first.id,
    cod_material: capitulo.cod_material,
    fecha: Faker::Date.forward(Random.rand(300)),
    hora: Faker::Time.forward(23),
    nro_capitulo: ([true, false].sample ? capitulo.nro_capitulo : nil )
  )
end

# SELECT m.titulo, m.genero, m.descripcion, p.hora, ca.numero, c.descripcion FROM materials m inner join programacions p on m.cod_material = p.cod_material inner join canal ca on p.cod_canal = ca.cod_canal inner join capitulos c on p.nro_capitulo = c.nro_capitulo WHERE p.hora between  ''
