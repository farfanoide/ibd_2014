INTRODUCCION A LAS BASES DE DATOS - SQL – EJERCITACION
======================================================


Ejercicio 1
-----------

Dadas las siguientes relaciones, resolver en SQL las consultas planteadas:

```
Socio          = (Cod_Socio, DNI, Apellido, Nombre, Fecha_Nacimiento, Fecha_Ingreso)
Libro          = (ISBN, Titulo, Cod_Genero, Descripcion)
Copia          = (ISBN, Nro_Ejemplar, Estado)
Editorial      = (Cod_Editorial, Denominacion, Telefono, Calle, Numero, Piso, Dpto.)
LibroEditorial = (ISBN, Cod_Editorial, Anio_Edicion)
Genero         = (Cod_Genero, Nombre)
Prestamo       = (Nro_Prestamo, Cod_Socio, ISBN, Nro_Ejemplar, Fecha_Prestamo, Fecha_Devolucion)
```

1. Listar el Apellido y Nombre de aquellos socios cuya fecha de ingreso este
entre el 01/9/2008 y el 30/09/2008. Dicho listado deberá estar ordenado por
Apellido.

2. Listar el Titulo, Genero (el Nombre del Genero) y Descripcion de aquellos
libros editados por la editorial "Nueva Editorial". Dicho listado deberá estar
ordenado por Titulo.

3. Listar el Apellido, Nombre, Fecha de Nacimiento y cantidad de prestamos de
aquellos socios que tengan más de 10 prestamos. Dicho listado deberá estar
ordenado por Apellido.

4. Listar el DNI, Apellido y Nombre de aquellos socios que tengan prestamos sin
devolver de libros editados por la editorial "Gran Editorial". Dicho listado
deberá estar ordenado por Apel ido y Nombre.

5. Proyectar que cantidad de socios tienen actualmente libros prestados cuyo
estado sea "Bueno".

6. Listar el Titulo, Genero, Denominacion de la editorial y Año de edicion de
aquellos libros editados entre los años 1980 y 2000. Dicho listado deberá estar
ordenado por año de edicion y titulo del libro.

7. Agregar un nuevo socio con el DNI, Apellido, Nombre y Fecha de nacimiento
que prefiera.

8. Modificar el titulo del libro cuyo ISBN es 2222-2020 por el titulo "El
Codigo".

9. Listar el DNI, Apellido y Nombre de aquellos socios cuyo Apellido contenga
la secuencia de letras "bra" o posea prestamos actuales de libros cuyo genero
empieza con la letra "T". Dicho listado deberá estar ordenado por Apellido.

10. Listar para cada Genero la cantidad de prestamos en que estuvo involucrado.
Dicho Listado deberá estar ordenado en forma descendente de acuerdo a la
cantidad de prestamos resultante para cada genero.

Ejercicio 2
-----------

Dadas las siguientes relaciones, resolver en SQL las consultas planteadas:

```
Persona        = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
Alumno         = (DNI, Legajo, Anio_Ingreso)
Profesor       = (DNI, Matricula, Nro_Expediente)
Titulo         = (Cod_Titulo, Nombre, Descripcion)
TituloProfesor = (Cod_Titulo, DNI, Fecha)
Curso          = (Cod_Curso, Nombre, Descripcion, Fecha_Creacion, Duracion)
AlumnoCurso    = (DNI, Cod_Curso, Anio, Desempenio, Calificacion)
ProfesorCurso  = (DNI, Cod_Curso, Fecha_Desde, Fecha_Hasta)
```

1. Listar el DNI, Apellido, Nombre, Genero y Fecha de nacimiento de los alumnos
y profesores de la institucion detallando por cada uno que rol cumple, alumno o
profesor. Además, el genero se debe proyectar de forma que se lea "femenino" o
"masculino" y no "F" o "M". Dicho listado deberá estar ordenado por Apellido y
Nombre.

```sql
select dni, apellido,nombre,genero, 'profesor' as rol,
case genero
'm' then 'masculino'
'f' then 'femenino'
'h' then 'hermafrodita'
't' then 'traba'
end case
from persona natural join profesor
union (
  select dni, apellido,nombre,genero, 'alumno' as rol <- esto funca!
case genero
'm' then 'masculino'
'f' then 'femenino'
'h' then 'hermafrodita'
't' then 'traba'
end case
)
```

2. Listar el DNI, Apellido, Nombre y Matricula de aquellos profesores que
posean tres titulos o más. Dicho listado deberá estar ordenado por Apellido y
Nombre.

