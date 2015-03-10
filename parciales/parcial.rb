#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'faker'

`mysql -uroot -p -e 'CREATE DATABASE IF NOT EXISTS parcial;'`
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root:root@localhost/parcial')

class Ciudad
  include DataMapper::Resource

  property :id, Serial
  property :codCiudad, String
  property :nombre, String
  property :habitantes, String

end


class Empleado
  include DataMapper::Resource

  property :id, Serial
  property :dni, String
  property :nombre, String
  property :apellido, String
  property :fechaIngreso, String
  property :salario, String
  property :codCiudad, String

end


class Edificio
  include DataMapper::Resource

  property :id, Serial
  property :codEdificio, String
  property :calle, String
  property :numero, String
  property :codCiudad, String

end


class Limpieza
  include DataMapper::Resource

  property :id, Serial
  property :codEdificio, String
  property :dni, String
  property :fecha, String

end

DataMapper.finalize
DataMapper.auto_migrate!

cant_ciudades    = 7
cant_empleados   = 10
cant_edif        = 5
limpiezas_amount = 10

cant_ciudades.times do |index|
  Ciudad.create(
    codCiudad: index + 1,
    nombre: Faker::Lorem.words(3).join(' ').capitalize
  )
end

cant_empleados.times do
  Empleado.create(
    dni: Faker::Code.ean,
    nombre: Faker::Name.name,
    apellido: Faker::Name.last_name,
    fechaIngreso: Faker::Date.backward(600),
    salario: Faker::Code.rand_in_range(300, 1000),
    codCiudad: Faker::Code.rand_in_range(1, cant_ciudades)
  )
end

cant_edif.times do |index|
  Edificio.create(
    codEdificio: index + 1,
    calle: Faker::Address.street_name,
    codCiudad: Faker::Code.rand_in_range(1, cant_ciudades)
  )
end

dnis = Empleado.all.map(&:dni)

Edificio.all.each do |edificio|
  Random.rand(limpiezas_amount).times do
    Limpieza.create(
      codEdificio: edificio.id,
      dni: dnis.sample,
      fecha: Faker::Date.backward(365)
    )
  end
end


# SELECT * FROM empleados where year(empleados.fecha_ingreso) = 2014 and empleados.dni not in ( select dni from limpiezas l inner join edificios e   on l.cod_edificio = e.cod_edificio where calle = 'Herman Divide'     )
# select nombre, habitantes, count(cod_edificio) cant from ciudads c left join edificios e on c.cod_ciudad = e.cod_ciudad group by c.cod_ciudad, c.nombre, c.habitantes order by cant desc
# select * from empleados e where e.salario > 500 and not exists (select * from limpiezas l where e.dni = l.dni);
# select c.nombre, avg(e.salario) from ciudads c left join empleados e on c.cod_ciudad = e.cod_ciudad group by c.cod_ciudad, c.nombre;
