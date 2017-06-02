# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Department.delete_all
puts 'cargando departamentos...'
Department.create(id:1,name:'Departamento de Física de Materiales')
Department.create(id:2,name:'Departamento de Ingeniería y Química de Materiales')
Department.create(id:3,name:'Departamento de Metalurgia e Integridad Estructural')
Department.create(id:4,name:'Departamento de Medio Ambiente y Energía')
Department.create(id:5,name:'Departamento de Ingeniería Sustentable')
Department.create(id:6,name:'Unidad Monterrey')
Department.create(id:7,name:'Dirección Académica')
Department.create(id:8,name:'Dirección de Vinculación')
Department.create(id:9,name:'Dirección de Administración y Finanzas')
Department.create(id:10,name:'Dirección de Planeación y Asuntos Estratégicos')
puts 'departamentos cargados'


Level.delete_all
puts 'cargando niveles...'
Level.create(id:1, full_name:'Sin Nivel', short_name:'Sin Nivel')
Level.create(id:2,full_name:'Técnico Asociado A', short_name:'TAA')
Level.create(id:3,full_name:'Técnico Asociado B', short_name:'TAB')
Level.create(id:4,full_name:'Técnico Asociado C', short_name:'TAC')
Level.create(id:5,full_name:'Técnico Titular A', short_name:'TTA')
Level.create(id:6,full_name:'Técnico Titular B', short_name:'TTB')
Level.create(id:7,full_name:'Técnico Titular C', short_name:'TTC')
Level.create(id:8,full_name:'Invesitgador Asociado C', short_name:'IAC')
Level.create(id:9,full_name:'Invesitgador Titular A', short_name:'ITA')
Level.create(id:10,full_name:'Invesitgador Titular B', short_name:'ITB')
Level.create(id:11,full_name:'Invesitgador Titular C', short_name:'ITC')
puts 'niveles cargados'