```sql
select dni, apellido, nombre, matricula
from persona natural join profesor natural join titulo_profesor
group by dni, apellido, nombre, matricula
having (count(Cod_Titulo) > 3)
order by apellido, nombre
```

3. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que
dicta cada profesor. La cantidad de horas se calcula como la suma de la
duracion de todos los cursos que dicta. Dicho listado deberá estar ordenado por
Apellido y Nombre.

```sql
SELECT
    DNI, apellido, nombre, SUM(duracion) cant_horas, AVG(cant_horas)
FROM
    persona NATURAL JOIN
    profesor NATURAL JOIN
    profesor_curso NATURAL JOIN
    curso
GROUP BY dni, apellido, nombre
ORDER BY apellido, nombre
```

4. Listar el DNI, Apellido, Nombre y Calificacion de aquellos alumnos que
obtuvieron una calificacion superior a 5 en los cursos que dicta el profesor
"Rodriguez". Dicho listado deberá estar ordenado por Apellido.

```sql
SELECT
    dni, apellido, nombre, calificacion
FROM
    persona NATURAL JOIN
    alumno NATURAL JOIN
    AlumnoCurso
WHERE
    calificacion > 5 AND Cod_Curso IN (
        SELECT Cod_Curso
        FROM
            persona NATURAL JOIN
            profesor NATURAL JOIN
            profesor_curso
        WHERE apellido = 'rodriguez')
```

5. Listar el Nombre, Descripcion, Fecha de creacion del curso que posea más
horas de duracion y del que menos horas posea.

6. Listar el DNI, Apellido, Nombre, Legajo y Año_Ingreso de aquellos alumnos
que cursaron todos los cursos sin importar la calificacion que obtuvieron.

7. Agregar un profesor con los datos que prefiera y agregarle el titulo con
codigo: 20.

8. Modificar el año de ingreso del alumno cuyo legajo es "1111/1", el nuevo año
a registrar es 2000.

9. Dar de baja el curso con codigo 5. Realizar todas las bajas necesarias para
no dejar el conjunto de relaciones en estado inconsistente.

Ejercicio 3
-----------

Dadas las siguientes relaciones, resolver en SQL las consultas planteadas:

```
Cliente  = (Nro_Cliente, DNI, Apellido, Nombre, Renta_Anual, Tipo_Cliente)
Embarque = (Nro_Embarque, Nro_Cliente, Peso, Nro_Camion, Nro_Ciudad, Fecha)
Camion   = (Nro_Camion, Marca, Modelo, Año)
Ciudad   = (Nro_Ciudad, Nombre, Poblacion)
```

1. Listar la Marca, Modelo y Año de los camiones que han llevado paquetes
(embarques) igual o superior a 1000 Kg.

2. Listar todos los datos de los embarques de más de 100 Kg.

3. Listar DNI, Apellido y Nombre de aquellos clientes cuya renta anual es
superior a 100000 pesos. Dicho listado deberá estar ordenado por Apellido y Nombre.

4. Listar el DNI, Apel ido y Nombre de aquel os clientes cuyo tipo de cliente
sea "Minorista" y que posean embarques a ciudades cuyo nombre empieza con la
letra "C". Dicho listado deberá estar ordenado por Apellido y Nombre.

5. Listar el Nombre y Poblacion de aquellas ciudades que han recibido embarques
cuyo peso sea igual o superior a 1000 Kg. Dicho listado deberá estar ordenado
por Nombre de la ciudad.

6. Listar el Nombre de aquellas ciudades que han recibido embarques de clientes
que tienen más de 100000 pesos de renta anual o que posean una poblacion
superior a 30000 habitantes.

7. Listar el DNI, Apellido, Nombre y Renta Anual de aquellos clientes que han
tenido embarques transportados en cada camion. Dicho listado deberá estar
ordenado por Apellido y Nombre.

8. Proyectar el peso promedio de los embarques destinados a ciudades cuya
poblacion es menor a 30000 habitantes.

9. Listar DNI, Apellido y Nombre de aquellos clientes en que el peso de todos
sus embarques supera los 1000 kg. Dicho listado deberá estar ordenado por
Apellido y Nombre.

10. Listar el Nombre de aquellas ciudades que han recibido embarques de todos
los clientes.

11. Listar para cada cliente el DNI, Apellido, Nombre, cantidad de embarques
enviados y peso promedio de todos sus embarques.

12. Listar para cada ciudad el Nombre y el peso máximo de todos los paquetes
que hayan sido enviado a la ciudad correspondiente.

13. Dar de baja a todas las ciudades con poblacion menor a 2000 habitantes.
Realizar todas las bajas necesarias para no dejar el conjunto de relaciones en
estado inconsistente.

14. Convierta el peso de cada embarque a libras, para ello se sabe que una
libra son 2,2 Kg. (aproximadamente).

Ejercicio 4
-----------

Dadas las siguientes relaciones, resolver en SQL las consultas planteadas:

```
Zona          = (IdZona, NombreZona)
Cine          = (IdCine, NombreCine, IdZona, Ubicacion)
Sala          = (IdCine, NumeroSala, Capacidad)
Pelicula      = (IdPelicula, Titulo, Anio, Genero, Duracion, Calificacion, Sinopsis)
ActorDirector = (IdAD, NombreAD)
Direccion     = (IdPelicula, IdAD)
Actuacion     = (IdPelicula, IdAD)
Funcion       = (IdCine, NumeroSala, IdPelicula, Fecha, Horario)
```

1. Listar el Nombre y Ubicacion de todos los cines de la zona "La Plata" que
tengan funcion para la pelicula "Spiderman 3". Dicho listado deberá estar
ordenado por Nombre.

2. Listar el Titulo, Calificacion y Sinopsis de todas las peliculas dirigidas
por "Oliver Stone" y que tenga al menos un actor cuyo nombre contenga la cadena
"ab". Dicho listado deberá estar ordenado por Titulo.

3. Listar los Titulos de las peliculas que tengan funcion en todas las zonas.

4. Listar el Nombre y Ubicacion de aquellos cines que tengan funcion para más
de 5 peliculas. Dicho listado deberá estar ordenado por Nombre en forma
descendente.

5. Listar la cantidad de cines distintos en las que se exhibe cada pelicula y
proyectar además el titulo de la misma. Dicho listado deberá estar ordenado por
cantidad en orden descendente.

6. Listar para cada zona que cantidad de peliculas distintas se exhiben. Dicho
listado deberá estar ordenado por cantidad.

Ejercicio 5
-----------

Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas:

```
Material     = (cod_material, tipo, genero, titulo, descripcion, duracion, cantidad_capitulos)
Capitulo     = (cod_material, nro_capitulo, descripcion)
Canal        = (cod_canal, nombre, numero, categoria)
Programacion = (cod_canal, cod_material, fecha, hora, nro_capitulo(opcional))
```

1. Listar el titulo, genero y descripcion del material que se emitirá hoy con
horario de comienzo entre las 16:00 hs. y las 20:00 hs. en canales de categoria
"cine y series", el listado además debe incluir la hora precisa de comienzo, el
numero de canal y la descripcion del capitulo, en caso de que figure su numero.

2. Listar el titulo, genero y descripcion del material que se emitirá hoy de
tipo "serie" y que incluya el termino "drama" en genero, el listado además debe
incluir la hora precisa de comienzo, el numero de canal y la descripcion del
capitulo, en caso de que figure su numero.

3. Listar nombre y numero de aquellos canales que poseen programacion para
todos los materiales.

(Resolver si o si utilizando la cláusula Not Exists).

4. Listar titulo, descripcion, tipo y duracion de aquellos materiales que
posean programacion para todos sus capitulos.

5. Listar para cada material el titulo, descripcion y la cantidad de canales
distintos en los que tiene programacion.

6. Asignar 0 al campo cantidad de capitulos y "null" al campo tipo a aquellos
materiales que posean programacion en un unico canal.

Ejercicio 6
-----------

Dadas las siguientes relaciones, resolver utilizando SQL las consultas
planteadas:

```
Provincia    = (IdProvincia, Nombre)
Ciudad       = (IdCiudad, Nombre, IdProvincia)
Canal        = (IdCanal, Denominacion, Direccion, Telefono, IdCiudad)
Dibujo       = (IdDibujo, Nombre, Descripcion, Anio_Creacion)
Personaje    = (IdPersonaje, Nombre, Descripcion, IdDibujo)
Programacion = (IdCanal, IdDibujo, Fecha, Horario)
```

1. Listar la denominacion, direccion y telefono de aquellos canales que
pertenezcan a la provincia de "San Luis" y que tengan programacion para el
dibujo "Thundercats". Dicho listado deberá estar ordenado por denominacion.

2. Listar el nombre y año de creacion de todos los dibujos que posean año de
creacion entre los años 1900 y 2000 o que tengan al menos un personaje cuyo
nombre finalice con la cadena "abe". Dicho listado deberá estar ordenado por
nombre.

3. Listar el identificador y el Nombre de los dibujos que tengan programacion
en todos los canales.

4. Listar el Nombre y Descripcion de aquellos dibujos que tengan programacion
en la provincia de "San Luis" y no posean programacion en la provincia de "San
Juan".

5. Listar la Denominacion, Direccion y Telefono de aquellos canales que tengan
programacion para más de 10 dibujos.

Ejercicio 7
-----------

Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas:

```
Congreso = (IdCongreso, Nombre, Fecha_Inicio, Fecha_Fin)
Area     = (IdArea, Nombre, Descripcion)
Posee    = (IdCongreso, IdArea)
Articulo = (IdArticulo, Titulo, Cantidad_Hojas, Fecha_Recepcion, IdArea, IdCongreso)
Autor    = (Dni, Nombre, Apellido)
Escribe  = (IdArticulo, Dni)
```

1. Listar el nombre y apellido de aquel os autores que presentaron articulos en
el congreso "WICC 2009" pero que no hayan presentado en el congreso "TE&ET
2009".

2. Anular el id de congreso (IdCongreso) de aquellos articulos presentados en
el congreso "CACIC 2008" que tengan codigo de área nula (articulos rechazados).

3. Listar el nombre, fecha de inicio y fecha de fin de aquellos congresos en
los que se hayan presentado más de 100 articulos.

4. Listar la cantidad de articulos recibidos por área para todos los congresos.
Dicho listado deberá estar ordenado nombre de congreso, nombre de área y
cantidad.

5. Listar el titulo de todos los articulos enviados al congreso "CACIC 2010" y
el nombre del área a la que pertenece. Tener en cuenta que algunos autores no
definen el área del congreso, pero es importante mostrar el articulo en el
listado.

6. Listar el nombre de todos los congresos que hayan recibido articulos para
todas las áreas.

Ejercicio 8
-----------

Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas:

```
Cliente    = (nroClte, apellido, nombres, domicilio, telefono)
Pago       = (nroClte, anio, mes, veces_por_semana, fechaPago, importePagado)
Actividad  = (codActiv, nombre)
Abono      = (nroClte, año, mes, codActiv)
Asistencia = (codActiv, fecha, nroClte)
```

1. Reportar el numero de cliente y la cantidad de veces por semana que puede
asistir" Luque, Joaquin" en diciembre de 2009 junto con la cantidad de veces
que asistio entre los dias 14 y 17.

2. Reportar la fecha de pago del cliente 1749 para el abono a Stretching de
diciembre de 2009.

3. Registrar la asistencia del cliente Luque, Joaquin a la actividad Stretching
el "17/12/09".

4. Reportar apel ido y nombre de los clientes que asistieron por primera vez a
"Aerobica" entre el 1 y el 30 de noviembre de 2009.

5. Reportar el apellido y nombre de los clientes que no asistieron a alguna
actividad, entre el 14 y el 19, para la que pagaron abono en el mes de
diciembre de 2009.

6. Cambiar el abono a la actividad Stretching de Palacios, Virginia de
diciembre de 2009 por un abono a la actividad Aerobica.

Ejercicio 9
-----------

Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas:

```
Tecnico            = (codTec, nombre, especialidad)
Repuesto           = (codRep, nombre, stock, precio)
RepuestoReparacion = (nroReparac, codRep, cantidad, precio)
Reparacion         = (nroReparac, codTec, precio_total, fecha)
```

1. Listar para cada repuesto nombre, stock y cantidad reparaciones en las que
participo. Si un repuesto no participo en alguna reparacion igual debe aparecer
en dicho listado.

2. Listar para cada tecnico el nombre, especialidad y la cantidad de
reparaciones realizadas en el mes de octubre. Dicho listado deberá estar
ordenado por nombre de manera descendente.

3. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y
que dicho repuesto no haya estado en reparaciones durante el mes de octubre.

4. Proyectar precio, fecha y precio total de aquellas reparaciones donde se
utilizo algun repuesto con precio en el momento de la reparacion mayor a $100 y
menor a $500.

5. Listar para cada tecnico la cantidad de reparaciones que realizo. Se debe
proyectar el nombre y especialidad del tecnico, junto a la cantidad solicitada.

6. Listar el numero de reparacion y precio total de aquellas reparaciones que
necesitaron más de 5 repuestos.

